defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  @input  """
  ..F7.
  -FJ|.
  SJ.L7
  |F--J
  LJ...
  """

  test "parse" do
    Day10.parse(@input)
    |> IO.inspect
  end
  test "build_graph" do
    Day10.parse(@input)
    |> Day10.build_graph
    |> IO.inspect
  end
  test "get_max_distance" do
    Day10.parse(@input)
    |> Day10.build_graph
    |> Day10.get_max_distance
    |> IO.inspect
  end
  test "print" do
    input = """
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
    """

    Day10.parse(input)
    |> Day10.build_graph
    |> Day10.label_ground
    |> Day10.print
  end

  # test "process" do
  #   Day10.process([0, 3, 6, 9, 12, 15])
  #   |> IO.inspect
  # end

  # test "process2" do
  #   Day10.parse(@input)
  #   |> Enum.map(fn x -> Day10.process(x) |> Day10.guess_next end)
  #   |> IO.inspect
  # end

  # test "process3" do
  #   Day10.parse(@input)
  #   |> Enum.map(fn x -> Day10.process(x) |> Day10.guess_prev end)
  #   |> IO.inspect
  # end
end
