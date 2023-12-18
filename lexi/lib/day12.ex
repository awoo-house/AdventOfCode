defmodule Day12 do

  @type space :: :space | :galaxy | Integer.t()

  def char("#"), do: :galaxy
  def char("."), do: :space

  def parse(input) do
    # IO.inspect("hi")
    String.split(input, "\n", trim: true)
    |> Enum.map(fn line ->
      [record, nums] = String.split(line)
      {record, String.split(nums, ",")
      |> Enum.map(fn num ->
        {n, _} = Integer.parse(num)
        n
      end)}
    end)
  end

  def parseP2(input) do
    # IO.inspect("hi")
    String.split(input, "\n", trim: true)
    |> Enum.map(fn line ->
      [raw_record, raw_nums] = String.split(line)
      [record, nums] = [
        raw_record<>"?"<>raw_record<>"?"<>raw_record<>"?"<>raw_record<>"?"<>raw_record,
        raw_nums<>","<>raw_nums<>","<>raw_nums<>","<>raw_nums<>","<>raw_nums
      ]
      {record, String.split(nums, ",")
      |> Enum.map(fn num ->
        {n, _} = Integer.parse(num)
        n
      end)}
    end)
  end

  # turn  .??..??...?##. into
  # [{"." => 1}, {"?" => 2}, {"." => 2}, ...]
  def encode(rec) do
    Enum.reduce(String.graphemes(rec), {"", 0, []}, fn this_char, {prev_char, prev_count, acc} ->
      case {this_char, prev_char} do
        {_, ""} -> {this_char, 1, []}
        {"?", "?"} -> {"?", prev_count + 1, acc}
        {"#", "#"} -> {"#", prev_count + 1, acc}
        {".", "."} -> {".", prev_count + 1, acc}
        {".", _} -> {".", 1, [{prev_char, prev_count} | acc]}
        {"?", _} -> {"?", 1, [{prev_char, prev_count} | acc]}
        {"#", _} -> {"#", 1, [{prev_char, prev_count} | acc]}
      end
    end)
    |> then(fn {prev_char, prev_count, m} -> Enum.reverse([{prev_char, prev_count} |m]) end)
  end

  def decode(enc) do
    Enum.reduce(enc, "", fn {char, n}, acc ->
      acc <> String.duplicate(char, n)
    end)
  end

  def get_number_of_possible_placements_in_fragment(sub_rec, grouping_num) do
    # First, given that we're not creating any groupings in a fragment, we can fill in gaps of ?s between #s
    # because if we have something like... ??#?#??, then a group of < 3 would be invalid.

    # IO.puts(sub_rec <> " -- " <> inspect(grouping_num))
    encs = encode(sub_rec)

    fixed = case encs do
      [{k, x}] -> [{k, x}]
      [{k0, x0},{k1, x1}] -> [{k0, x0},{k1, x1}]
      [{"?", x}, {"#", y},{"?", z}] ->
        # Correct!
        [{"?", x}, {"#", y},{"?", z}]
      _ ->
        # have to fix this
        total_chars = String.length(sub_rec)
        case {List.first(encs), List.last(encs)} do
          {{"#", _x}, {"#", _y}} ->
            # #s all the way down
            [{"#", total_chars}]
          {{"?", x}, {"?", y}} ->
            # All between should be #s
            [{"?", x}, {"#", total_chars - x - y}, {"?", y}]

          {{"#", _x}, {"?", y}} ->
            # Everything up until the last # should be #
            [{"#", total_chars - y}, {"?", y}]

          {{"?", x}, {"#", _y}} ->
            # Everything from the first # to the end should be #
            [{"?", x}, {"#", total_chars - x}]
        end
    end


    case fixed do
      [{"?", x}] when grouping_num > x -> 0
      [{"?", x}] ->
        # We can slide the grouping number anywhere along
        # So...
        # grouping_num = 3
        # ????????
        #
        # ###?????
        # ?###????
        # ??###???
        # ???###??
        # ????###?
        # ?????###
        # So it's just the number of ?s minus the grouping number? Plus one. Since it can be in both the beginning and end states.
        1 + (x - grouping_num)
      [{"#", x}] when grouping_num != x -> 0
      [{"#", _x}] -> 1
      [{"?", x}, {"#", y}] when y + x >= grouping_num and y <= grouping_num -> 1
      [{"?", _x}, {"#", _y}] -> 0
      [{"#", y}, {"?", x}] when y + x >= grouping_num and y <= grouping_num -> 1
      [{"#", _y}, {"?", _x}] -> 0
      [{"?", x}, {"#", y}, {"?", z}] when grouping_num < y or grouping_num > x + y + z -> 0
      [{"?", x}, {"#", y}, {"?", z}] when y + z < grouping_num and x + y < grouping_num ->
        # Here, we cannot make ALL of x or z .s, we have to use all three areas. So,
        # we must slide across both X and Z, and we have as many choices as we can make those slides. e.g.
        # grouping_num = 6
        # ????#????
        # Can only be...
        # ???######
        # ??######?
        # ?######??
        # ######???
        # So, choices are 1 more than the number of ?s... right? Does that makes sense? What about the following:
        #
        # grouping_num = 7
        # ??####??
        # ...
        # #######?
        # ?#######
        # Yeah, so it's more to do with like... the number of degrees of freedom from the grouping number we are. So actually it's like...
        # 2,4,2 & 7 -> 7 - 6 = 1 DOF
        # 4,1,4 & 6 -> 5 - 2 = 3 DOF
        # Well i guess it is technically a function of ?s after setting the min #s, haha.
        1 + (z + x) - (grouping_num - y)
      [{"?", _x}, {"#", y}, {"?", _z}] ->
        # Here, we can, if we so choose, set z or x to be ALL .s.
        # examples...
        #
        # grouping_num = 3
        # ????#??
        # ...
        # ????###
        # ???###?
        # ??###??
        # hmm....
        # what about...
        #
        # grouping_num = 6
        # ??????###??????
        #
        # ??????######?
        # ?????######??
        # ????######???
        # ???######????
        # So this is the degrees of freedom plus one?
        (grouping_num - y) + 1
    end
  end

  def get_and_run_for_subproblems(acc, sub_rec, groups) do
    if Enum.empty?(groups) do
      # IO.inspect("We've reached the end... sub_rec should be empty: " <> sub_rec)
      # IO.inspect(acc)
      acc
    else
      trimmed = String.trim(sub_rec, ".")
      # Here, given the remaining sub_rec and remaining groups to make, figure out what all subproblems can still be made.
      enc = encode(trimmed)
      # How many given groupings are left?
      mandatory_groups_from_rec = Enum.count(enc, fn {char, _} -> char == "." end) + 1
      groups_rem = Enum.count(groups)

      # IO.inspect(mandatory_groups_from_rec)
      # IO.inspect(groups_rem)

      case (groups_rem - mandatory_groups_from_rec) do
        0 ->
          # Easy case. We can't make any more groups, so... we just need to sum all the sub-problems
          [next_group | rest] = groups
          until_next_group = Enum.take_while(enc, fn {char, _n} -> char != "." end)
          num_until_next_period_or_end = Enum.count(until_next_group)
          sub_sub_rec = case {num_until_next_period_or_end, Enum.count(enc)} do
            {x, x} -> ""
            {x, y} when y - x > 1 ->
              {_, next} = Enum.split(enc, x + 1)
              decode(next)
            {x, y} when y - x == 1 -> ""
          end
          next_run = until_next_group
          |> decode
          |> get_number_of_possible_placements_in_fragment(next_group)


          get_and_run_for_subproblems(acc * next_run, sub_sub_rec, rest)
        _ ->
          # IO.inspect("We must MAKE some groups. acc currently: " <> inspect(acc))
          # IO.inspect(trimmed)
          # Okay, we can make at LEAST one group.
          # We need to try every group, and for all of them that have valid combinations, multiply them all together.
          all_possible_groups = all_possible_ways_to_add_one_group(trimmed)
          Enum.reduce(all_possible_groups, acc, fn sub_sub_rec, inner_acc ->
            # valid_sub_problems = 4
            valid_sub_problems = get_and_run_for_subproblems(1, sub_sub_rec, groups)
            if valid_sub_problems == 0 do
              inner_acc
            else
              IO.puts("We have some valid subproblems. The number of sols = #{inspect(valid_sub_problems)}, given this subproblem: #{sub_sub_rec}")
              inner_acc + valid_sub_problems
            end
          end)
      end
    end
  end

  def all_possible_ways_to_add_one_group(rec) do

    r = Enum.chunk_every(Enum.with_index(String.graphemes(rec)), 3, 1)

    Enum.flat_map(r, fn x ->
      case x do
        [_, _] -> [] # last char
        [_, {".", _}, _] -> [] # Not a wildcard
        [_, {"#", _}, _] -> [] # Not a wildcard
        [{".", _}, _, _] -> [] # Would just extend a group
        [_, _, {".", _}] -> [] # Would just extend a group
        [_, {"?", x}, _] ->
          {bef, aft} = String.split_at(rec, x)
          [bef <> "." <> String.slice(aft, 1..-1)]
      end
    end)
  end

  def find_possible_solutions({rec, groups}) do
    days = String.graphemes(rec)

    freq = Enum.frequencies(days)

    existing_pounds = Map.get(freq, "#", 0)
    # |> IO.inspect

    holes = Enum.filter(Enum.with_index(days), fn {c, _} -> c == "?" end)
    # |> IO.inspect

    num_holes = Enum.count(holes)
    pot_holes =  Enum.to_list(1..num_holes)

    pounds_to_make = Enum.sum(groups) - existing_pounds
    # |> IO.inspect


    possibiliies = comb([], pot_holes, pounds_to_make)|>flatten([])
    # |> IO.inspect
    possibiliies
    |> Enum.map(fn solution ->
      Enum.reduce(days, {"", solution}, fn char, {acc, sol} ->
        # IO.inspect(char)
        if sol == [] do
          {acc <> char, sol}
        else
          [s | olution] = sol
          # IO.inspect([s | olution])
          case char do
            "?" -> {acc <> s, olution}
            _ -> {acc <> char, [s | olution]}
          end
        end
      end)
      |> elem(0)
    end)
    |> find_actual_solutions(groups)
  end

  def find_actual_solutions(solutions, key) do
    # IO.inspect(key)
    Enum.filter(solutions, fn s ->
      g = get_groupings(s)
      g == key
    end)
  end

  def get_groupings(full_day) do
    String.split(full_day, ".", trim: true)
    |> Enum.map(fn s ->
      String.length(s)
    end)
  end


  def comb(so_far, [_hole | []], 0) do
    [ "." | so_far ]
  end
  def comb(so_far, [_hole | []], _) do
    [ "#" | so_far ]
  end
  def comb(so_far, [_ | holes], 0) do
    comb(["." | so_far], holes, 0)
  end
  def comb(so_far, [_ | holes], n) do
    [comb(["." | so_far], holes, n), comb(["#" | so_far], holes, n-1)]
  end

  def flatten([], acc), do: acc
  def flatten([h|r], acc) when not is_list(h) do
    [[h|r] | acc]
  end
  def flatten([h|r], acc) when is_list(h) do
    fh = flatten(h, acc)
    fr = flatten(r, fh)
    fr
  end

  def runP1 do
    case File.read("./lib/inputs/day12.txt") do
      {:ok, input} -> parse(input)
        |> Enum.with_index()
        |> Enum.map(fn {line, idx} ->
          n = Enum.count(find_possible_solutions(line))
          IO.puts("i:#{idx + 1}-->#{n}")
          n
        end)
        |> Enum.sum()
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end


  def runP2 do
    case File.read("./lib/inputs/day12.txt") do
      {:ok, input} -> parseP2(input)
      |> Enum.with_index()
      |> Enum.map(fn {{rec, g}, idx} ->
        n = get_and_run_for_subproblems(1, rec, g)
        IO.puts("i:#{idx + 1}-->#{n}")
        n
      end)
      |> Enum.sum()
      |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end
end
