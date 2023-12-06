defmodule AmmyFour do
  def calculate_score(card) do
    winning = String.split(List.first(card), " ", trim: true) |> Enum.into(MapSet.new())
    actual = String.split(List.last(card), " ", trim: true) |> Enum.into(MapSet.new())
    intersection = MapSet.intersection(winning, actual)
    sz = MapSet.size(intersection)
    if sz > 0, do: 2 ** (sz - 1), else: 0
  end

  def process_one(card) do
    c = String.replace(card, ~r/.*\: /, "")

    results =
      String.split(c, "|", trim: true)
      |> calculate_score()
  end

  def process_all(cards) do
    cards
    |> Enum.map(&process_one/1)
  end

  def run do
    case File.read("input/day4.in") do
      {:ok, input} ->
        input
        |> String.split("\n")
        |> process_all()
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
