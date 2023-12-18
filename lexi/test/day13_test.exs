defmodule Day13Test do
  use ExUnit.Case
  doctest Day13
  use Bitwise, only_operators: true

  # def sigil_v(inp, _) do
  #   Day13.parse(inp)
  # end

  test "parse" do
    ml_in = """
      ##.#..#
      ###....
      #..####
      .######
      ##.....

      ...###.##..
      ###.#...#..
      ..##.#...#.
      ..#.#.#..##
      ..##......#
      ##..####...
    """
    Day13.parse(ml_in)
    |> IO.inspect
  end

  test "determine_vertical_mirror" do
    inn = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.
    """
    Day13.parse_run(inn)
    |> Day13.find_mirror(:vert)
    |> IO.inspect
  end

  test "horz" do
    inn = """
    #...##..#
    #...##..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #...##..#
    """
    Day13.parse_run(inn)
    |> Day13.find_mirrors(:horz)
    |> IO.inspect

  end

  test "calc" do
    Day13.parse("""
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """)
    |> Day13.calc
    |> IO.inspect
  end

  test "smudges" do
    l1 = [true, false, false]
    l2 = [true, true, false]
    Enum.zip(l1, l2)
    |> Enum.count(fn {x, y} -> (x and not y) or (not x and y) end)
    |> IO.inspect()
  end

end
