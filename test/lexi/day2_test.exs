defmodule LexiDay1Test do
  use ExUnit.Case
  doctest LexiDay2

  test "Day 2 Given" do
    input_output = %{
      "1abc2" => 12,
      "pqr3stu8vwx" => 38,
      "a1b2c3d4e5f" => 15,
      "treb7uchet" => 77
    }

    Enum.each(input_output, fn {input, output} ->
      assert LexiDay2.processLine(input) == output
    end)

  end
end
