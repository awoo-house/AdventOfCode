defmodule AmmyThree do
  # uuuuuuugh I hate this one

  # def build_symbol_map(schematic) do
  #   is_a_symbol = fn c ->
  #     is_symbol =
  #       case c do
  #         # the ASCII symbols block, minus `.`
  #         <<c::utf8>> when ((c >= 33 and c <= 47) or (c >= 58 and c <= 64)) and c != 46 -> true
  #         _ -> false
  #       end

  #     is_symbol
  #   end

  #   schematic
  #   |> Enum.map(&String.graphemes/1)
  #   |> Enum.with_index()
  #   |> Enum.flat_map(fn {row, row_index} ->
  #     row
  #     |> Enum.with_index()
  #     |> Enum.filter(fn {char, _col_index} -> is_a_symbol.(char) end)
  #     |> Enum.map(fn {_, col_index} -> {row_index, col_index} end)
  #   end)
  #   |> Enum.into(%{}, fn pair -> {pair, []} end)
  # end

  def run do
    case File.read("input/day3.in") do
      {:ok, input} ->
        _ = String.split(input, "\n")

        # symbol_map = schematic |> build_symbol_map()
        # numbers = process(schematic)

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
