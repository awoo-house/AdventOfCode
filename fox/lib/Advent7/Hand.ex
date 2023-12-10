defmodule Advent7.Hand do
  alias Advent7.Card

  @type t() :: %Advent7.Hand{}
  @type kind() :: :five_of_a_kind
                | :four_of_a_kind
                | :full_house
                | :three_of_a_kind
                | :two_pair
                | :one_pair
                | :high_card

  defstruct [:cards, :kind]

  @spec new(String.t()) :: t()
  def new(inp) do
    cards = String.to_charlist(inp)
      |> Enum.map(fn c -> Card.new(c) end)

    %Advent7.Hand{ cards: cards, kind: what_kind(cards) }
  end

  def sigil_h(string, []), do: new(string)

  @spec compare(t(), t()) :: :lt | :eq | :gt
  def compare(a, b) do
    case comp_hand_kinds(a.kind, b.kind) do
      :eq -> compare_card_values(a.cards, b.cards)
      r -> r
    end
  end

  @spec compare_card_values(list(%Card{}), list(%Card{})) :: :lt | :eq | :gt
  def compare_card_values([], []), do: :eq
  def compare_card_values([a | as], [b | bs]) when a.value == b.value, do: compare_card_values(as, bs)
  def compare_card_values([a | _], [b | _]) when a.value > b.value, do: :gt
  def compare_card_values(_, _), do: :lt


  @spec comp_hand_kinds(kind(), kind()) :: :lt | :eq | :gt
  defp comp_hand_kinds(a, b) do
    lookup = %{
      :five_of_a_kind  => 6,
      :four_of_a_kind  => 5,
      :full_house      => 4,
      :three_of_a_kind => 3,
      :two_pair        => 2,
      :one_pair        => 1,
      :high_card       => 0
    }

    comp_nums(lookup[a], lookup[b])
  end

  @spec comp_nums(integer(), integer()) :: :lt | :eq | :gt
  defp comp_nums(a, b) do
    case {a, b} do
      {a, b} when a > b -> :gt
      {a, b} when a < b -> :lt
      _                 -> :eq
    end
  end

  @spec what_kind(list(%Card{})) :: kind()
  defp what_kind(cards) do
    card_groups = Enum.group_by(cards, fn c -> c.value end )
    jokers = length(Map.get(card_groups, 0, []))

    numbers = Map.delete(card_groups, 0)
      |> Map.values
      |> Enum.map(&length/1)
      |> Enum.sort(:desc)

    case numbers do
      [] -> :five_of_a_kind # Oops, all Jokers...
      [highest | rest] ->
        numbers = [ highest + jokers | rest ]

        # IO.puts("Considering (#{inspect(cards)}): #{inspect(numbers)}")

        case numbers do
          [5       ] -> :five_of_a_kind
          [4 | _   ] -> :four_of_a_kind
          [3, 2    ] -> :full_house
          [3 | _   ] -> :three_of_a_kind
          [2, 2 | _] -> :two_pair
          [2 | _   ] -> :one_pair
          _          -> :high_card
        end
    end
  end


  defimpl Inspect, for: Advent7.Hand do
    def inspect(%Advent7.Hand{ cards: cards, kind: kind }, _opts) do
      card_str = to_string(Enum.map(cards, fn c -> inspect(c) end))
      "#{card_str} (#{kind})"
    end
  end


end
