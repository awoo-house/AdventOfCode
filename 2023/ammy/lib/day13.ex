defmodule AmmyThirteen do
  def transpose(arr) do
    arr |> List.zip |> Enum.map(&Tuple.to_list/1)
  end

  def find_mirror_index(matrix) do
    Enum.reduce_while(1..(length(matrix)), 0, fn i, _ ->
      top_half = Enum.reverse(Enum.take(matrix, i))
      bottom_half = Enum.drop(matrix, i)

      top_half = Enum.take(top_half, length(bottom_half))
      bottom_half = Enum.take(bottom_half, length(top_half))

      if top_half == bottom_half and top_half != [] do
        {:halt, i}
      else
        {:cont, 0}
      end
    end)
  end

  def find_smudged_mirror_index(matrix) do
    Enum.reduce_while(1..(length(matrix)), 0, fn i, _ ->
      top_half = Enum.reverse(Enum.take(matrix, i))
      bottom_half = Enum.drop(matrix, i)

      mismatches = Enum.reduce(Enum.zip(top_half, bottom_half), 0, fn {top_row, bottom_row}, acc ->
        Enum.reduce(Enum.zip(top_row, bottom_row), acc, fn {top_char, bottom_char}, inner_acc ->
          if top_char != bottom_char do
            inner_acc + 1
          else
            inner_acc
          end
        end)
      end)

      if mismatches == 1 do
        {:halt, i}
      else
        {:cont, 0}
      end
    end)
  end

  def run do
    case File.read("input/day13.in") do
      {:ok, input} ->
        blocks =
          String.split(input, "\n\n")
          |> Enum.map(fn s -> String.split(s, "\n") end)

        # part one
        blocks
        |> Enum.reduce(0, fn block, acc ->
          parsed = block |> Enum.map(&String.graphemes/1)
          r = find_mirror_index(parsed)
          c = find_mirror_index(transpose((parsed)))

          acc = acc + (r*100) + c
          acc
        end)
        |> IO.inspect()

        # part two
        blocks
        |> Enum.reduce(0, fn block, acc ->
          parsed = block |> Enum.map(&String.graphemes/1)
          r = find_smudged_mirror_index(parsed)
          c = find_smudged_mirror_index(transpose((parsed)))

          acc = acc + (r*100) + c
          acc
        end)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
