defmodule Advent13Test do
  use ExUnit.Case
  doctest Advent13

  import Advent13

  def sigil_b(inp, _) do
    line_to_int(to_charlist(inp))
  end

  test "line to int" do
    assert ~b<........> == 0
    assert ~b<.......#> == 1
    assert ~b<......##> == 3
    assert ~b<.....#.#> == 5
    assert ~b<########> == 255
  end

  test "hamming_dist" do
    assert hamming_dist(~b<#...##..#>, ~b<#....#..#>) == 1
  end

  test "find possible mirror lines" do
    [inp] = parse_maps("""
    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """)

    inp = to_mirrormap(inp)

    maybes = find_possible_mirror_lines(inp)
    line = find_mirror_row(inp, maybes)

    assert line == 3
  end

  test "Should find smudged answer A (Part II)" do
    [inp] = parse_maps("""
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.
    """)

    inp = to_mirrormap(inp)

    maybes = find_possible_mirror_lines(inp)
    line = find_mirror_row(inp, maybes)

    assert line == 2
  end

  test "Should find smudged answer B (Part II)" do
    [inp] = parse_maps("""
    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """)

    inp = to_mirrormap(inp)

    maybes = find_possible_mirror_lines(inp)
    line = find_mirror_row(inp, maybes)

    assert line == 0
  end

  test "API SHOULD find mirror line when horizontal" do
    [inp] = parse_maps("""
    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """)

    line = find_mirror_line(inp)

    assert line == {:row, 3}
  end

  test "API SHOULD find mirror line when vertical" do
    [inp] = parse_maps("""
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.
    """)

    line = find_mirror_line(inp)

    assert line == {:col, 4}
  end

  test "Chunking" do
    inp = """
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
    """

    maps = IO.inspect(parse_maps(inp))

    assert length(maps) == 2
  end

  test "Scoring" do
    inp = """
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
    """

    assert get_score(inp) == 400
  end
end
