defmodule Advent7.Card do
  defstruct [:value]

  @type t() :: %Advent7.Card{}

  @spec new(char()) :: %Advent7.Card{}
  def new(?A), do: %Advent7.Card{ value: 14 }
  def new(?K), do: %Advent7.Card{ value: 13 }
  def new(?Q), do: %Advent7.Card{ value: 12 }
  def new(?J), do: %Advent7.Card{ value: 0 }
  def new(?T), do: %Advent7.Card{ value: 10 }
  def new(c),  do: %Advent7.Card{ value: c - ?0 }

  defimpl Inspect, for: Advent7.Card do
    def inspect(card, _opts) do
      case card.value do
        14 -> "A"
        13 -> "K"
        12 -> "Q"
        11 -> "J"
        10 -> "T"
        o  -> to_string(to_charlist([?0 + o]))
      end
    end
  end
end
