defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  @input  """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  test "parse" do
    Day9.parse(@input)
    |> IO.inspect
  end

  test "process" do
    Day9.process([0, 3, 6, 9, 12, 15])
    |> IO.inspect
  end

  test "process2" do
    Day9.parse(@input)
    |> Enum.map(fn x -> Day9.process(x) |> Day9.guess_next end)
    |> IO.inspect
  end

  test "process3" do
    Day9.parse(@input)
    |> Enum.map(fn x -> Day9.process(x) |> Day9.guess_prev end)
    |> IO.inspect
  end
end
