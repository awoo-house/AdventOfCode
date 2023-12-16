defmodule Advent11Test do
  use ExUnit.Case
  doctest Advent11

  import Advent11.Starmap

  test "transpose" do
    inp = [[?a, ?b, ?c],
           [?1, ?2, ?3]]

    exp = [[?a, ?1],
           [?b, ?2],
           [?c, ?3]]

    assert Advent11.Starmap.transpose(inp) == exp
  end

  # test "expand_across" do
  #   IO.puts("\n=====")
  #   inp = IO.inspect(Advent11.Starmap.new("""
  #   ...#
  #   ....
  #   .#..
  #   """))
  #   IO.puts("=====")

  #   IO.inspect(Advent11.Starmap.fmap(inp,
  #     fn dat ->
  #       dat
  #       # |> Advent11.Starmap.transpose
  #       |> Advent11.Starmap.expand_across
  #       # |> Advent11.Starmap.transpose
  #     end))

  #   IO.puts("=====")
  # end

  test "expansIOn" do
    inp = Advent11.Starmap.new("""
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
    """)

    expected = Advent11.Starmap.new("""
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
    """)

    assert Advent11.Starmap.expand(inp) == expected
  end

end
