defmodule AmmyTwelve do
  defp lstrip_holes(["." | rest]) do
    lstrip_holes(rest)
  end

  defp lstrip_holes(list) do
    list
  end

  def dfs(seq, grouping) do
    IO.inspect("s: #{seq}")
    IO.inspect("g: #{grouping}")
    if grouping != [] do
      seq_len = length(seq)
      group_len = grouping |> List.first()

      if (seq_len - Enum.sum(grouping) - length(grouping) + 1) < 0 do
        IO.puts("bye")
        0
      else
        front = seq |> Enum.take(group_len)
        IO.inspect("f: #{front}")
        has_holes = Enum.any?(front, fn c -> c == "." end)

        if seq_len == group_len do
          if has_holes, do: 0, else: 1
        else
          is_available = (not has_holes) and (Enum.at(seq, group_len) != "#")

          if Enum.at(seq, 0) == "#" do
            if is_available do
              end_of_seq = Enum.slice(seq, group_len, seq_len - group_len)
              {_, remaining_groups} = List.pop_at(grouping, 0)
              dfs(lstrip_holes(end_of_seq), remaining_groups)
            else
              0
            end
          else
            {_, rem_seq} = List.pop_at(seq, 0)
            IO.inspect("rem: #{rem_seq}")
            skip = dfs(lstrip_holes(rem_seq), grouping)

            if not is_available do
              skip
            else
              end_of_seq = Enum.slice(seq, group_len+1, seq_len - group_len+1)
              IO.inspect("end: #{end_of_seq}")
              {_, remaining_groups} = List.pop_at(grouping, 0)
              skip + dfs(lstrip_holes(end_of_seq), remaining_groups)
            end
          end
        end
      end
    else
      IO.puts("no group")
      if Enum.any?(seq, fn c -> c == "#" end), do: 0, else: 1
    end
  end

  def run do
    case File.read("input/day12.in") do
      {:ok, input} ->
        lines = String.split(input, "\n")

        Enum.map(lines, fn l ->
          preprocessed = String.split(l, " ")
          seq = preprocessed |> List.first() |> String.graphemes()

          grouping =
            preprocessed
            |> List.last()
            |> String.split(",")
            |> Enum.map(&Integer.parse/1)
            |> Enum.map(&elem(&1, 0))

          dfs(seq, grouping) |> IO.inspect()
        end)
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
