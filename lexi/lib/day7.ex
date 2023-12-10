defmodule Day7 do

  def hand_value(jokers, counts) do
    case counts do
      [] -> [jokers]
      [h] -> [h + jokers]
      [h | r] -> [h + jokers] ++ r
    end
    |> hand_value
  end

  def hand_value(counts) when counts == [5],         do: 7000000
  def hand_value(counts) when counts == [4,1],       do: 6000000
  def hand_value(counts) when counts == [3,2],       do: 5000000
  def hand_value(counts) when counts == [3,1,1],     do: 4000000
  def hand_value(counts) when counts == [2,2,1],     do: 3000000
  def hand_value(counts) when counts == [2,1,1,1],   do: 2000000
  def hand_value(counts) when counts == [1,1,1,1,1], do: 1000000

  def card_value(card) when card == "2",  do: 2
  def card_value(card) when card == "3",  do: 3
  def card_value(card) when card == "4",  do: 4
  def card_value(card) when card == "5",  do: 5
  def card_value(card) when card == "6",  do: 6
  def card_value(card) when card == "7",  do: 7
  def card_value(card) when card == "8",  do: 8
  def card_value(card) when card == "9",  do: 9
  def card_value(card) when card == "T",  do: 10
  def card_value(card) when card == "J",  do: 1
  def card_value(card) when card == "Q",  do: 11
  def card_value(card) when card == "K",  do: 12
  def card_value(card) when card == "A",  do: 13

  def index_mult(idx) when idx == 0, do: 50000
  def index_mult(idx) when idx == 1, do: 3300
  def index_mult(idx) when idx == 2, do: 220
  def index_mult(idx) when idx == 3, do: 15
  def index_mult(idx) when idx == 4, do: 1

  def get_sorting_value(hand) do
    # IO.inspect(hand)
    cards = String.graphemes(hand)
    no_jokers = Enum.filter(cards, fn char -> char != "J" end)
    jokers = Enum.count(cards, fn char -> char == "J" end)
    card_copies = Enum.reduce(no_jokers, %{}, fn char, acc ->
      Map.update(acc, char, 1,  &(&1 + 1))
    end)
    |> Map.values
    |> Enum.sort(:desc)
    hv = hand_value(jokers, card_copies)
    # IO.inspect(hv)

    card_vals = Enum.with_index(cards, fn card, idx ->
      v = card_value(card) * index_mult(idx)
      # IO.puts("The card #{card} at index #{idx} has value #{v}")
      v
    end)
    |> Enum.reduce(0, &(&1 + &2))

    # IO.inspect(card_vals)
    card_vals + hv
  end

  def sort_hands(hands) do
    Enum.map(hands, fn {hand, bid} ->
      { get_sorting_value(hand), {hand, bid} }
    end)
    |> Enum.sort_by(fn {s, _h} -> s end, :asc)
  end

  def parse(input) do
    String.split(input)
    |> Enum.chunk_every(2, 2)
    |> Enum.map(fn [hand, bid] ->
      {n, _} = Integer.parse(bid)
      {hand, n}
    end)
  end

  def run do
    case File.read("./lib/inputs/day7.txt") do
      {:ok, input} -> parse(input)
        |> sort_hands
        |> Enum.with_index(1)
        |> Enum.reduce(0, fn x, acc ->
          {{_, {_h, bid}}, idx} = x
          acc + (bid * idx)
        end)
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
