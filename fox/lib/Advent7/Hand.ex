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


  @spec what_kind(list(%Card{})) :: kind()
  defp what_kind(cards) do
    numbers = Enum.group_by(cards, fn c -> c.value end )
      |> Map.values
      |> Enum.map(&length/1)
      |> Enum.sort(:desc)

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
