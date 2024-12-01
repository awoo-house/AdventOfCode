defmodule Advent15.Lens do
  defstruct [:label, :focal_length]

  @type t() :: %Advent15.Lens{ label: charlist(), focal_length: integer() }

  @spec new(charlist(), integer()) :: Advent15.Lens.t()
  def new(label, focal_length), do: %Advent15.Lens{ label: label, focal_length: focal_length }

  defimpl Inspect, for: Advent15.Lens do
    def inspect(%Advent15.Lens{ label: label, focal_length: focal_length }, _opts) do
      "[#{label} #{focal_length}]"
    end
  end
end
