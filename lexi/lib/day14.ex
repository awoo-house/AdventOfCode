defmodule Day14 do

  def char("#"), do: :cube
  def char("."), do: :space
  def char("O"), do: :rock

  def parse(input) do
    grid = String.split(input, "\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn { line, y_index } ->
      line
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn { c, x_index } ->
        { {x_index, y_index}, char(c) }
      end)
    end)
    |> Map.new()
    {max_x, _} = Enum.max_by(Map.keys(grid), fn {x, _y} -> x end)
    {_, max_y} = Enum.max_by(Map.keys(grid), fn {_x, y} -> y end)
    %{
      :grid => grid,
      :max_x => max_x,
      :max_y => max_y
    }
  end

  def print(:space), do: "."
  def print(:cube), do: "#"
  def print(:rock), do: "O"

  def print(grid) do
    xs = Enum.map(Map.keys(grid), fn {x, _y} ->
      x
    end)
    ys = Enum.map(Map.keys(grid), fn {_x, y} ->
      y
    end)
    max_x = Enum.max(xs)
    max_y = Enum.max(ys)
    Enum.each((0..max_y), fn y ->
      line = Enum.reduce((0..max_x), "", fn x, acc ->
        c = Map.get(grid, {x, y})
        acc <> print(c)
      end)
      IO.puts(line)
    end)
  end

  def cycle_north(grid, max_x, max_y, cache) do
    if Map.has_key?(cache, {Map.values(grid), :north}) do
      {Map.get(cache, {Map.values(grid), :north}), cache}
    else
      {nm, nc} = Enum.reduce((0..max_x), {grid, cache}, fn x, {acc, ac_cache} ->
        items_to_thrash =
          Enum.map((max_y..0), fn y ->
            Map.get(grid, {x, y})
          end)
        {res, new_cache} = thrash_row(ac_cache, items_to_thrash)
        new_map =
          res
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {new_c, thrashed_idx}, ac ->
            Map.put(ac, {x, max_y - thrashed_idx}, new_c)
          end)
        {new_map, new_cache}
      end)
      {nm, Map.put(nc, {Map.values(grid), :north}, nm)}
    end
  end


  def cycle_east(grid, max_x, max_y, cache) do
    if Map.has_key?(cache, {Map.values(grid), :east}) do
      # IO.puts("memo")
      {Map.get(cache, {Map.values(grid), :east}), cache}
    else
      {nm, nc} = Enum.reduce((0..max_y), {grid, cache}, fn y, {acc, ac_cache} ->
        items_to_thrash =
          Enum.map((0..max_x), fn x ->
            Map.get(grid, {x, y})
          end)
        {res, new_cache} = thrash_row(ac_cache, items_to_thrash)
        new_map =
          res
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {new_c, thrashed_idx}, ac ->
            Map.put(ac, {thrashed_idx, y}, new_c)
          end)
        {new_map, new_cache}
      end)
      {nm, Map.put(nc, {Map.values(grid), :east}, nm)}
    end
  end

  def cycle_west(grid, max_x, max_y, cache) do

    if Map.has_key?(cache, {Map.values(grid), :west}) do
      # IO.puts("memo")
      {Map.get(cache, {Map.values(grid), :west}), cache}
    else
      {nm, nc} = Enum.reduce((0..max_y), {grid, cache}, fn y, {acc, ac_cache} ->
        items_to_thrash =
          Enum.map((max_x..0), fn x ->
            Map.get(grid, {x, y})
          end)
        {res, new_cache} = thrash_row(ac_cache, items_to_thrash)
        new_map =
          res
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {new_c, thrashed_idx}, ac ->
            Map.put(ac, {max_x - thrashed_idx, y}, new_c)
          end)
        {new_map, new_cache}
      end)
      {nm, Map.put(nc, {Map.values(grid), :west}, nm)}
    end
  end


  def cycle_south(grid, max_x, max_y, cache) do
    if Map.has_key?(cache, {Map.values(grid), :south}) do
      # IO.puts("memo")
      {Map.get(cache, {Map.values(grid), :south}), cache}
    else
      {nm, nc} = Enum.reduce((0..max_x), {grid, cache}, fn x, {acc, ac_cache} ->
        items_to_thrash =
          Enum.map((0..max_y), fn y ->
            Map.get(grid, {x, y})
          end)
        {res, new_cache} = thrash_row(ac_cache, items_to_thrash)
        new_map =
          res
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {new_c, thrashed_idx}, ac ->
            Map.put(ac, {x, thrashed_idx}, new_c)
          end)
        {new_map, new_cache}
      end)
      {nm, Map.put(nc, {Map.values(grid), :south}, nm)}
    end
  end

  def cycle(map, max_x, max_y, cache, cycle_number) do
    if Map.has_key?(cache, {Map.values(map), :cycle}) do
      {:halt, {cache, Map.get(cache, {Map.values(map), :cycle_number}), cycle_number}}
    else

      {map1, cache1} = cycle_north(map, max_x, max_y, cache)
      {map2, cache2} = cycle_west(map1, max_x, max_y, cache1)
      {map3, cache3} = cycle_south(map2, max_x, max_y, cache2)
      {map4, cache4} = cycle_east(map3, max_x, max_y, cache3)

      mc = Map.put(cache4, {Map.values(map), :cycle_number}, cycle_number)
      mc2 = Map.put(mc, cycle_number, map4)

      # IO.puts("On cycle #{cycle_number}, the weight is #{calc_force(map4, max_y)}")

      {:cont, {map4, Map.put(mc2, {Map.values(map), :cycle}, map4)}}
    end
  end

  # We can encode a row thrashing in a direction fully by its locations of cubes and rocks.
  # So, if we memoize what this hash -> resultant hash is, we have essentially done this with dynamic programming.

  def thrash_row(cache, items) do
    if Map.has_key?(cache, items) do
      # IO.puts("memoized")
      {Map.get(cache, items), cache}
    else
      new = calc_row_move(items)
      {new, Map.put(cache, items, new)}
    end
  end
  def calc_row_move(items) do
    # IO.puts("New row, calc!")
    # By convention, we always throw items in the direction from the 0th index to the last.
    max = length(items)
    wi = Enum.with_index(items)

    # So, fold from last index to first
    new_rocks = List.foldr(Enum.with_index(items), {[], max-1}, fn {this_item, this_idx}, {items_so_far, last_stop} ->
      x = case this_item do
        :cube -> {items_so_far, this_idx - 1}
        :space -> {items_so_far, last_stop}
        :rock -> {[last_stop | items_so_far], last_stop - 1}
      end
      # IO.puts("for #{inspect(this_item)}, idx=#{this_idx}: #{inspect(x, charlists: :as_lists)}")
      x
    end)
    |> elem(0)

    Enum.map(wi, fn {item, idx} ->
      case {item, Enum.member?(new_rocks, idx)} do
        {:cube, _} -> :cube
        {_, true} -> :rock
        {_, false} -> :space
      end
    end)

  end

  def calc_total_force_after_north_tilt(map) do
    max_x = map[:max_x]
    Enum.reduce((0..max_x), 0, fn x, acc -> acc + calc_force_after_north_tilt_for_column(map, x) end)
  end

  def calc_force_after_north_tilt_for_column(map, x) do
    grid = map[:grid]
    max_y = map[:max_y]

    Enum.reduce((0..max_y), {0, max_y + 1}, fn y, {cur_force, last_stopping_force} ->
      stopping_force_of_this_cell = (max_y - y) + 1
      case Map.get(grid, {x, y}) do
        :rock ->
          # IO.puts("At y = #{y}, we have a cur_force of #{cur_force} and we're about to add #{last_stopping_force}.")
          {cur_force + last_stopping_force, last_stopping_force - 1}
        :space ->

          # IO.puts("At y = #{y}, we have a cur_force of #{cur_force}, and we're ")
          {cur_force, last_stopping_force}
        :cube ->
          {cur_force, stopping_force_of_this_cell - 1}
      end
    end)
    |> elem(0)
  end

  def calc_force(grid, max_y) do
    Enum.reduce(grid, 0, fn {{_x, y}, c}, acc ->
      case c do
        :rock -> acc + (max_y + 1 - y)
        _ -> acc
      end
    end)
  end

  def run_cycles(map, num) do
    cache = Map.new()
    grid = map[:grid]
    max_y = map[:max_y]
    max_x = map[:max_x]
    {final_cache, cycle_num_start, cycle_num_end} = Enum.reduce_while((1..num), {grid, cache}, fn i, {ng, nc} ->
      cycle(ng, max_x, max_y, nc, i)
    end)
    IO.puts("We cycle from #{cycle_num_start} to #{cycle_num_end}")

    cn = cycle_num_end - cycle_num_start + 1
    re = rem((num - (cycle_num_start + cycle_num_end - 1)), cn)
    IO.puts("After going around and around, we are on cycle #{re}")
    Map.get(final_cache, cycle_num_start + re)

  end


  def run do
    case File.read("./lib/inputs/day14.txt") do
      {:ok, input} ->
        a = parse(input)
        x = run_cycles(a, 1000000000)
        print(x)
        print(calc_force(x, a[:max_y]))
      {:error, reason} -> IO.write(reason)
    end
  end
end
