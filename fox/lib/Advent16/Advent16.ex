defmodule Advent16 do

  @spec parse(String.t()) :: %{ {integer(), integer()} => char() }
  def parse(inp) do
    inp
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&to_charlist/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn
      ({line, y}, line_acc) ->
        line_map = Enum.reduce(%{}, line, fn ({c,x}, chr_acc) -> Map.put(chr_acc, {x, y}, c) end)
        line_map ++ line_acc
    end)
  end


end
