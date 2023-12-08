defmodule Day7 do

  defp hand_value(counts) when counts == [5],         do: 70000
  defp hand_value(counts) when counts == [4,1],       do: 60000
  defp hand_value(counts) when counts == [3,2],       do: 50000
  defp hand_value(counts) when counts == [3,1,1],     do: 40000
  defp hand_value(counts) when counts == [2,2,1],     do: 30000
  defp hand_value(counts) when counts == [2,1,1,1],   do: 20000
  defp hand_value(counts) when counts == [1,1,1,1,1], do: 10000

  def card_value(card) when card == "1",  do: 1
  def card_value(card) when card == "2",  do: 2
  def card_value(card) when card == "3",  do: 3
  def card_value(card) when card == "4",  do: 4
  def card_value(card) when card == "5",  do: 5
  def card_value(card) when card == "6",  do: 6
  def card_value(card) when card == "7",  do: 7
  def card_value(card) when card == "8",  do: 8
  def card_value(card) when card == "9",  do: 9
  def card_value(card) when card == "T",  do: 10
  def card_value(card) when card == "J",  do: 11
  def card_value(card) when card == "Q",  do: 12
  def card_value(card) when card == "K",  do: 13
  def card_value(card) when card == "A",  do: 14

  def index_mult(idx) when idx == 0, do: 40
  def index_mult(idx) when idx == 1, do: 30
  def index_mult(idx) when idx == 2, do: 20
  def index_mult(idx) when idx == 3, do: 10
  def index_mult(idx) when idx == 4, do: 1

  def get_sorting_value(hand) do
    IO.inspect(hand)
    cards = String.graphemes(hand)
    card_copies = Enum.reduce(cards, %{}, fn char, acc ->
      Map.update(acc, char, 1,  &(&1 + 1))
    end)
    |> Map.values
    |> Enum.sort(:desc)
    hv = hand_value(card_copies)
    IO.inspect(hv)

    card_vals = Enum.with_index(cards, fn card, idx ->
      v = card_value(card) * index_mult(idx)
      IO.puts("The card #{card} at index #{idx} has value #{v}")
      v
    end)
    |> Enum.reduce(0, &(&1 + &2))

    IO.inspect(card_vals)
    card_vals + hv
  end

  def sort_hands(hands) do
    Enum.map(hands, fn {hand, bid} ->
      { get_sorting_value(hand), {hand, bid} }
    end)
    |> Enum.sort_by(fn {s, h} -> s end, :desc)
  end

  def parse(input) do
    String.split(input)
    |> Enum.chunk_every(2, 2)
    |> Enum.map(fn [hand, bid] ->
      {n, _} = Integer.parse(bid)
      {hand, n}
    end)
  end

  def runP1 do
    case File.read("./lib/inputs/day7.txt") do
      {:ok, input} -> parse(input)
        # |> Enum.reduce(1, fn {t, r}, acc -> acc * get_index_of_ways_to_win_that_first_wins({t, r}) end)
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end

  def runP2 do
    case File.read("./lib/inputs/day7.txt") do
      {:ok, input} ->
        IO.inspect(input)
        # inp = parse_part2(input)
        # IO.inspect(get_index_of_ways_to_win_that_first_wins(List.first(inp)))
      {:error, reason} -> IO.write(reason)
    end
  end
end
