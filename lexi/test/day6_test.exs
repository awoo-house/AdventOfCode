defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "Day 6 Given 1" do
    input_output = %{
      7 => [0, 6, 10, 12, 12, 10, 6, 0],
      10 => []
    }

    Enum.each(input_output, fn {input, output} ->
      assert Day6.get_race_possibilities(input) == output
    end)

  end

  test "parse" do
    input = """
        Time:        54     70     82     75\n
        Distance:   239   1142   1295   1253\n
    """

    assert Day6.parse(input) == [
      {54, 239},{70, 1142},{82, 1295},{75, 1253}
    ]
  end

  test "ways_to_win" do
    assert Day6.ways_to_win({30, 200}) == 9
  end

  test "get_index_of_ways_to_win_that_first_wins" do
    input_output = %{
      {7, 4} => 1,
      {10, 13} => 2,
      {10, 24} => 4,
    }

    Enum.each(input_output, fn {input, output} ->
      assert Day6.get_index_of_ways_to_win_that_first_wins(input) == output
    end)
  end
end
