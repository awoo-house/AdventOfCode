defmodule Advent14Test do
  use ExUnit.Case
  doctest Advent14

  import Advent14
  alias Advent14.DishMap

  test "io" do
    inp = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

    IO.inspect(DishMap.new(inp))

    # I don't want to deal with \r\n vs \n right now...
    # assert inspect(DishMap.new(inp)) == inp
  end

  test "scooch" do
    inp = DishMap.new("""
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """)

    %DishMap{rocks: rocks, blocks: blocks} = inp

    assert scooch_rock_up(rocks, blocks, %{row: 0, col: 0}) == %{row: 0, col: 0}
    assert scooch_rock_up(rocks, blocks, %{row: 1, col: 0}) == %{row: 1, col: 0}
    assert scooch_rock_up(rocks, blocks, %{row: 1, col: 2}) == %{row: 0, col: 2}
  end

  test "scooch_all" do
    inp = DishMap.new("""
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """)

    expected = DishMap.new("""
    OOOO.#.O..
    OO..#....#
    OO..O##..O
    O..#.OO...
    ........#.
    ..#....#.#
    ..O..#.O.O
    ..O.......
    #....###..
    #....#....
    """)

    out = IO.inspect(scooch_rocks_up(inp))

    assert out == expected
  end

  test "calc weight" do
    inp = DishMap.new("""
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """)

    assert calc_weight(inp) == 136
  end
end
