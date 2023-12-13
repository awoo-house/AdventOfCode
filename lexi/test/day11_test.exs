defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  @input  """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  test "parse" do
    act = Day11.parse(@input) |> Day11.expand
    exp = """
    ....#........
    .........#...
    #............
    .............
    .............
    ........#....
    .#...........
    ............#
    .............
    .............
    .........#...
    #....#.......
    """
    act |> Day11.print
    assert act == Day11.parse(exp)
  end

  test "calculate_shortest_path" do
    io = [
      {{{0,0}, {5,0}},5},
      {{{0,0}, {5,1}},6},
      {{{0,0}, {5,2}},7},
      {{{0,0}, {5,3}},8},
      {{{0,0}, {5,4}},9},
      {{{6,4}, {1,10}},11}
    ]
    Enum.each(io, fn {{p1, p2}, exp} ->
      assert Day11.calculate_shortest_path(p1, p2) == exp
    end)
  end

  test "get_all_pairs_of_galaxies" do
    assert Day11.parse("""
      ...#.
      ..#..
      ....#
    """)
    |> Day11.get_all_pairs_of_galaxies == [
      [{2,1},{3, 0}],
      [{2, 1}, {4,2}],
      [{3, 0}, {4,2}]
    ]
  end

  test "given"  do
    grid = Day11.parse(@input)
    |> Day11.expand

    pairs = grid
    |> Day11.get_all_pairs_of_galaxies

    IO.puts("Num pairs: #{inspect(Enum.count(pairs))}")

    act = pairs
    |> Enum.map(fn [p1, p2] ->
      p = Day11.calculate_shortest_path(p1, p2)
      IO.puts("The shortest path between #{inspect(p1)} and #{inspect(p2)} is #{p}")
    # Day11.print(Day11.print_pairs(grid, p1, p2))
      p
    end)
    |> Enum.sum

    assert act == 374
  end

  test "given_p2"  do
    grid = Day11.parse(@input)

    {cols, rows} = Day11.get_expansion(grid)

    pairs = grid |> Day11.get_all_pairs_of_galaxies

    act = pairs
    |> Enum.map(fn [p1, p2] ->
      Day11.calculate_shortest_path_v2(p1, p2, cols, rows, 1)
    end)
    |> Enum.sum

    assert act == 374
  end

  test "given_p2_10"  do
    grid = Day11.parse(@input)

    {cols, rows} = Day11.get_expansion(grid)

    pairs = grid |> Day11.get_all_pairs_of_galaxies

    act = pairs
    |> Enum.map(fn [p1, p2] ->
      Day11.calculate_shortest_path_v2(p1, p2, cols, rows, 10)
    end)
    |> Enum.sum

    assert act == 1030
  end

  test "given_p2_100"  do
    grid = Day11.parse(@input)

    {cols, rows} = Day11.get_expansion(grid)

    pairs = grid |> Day11.get_all_pairs_of_galaxies

    act = pairs
    |> Enum.map(fn [p1, p2] ->
      Day11.calculate_shortest_path_v2(p1, p2, cols, rows, 100)
    end)
    |> Enum.sum

    assert act == 8410
  end
end
