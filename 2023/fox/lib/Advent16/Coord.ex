defmodule Advent16.Coord do
  defstruct [:x, :y]

  @type t() :: %Advent16.Coord{ x: integer(), y: integer() }

  @spec new(integer(), integer()) :: t()
  def new(x, y), do: %Advent16.Coord{ x: x, y: y }


  @spec t() +++ t() :: t()
  def a +++ b do
    new(a.x + b.x, a.y + b.y)
  end

  @spec mult(t(), list(list(integer()))) :: t()
  def mult(coord, [[a, b], [c, d]]) do
    new(coord.x * a + coord.y * b, coord.x * c + coord.y * d)
  end


  defimpl Inspect, for: Advent16.Coord do
    def inspect(%Advent16.Coord{ x: x, y: y }, _opts) do
      "⟨#{x}, #{y}⟩"
    end
  end
end
