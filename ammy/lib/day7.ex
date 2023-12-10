defmodule AmmySeven do
  def hand_rank(hand) when hand == [5], do: 1
  def hand_rank(hand) when hand == [4, 1], do: 2
  def hand_rank(hand) when hand == [3, 2], do: 3
  def hand_rank(hand) when hand == [3, 1, 1], do: 4
  def hand_rank(hand) when hand == [2, 2, 1], do: 5
  def hand_rank(hand) when hand == [2, 1, 1, 1], do: 6
  def hand_rank(hand) when hand == [1, 1, 1, 1, 1], do: 7

  def hand_rank(num_jokers, hand_without_jokers) do
    case hand_without_jokers do
      [] -> [num_jokers]
      [h] -> [h + num_jokers]
      [h | r] -> [h + num_jokers] ++ r
    end
    |> hand_rank
  end

  def card_value_sorter(hand) do
    hand
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {char, index}, acc ->
      acc + card_value(char) * index_mult(index)
    end)
  end

  def card_value(card) when card in ["2", "3", "4", "5", "6", "7", "8", "9"] do
    15 - String.to_integer(card)
  end

  def card_value("T"), do: 5
  def card_value("J"), do: 14
  def card_value("Q"), do: 3
  def card_value("K"), do: 2
  def card_value("A"), do: 1

  def index_mult(idx) when idx == 0, do: 41371
  def index_mult(idx) when idx == 1, do: 2955
  def index_mult(idx) when idx == 2, do: 211
  def index_mult(idx) when idx == 3, do: 15
  def index_mult(idx) when idx == 4, do: 1

  def sort_hands(hands) do
    hands |> Enum.sort(&compare_hands/2)
  end

  defp compare_hands(hand1, hand2) do
    h1 = Enum.at(hand1, 0)
    h2 = Enum.at(hand2, 0)
    num_jokers_h1 = h1 |> String.codepoints() |> Enum.count(&(&1 == "J"))
    num_jokers_h2 = h2 |> String.codepoints() |> Enum.count(&(&1 == "J"))

    non_jokers_h1 =
      h1 |> String.codepoints() |> Enum.filter(fn char -> char != "J" end) |> Enum.join()

    non_jokers_h2 =
      h2 |> String.codepoints() |> Enum.filter(fn char -> char != "J" end) |> Enum.join()

    hand_rank_1 = hand_rank(num_jokers_h1, card_frequencies(non_jokers_h1))
    hand_rank_2 = hand_rank(num_jokers_h2, card_frequencies(non_jokers_h2))

    if hand_rank_1 != hand_rank_2 do
      hand_rank_1 < hand_rank_2
    else
      card_value_sorter(Enum.at(hand1, 0)) < card_value_sorter(Enum.at(hand2, 0))
    end
  end

  def card_frequencies(hand) do
    hand
    |> String.graphemes()
    |> Enum.frequencies()
    |> Enum.sort(fn {_, count}, {_, count2} -> count >= count2 end)
    |> Enum.map(fn {_, count} -> count end)
  end

  def run do
    case File.read("input/day7.in") do
      {:ok, input} ->
        String.split(input)
        |> Enum.chunk_every(2)
        |> sort_hands()
        |> Enum.reverse()
        |> Enum.with_index()
        |> Enum.reduce(0, fn {[_, bid], index}, acc ->
          {bid_i, _} = Integer.parse(bid)
          acc + bid_i * (index + 1)
        end)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
