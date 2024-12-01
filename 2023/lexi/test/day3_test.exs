defmodule Day3Test do

  use ExUnit.Case
  doctest Day3

  @input """
    .467..114..
    ....*......
    ...35..633.
    .......#...
    .617*......
    ......+.58.
    ...592.....
    .......755.
    ....$.*....
    ..664.598..
  """

  test "parse_map" do
    res = Day3.parse_map(@input)

    assert Map.get(res, {0, 0}) == "4"
    assert Map.get(res, {5, 0}) == "1"
    assert Map.get(res, {6, 3}) == "#"
    assert Map.get(res, {3, 8}) == "$"

  end

  test "symbol_indices_in_map" do
    ti = """
      ...12.
      ...&.3
      ..*...
    """
    map = Day3.parse_map(ti)
    res = Day3.symbol_indices_in_map(map)
    IO.inspect(res)
    assert length(res) == 2
    assert Enum.find(res, fn {{x, y},c} -> x == 3 && y == 1 end) != nil
    assert Enum.find(res, fn {{x, y},c} -> x == 2 && y == 2 end) != nil
  end



  test "gear_indices_in_map" do
    map = Day3.parse_map(@input)
    proc = Day3.process(map)
    res = Day3.get_gear_ratios(proc)

    IO.inspect(res)
  end


  test "get_numbers_surrounded_by_symbol" do
    map = Day3.parse_map(@input)
    res = Day3.process(map)

    # IO.inspect(res)

    Enum.sort_by(res[:map], fn {{x, y}, { _char, _id }} -> {y, x} end)
    |> Enum.each(fn x -> IO.inspect(x) end)
  end

  test "get_perimeter_indices" do
    map = Day3.parse_map(@input)
    res = Day3.get_perimeter_indices(map, "592", {4, 6})
    IO.inspect(res)
    assert Enum.find(res, fn {{x, y}, { char, _id }} -> char == "+" end) != nil

    res2 = Day3.get_perimeter_indices(map, "58", {8, 5})

    assert Enum.all?(res2, fn {{x, y}, { char, _id }} ->
      char == "." or
      (x == 7 and y == 5 and char == "5") or
      (x == 8 and y == 5 and char == "8")
    end)
  end
end
