defmodule LexiDay1Test do
  use ExUnit.Case
  doctest LexiDay1

  test "Day 1 Given 1" do
    input_output = %{
      "1abc2" => 12,
      "pqr3stu8vwx" => 38,
      "a1b2c3d4e5f" => 15,
      "treb7uchet" => 77
    }

    Enum.each(input_output, fn {input, output} ->
      assert LexiDay1.processLine(input) == output
    end)

  end
end
