defmodule Day1Test do
  use ExUnit.Case
  doctest Day2

  test "Day 2 Given" do
    input_output = %{
      "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" => {1, true},
      "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue" => {2, true},
      "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red" => {3, false},
      "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red" => {4, false},
      "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green" => {5, true}
    }

    Enum.each(input_output, fn {input, output} ->
      assert Day2.processLine(input) == output
    end)

  end
end
