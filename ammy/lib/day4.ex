defmodule AmmyFour do
  def p2_parse(card, id) do
    parts = String.split(card, ":") |> List.last() |> String.split("|")
    winning = parts |> List.first()
    actual = parts |> List.last()

    winning_set = winning |> String.split(" ", trim: true) |> Enum.into(MapSet.new())
    actual_set = actual |> String.split(" ", trim: true) |> Enum.into(MapSet.new())
    intersection = MapSet.intersection(winning_set, actual_set)
    sz = MapSet.size(intersection)
    {id, sz}
  end

  def calculate_score(card) do
    winning = String.split(List.first(card), " ", trim: true) |> Enum.into(MapSet.new())
    actual = String.split(List.last(card), " ", trim: true) |> Enum.into(MapSet.new())
    intersection = MapSet.intersection(winning, actual)
    sz = MapSet.size(intersection)
    if sz > 0, do: 2 ** (sz - 1), else: 0
  end

  def process_one(card) do
    c = String.replace(card, ~r/.*\: /, "")

    String.split(c, "|", trim: true)
    |> calculate_score()
  end

  def process_all(cards) do
    cards
    |> Enum.map(&process_one/1)
  end

  def process_all_p2(cards) do
    init =
      cards
      |> Enum.map(fn {id, _} -> {id, 1} end)
      |> Map.new()

    Enum.reduce(cards, init, fn {id, ln}, acc ->
      case ln do
        0 ->
          acc

        n ->
          Enum.reduce(1..n, acc, fn x, acc2 ->
            Map.update(acc2, id + x, 1, fn cur -> cur + Map.get(acc2, id, 1) end)
          end)
      end
    end)
    |> Enum.reduce(0, fn {_, n}, acc -> acc + n end)
  end

  def run do
    case File.read("input/day4.in") do
      {:ok, input} ->
        input
        |> String.split("\n")
        |> process_all()
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.inspect()

        input
        |> String.split("\n", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {card, idx} -> p2_parse(card, idx+1) end)
        |> process_all_p2()
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
