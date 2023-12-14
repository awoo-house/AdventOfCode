defmodule Advent9Test do
  use ExUnit.Case
  doctest Advent9

  def sigil_l(inp, _) do
    Advent9.process_line(inp)
  end

  @tag timeout: 1000
  test "calculate diffs" do
    assert Advent9.calculate_diff(~l/1   3   6  10  15  21/) == 28
  end

  test "process line" do
    assert ~l/1   3   6  10  15  21/ == [1, 3, 6, 10, 15, 21]
  end

  test "process lines" do
    inp = Advent9.process_line("-10  13  16  -21  30  45")
    IO.inspect(inp)
  end

  test "reverse guess" do
    inp = ~l/10  13  16  21  30  45/
    IO.inspect(Advent9.linear_guess_b(Enum.reverse(Advent9.diff_pyr(inp))))
  end

  test "input example" do
    inp = """
    0   3   6   9  12  15
    1   3   6  10  15  21
    10  13  16  21  30  45
    """

    ans = Advent9.process_input(inp)
      |> Enum.map(&Advent9.calculate_diff/1)
      |> Enum.sum

    assert ans == 114
  end

  test "input example part 2" do
    inp = """
    0   3   6   9  12  15
    1   3   6  10  15  21
    10  13  16  21  30  45
    """

    ans = Advent9.process_input(inp)
      |> Enum.map(fn l -> Advent9.calculate_diff(l, &Advent9.linear_guess_b/1) end)
      |> Enum.sum

    assert ans == 2
  end

end
