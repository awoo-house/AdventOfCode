defmodule AmmyEleven do
  defp empty_section?(section) do
    Enum.all?(section, &(&1 == "."))
  end

  defp galaxy_indices(universe) do
    universe
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} -> char == "#" end)
      |> Enum.map(fn {_, col_index} -> {row_index, col_index} end)
    end)
  end

  def run do
    case File.read("input/day11.in") do
      {:ok, input} ->
        universe =
          String.split(input, "\n")
          |> Enum.map(&String.graphemes/1)

        empty_rows =
          universe
          |> Enum.with_index()
          |> Enum.filter(fn {row, _} -> empty_section?(row) end)
          |> Enum.map(fn {_, index} -> index end)

        empty_columns =
          universe
          |> Enum.zip()
          |> Enum.map(&Tuple.to_list(&1))
          |> Enum.with_index()
          |> Enum.filter(fn {column, _} -> empty_section?(column) end)
          |> Enum.map(fn {_, index} -> index end)

        galaxies = universe |> galaxy_indices()

        galaxies
        |> Enum.with_index()
        |> Enum.reduce(0, fn {{row, col}, index}, acc ->
          # the other galaxies before this one
          Enum.take(galaxies, index)
          |> Enum.reduce(acc, fn {other_row, other_col}, acc ->
            min_row = min(row, other_row)
            min_col = min(col, other_col)
            max_row = max(row, other_row)
            max_col = max(col, other_col)

            acc =
              if min_row < max_row do
                Enum.reduce(min_row..(max_row - 1), acc, fn r, acc ->
                  # part one
                  # acc + if r in empty_rows, do: 2, else: 1
                  acc + if r in empty_rows, do: 1000000, else: 1
                end)
              else
                acc
              end

            acc =
              if min_col < max_col do
                Enum.reduce(min_col..(max_col - 1), acc, fn c, acc ->
                  # acc + if c in empty_columns, do: 2, else: 1
                  acc + if c in empty_columns, do: 1000000, else: 1
                end)
              else
                acc
              end

            acc
          end)
        end)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
