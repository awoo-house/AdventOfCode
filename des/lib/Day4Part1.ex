defmodule Day4Part1 do
  def run do
    parse("input/day-4.txt")
  end

  def parse(path) do
    ret = IO.stream(File.open!(path), :line)
    |> Stream.map(&parse_card/1)
    |> Stream.map(&calc_points/1)
    |> Enum.reduce(0, fn n, sum -> n + sum end)

    IO.puts(ret)
  end

  def parse_card(line) do
    [_, id, winning, has] = Regex.run(~r/Card\s+(\d+):\s+([\d\s]+\d)\s+\|\s+([\d\s]+\d)/, line)

    winning = String.split(winning, ~r/\s+/)
    |> Enum.map(fn n -> elem(Integer.parse(n), 0) end)

    has = String.split(has, ~r/\s+/)
    |> Enum.map(fn n -> elem(Integer.parse(n), 0) end)

    %{id: id, winning: winning, has: has}
  end

  def calc_points(%{winning: winning, has: has}) do
    match_count = has
    |> Enum.filter(fn n -> Enum.find(winning, fn e -> e == n end) != nil end)
    |> length

    if match_count > 0, do: 2 ** (match_count - 1), else: 0
  end
end
