defmodule Advent13Test do
  use ExUnit.Case
  doctest Advent13

  import Advent13

  test "line to int" do
    assert line_to_int(to_charlist("........")) == 0
    assert line_to_int(to_charlist(".......#")) == 1
    assert line_to_int(to_charlist("......##")) == 3
    assert line_to_int(to_charlist(".....#.#")) == 5
    assert line_to_int(to_charlist("########")) == 255
  end


  test "find possible mirror lines" do
    inp = parse("""
    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """)

    maybes = find_possible_mirror_lines(inp)
    line = find_mirror_row(inp, maybes)

    assert line == 3
  end

  test "should not find mirror line when vertical" do
    inp = parse("""
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.
    """)

    maybes = find_possible_mirror_lines(inp)
    line = find_mirror_row(inp, maybes)

    assert line == nil
  end

  test "SHOULD find mirror line when vertical AND TRANSPOSED" do
    inp = parse("""
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.
    """, transpose: true)

    maybes = find_possible_mirror_lines(inp)
    line = find_mirror_row(inp, maybes)

    assert line == 4
  end

  test "API SHOULD find mirror line when horizontal" do
    inp = """
    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """

    line = find_mirror_line(inp)

    assert line == {:row, 3}
  end

  test "API SHOULD find mirror line when vertical" do
    inp = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.
    """

    line = find_mirror_line(inp)

    assert line == {:col, 4}
  end
end
