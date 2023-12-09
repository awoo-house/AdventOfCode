# I am not finishing this on a plane lol

defmodule AmmyThree do
  # given the contents of a file, turn it into a 2d array of characters
  def convert_to_array(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def are_adjacent({x1, y1}, {x2, y2}) do
    abs(x1 - x2) <= 1 and abs(y1 - y2) <= 1
  end

  def find_relevant_numbers(symbols, numbers) do
    for c1 <- symbols, c2 <- numbers, are_adjacent(c1, c2), do: c2
  end

  def get_symbol_indices(schematic) do
    is_a_symbol = fn char ->
      is_symbol =
        case char do
          # the ASCII symbols block, minus `.`
          <<c::utf8>> when ((c >= 33 and c <= 47) or (c >= 58 and c <= 64)) and c != 46 -> true
          _ -> false
        end

      is_symbol
    end

    schematic
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {char, _col_index} -> is_a_symbol.(char) end)
      |> Enum.map(fn {_, col_index} -> {row_index, col_index} end)
    end)
  end

  def get_number_indices(schematic) do
    is_a_number = fn char ->
      is_number =
        case char do
          <<c::utf8>> when (c >= 48 and c <= 57) -> true
          _ -> false
        end

      is_number
    end

    # this double-iteration is extremely unfortunate
    # i could probably grab everything on a single pass and label it as a number or symbol?
    schematic
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {char, _col_index} -> is_a_number.(char) end)
      |> Enum.map(fn {_, col_index} -> {row_index, col_index} end)
    end)
  end

  def run do
    case File.read("input/day3.in") do
      {:ok, input} ->
        schematic = input |> convert_to_array()
        symbols = get_symbol_indices(schematic)
        numbers = get_number_indices(schematic)
        relevant_numbers = find_relevant_numbers(symbols, numbers)
        IO.inspect(relevant_numbers)


      # |> inspect_surroundings()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
