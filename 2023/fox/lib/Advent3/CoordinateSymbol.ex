defmodule Advent3.CoordinateSymbol do
  @enforce_keys [:row, :column]
  defstruct [:row, :column, :sym, :num]
end
