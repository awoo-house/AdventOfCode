# I am not finishing this on a plane lol

defmodule AmmyThree do
  def is_a_number(nil), do: false
  def is_a_number(char), do: String.match?(char, ~r/\d/)
  def is_a_symbol(char), do: !is_a_number(char) and char != "."

  def get_neighbors(schematic, indices) do
    Enum.map(indices, fn {row_index, col_index} ->
      left_numbers =
        Enum.take_while(Enum.reverse(Enum.at(Enum.at(schematic, row_index), 0..col_index)), &is_a_number/1)
        |> Enum.reverse()

      right_numbers =
        Enum.take_while(Enum.at(Enum.at(schematic, row_index), col_index + 1..length(schematic) - 1), &is_a_number/1)

      {left_numbers, right_numbers}
    end)
  end


  def inspect_surroundings(schematic) do
    schematic
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {char, col_index} ->
        if is_a_symbol(char) do
          indices = [
            {row_index - 1, col_index - 1}, {row_index - 1, col_index}, {row_index - 1, col_index + 1},
            {row_index, col_index - 1},                                 {row_index, col_index + 1},
            {row_index + 1, col_index - 1}, {row_index + 1, col_index}, {row_index + 1, col_index + 1}
          ]

          number_indices =
            Enum.filter(indices, fn {r, c} ->
              row_exists = r >= 0 and r < length(schematic)
              col_exists = c >= 0 and c < length(Enum.at(schematic, 0))

              row_exists and col_exists and is_a_number(Enum.at(Enum.at(schematic, r), c))
            end)

            neighbors = get_neighbors(schematic, number_indices)

            %{char: char, indices: number_indices, neighbors: neighbors}
        else
          nil
        end
      end)
    end)
    |> Enum.reject(&is_nil/1)
  end
  def run do
    case File.read("input/day3.in") do
      {:ok, input} ->
        input
        |> String.split("\n")
        |> Enum.map(&String.graphemes/1)
        |> inspect_surroundings()
        |> IO.inspect

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
