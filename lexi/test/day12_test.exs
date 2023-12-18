defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  @input  """
  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1
  """

  test "parse" do
    act = Day12.parseP2(@input)
    act |> IO.inspect()
    # assert act == Day12.parse(exp)
  end

  test "encode" do
    Day12.encode("????.######..#####.")
    |> IO.inspect
  end

  test "find solution" do
    inp = {"?###????????", [3, 2, 1]}
    act = Day12.find_possible_solutions(inp)
    # |> Day12.find_actual_solutions([3, 2, 1])
    |> IO.inspect()
    # assert act == [
    #   "#.#.###"
    # ]
  end

  test "get_all_possible_combinations_of_filled_holes" do
    res = Day12.comb([], [1, 4, 5, 8], 2)
    |> Day12.flatten([])
    |> IO.inspect

  end

  test "analyze" do
    Day12.analyze_problem("????????.???#???????", [2, 2, 2, 2], 0)
    # can create the extra groups like 3/1, 2/2, 1/3, or 0/4
    # eg...
    #
    # ##.##.##.???##??????
    # ##?##???.???##?##???
    # ?##?????.##?##?##???
    # ????????.##?##?##?##
    # And also, there are choices in each one, like in the 2/2 version, here are some others:
    #
    # ?##?##??.???##?##???
    # ??##?##?.???##?##???
    # ???##?##.???##?##???
    # ??##??##.???##?##???
    # ?##???##.???##?##???
    # ##????##.???##?##???
    #
    # That's JUST the options for the first half. Then, for each of those, where are options for the second half...
    #
    # ?##?##??.???##?##???
    # ?##?##??.??##??##???
    # ?##?##??.?##???##???
    # ?##?##??.##????##???
    # ?##?##??.???##??##??
    # ?##?##??.???##???##?
    # ?##?##??.???##????##
    # etc...
    # Let's break this down into smaller problems. So, what about for the string
    # ???.?#??
    # with the groups
    # [1, 2]
    # So, enumerating everything and putting in just #s give us...
    # #??.?##?
    # ?#?.?##?
    # ??#.?##?
    # and also...
    # #??.##??
    # ?#?.##??
    # ??#.##??
    # So, we can break this down into all of the MANDATORY group break points-- that is, the .s that are GIVEN in the input.
    # In this simple example, the given number of groups matches the necessary number of groups, so the only combinatorics problem are
    # the summation of choices of where you can place the #s in the existing groups.
    #
    # But in the more advanced problem, we are actually given one extra degree of freedom. We are only GIVEN one mandatory group break, but
    # are told that we must HAVE three group breaks. So, we can enumerate all of the possible group breaks somewhat easily
    # (and this can be defined in terms of a range of ?s between each group break)
    # And then, for each of these, we have turned the advanced problem into the simpler problem. And, again, we sum the choices.


  end

  test "get_number_of_possible_placements_in_fragment" do
    assert Day12.get_number_of_possible_placements_in_fragment("???#???", 3) == 3
    assert Day12.get_number_of_possible_placements_in_fragment("???##??", 3) == 2
    assert Day12.get_number_of_possible_placements_in_fragment("?#?#???", 3) == 1
    assert Day12.get_number_of_possible_placements_in_fragment("?#?#?#?", 6) == 2
    assert Day12.get_number_of_possible_placements_in_fragment("?#?#??#", 6) == 1
    assert Day12.get_number_of_possible_placements_in_fragment("#?#??#", 6) == 1
    assert Day12.get_number_of_possible_placements_in_fragment("#????", 1) == 1
    assert Day12.get_number_of_possible_placements_in_fragment("????", 1) == 4
    assert Day12.get_number_of_possible_placements_in_fragment("#", 1) == 1
    assert Day12.get_number_of_possible_placements_in_fragment("#?", 1) == 1
    assert Day12.get_number_of_possible_placements_in_fragment("##", 2) == 1
    assert Day12.get_number_of_possible_placements_in_fragment("??#??#", 5) == 1
    ##

    assert Day12.get_number_of_possible_placements_in_fragment("??##", 1) == 0
    assert Day12.get_number_of_possible_placements_in_fragment("????", 5) == 0
    assert Day12.get_number_of_possible_placements_in_fragment("??#??#", 3) == 0
    assert Day12.get_number_of_possible_placements_in_fragment("??#??#", 1) == 0
    ##

    assert Day12.get_number_of_possible_placements_in_fragment("?###????????", 6) == 0
  end


  @tag timeout: 300
  test "get_and_run_for_subproblems" do
    [{rec, g}] = Day12.parse("?###???????? 3,2,1")


    |> IO.inspect
    Day12.get_and_run_for_subproblems(1, rec, g) |> IO.inspect
  end

  test "all_possible_ways_to_add_one_group" do
    Day12.all_possible_ways_to_add_one_group("??##???.##??") |> IO.inspect

    # ?.##???.##??
    # ??##.??.##??
    # ??##?.?.##??
    # ??##???.##.?

  end

end
