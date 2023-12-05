defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "Day 1 Given 1" do
    input = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

    res = Day3.parse_map(input)

    assert Map.get(res, {0, 0}) == "4"
    assert Map.get(res, {5, 0}) == "."
    assert Map.get(res, {6, 3}) == "#"
    assert Map.get(res, {3, 8}) == "$"


  end
end
