defmodule AmmyEight do
  defp list_to_tuple([l, r]), do: %{left: l, right: r}

  # recursion baybeeeeeeee~
  defp parse_to_map([], acc), do: acc

  defp parse_to_map([line | rest], acc) do
    [l, r] = String.split(line, " = ")

    v =
      r
      |> String.replace_prefix("(", "")
      |> String.replace_suffix(")", "")
      |> String.split(", ")
      |> list_to_tuple()

    m = Map.put(acc, l, v)
    parse_to_map(rest, m)
  end

  def traverse(_, _, "ZZZ", depth) do
    depth
  end

  def traverse(steps, map, cur, depth) do
    # IO.puts("Traversing #{cur}")

    case Map.fetch(map, cur) do
      {:ok, v} ->
        next_step = List.first(steps)
        new_list = List.delete_at(steps, 0) ++ [next_step]
        case next_step do
          "L" ->
            traverse(new_list, map, v.left, depth+1)

          "R" ->
            traverse(new_list, map, v.right, depth+1)

          _ ->
            IO.puts("Idk, not left or right")
        end

      :error ->
        IO.puts("Key not found in the map.")
    end
  end

  def run do
    case File.read("input/day8.in") do
      {:ok, input} ->
        map =
          input
          |> String.split("\n")
          |> parse_to_map(%{})

        pretty_sure_this_is_the_konami_code =
          "LLLRLRLRLLRRRLRRRLRRRLLLRLRLLRRLLRRLRLRLLRLRLRRLLRRRLRLLRRLRRRLRRLLLRRRLRRRLRRRLLLLRRLRRRLRLRRRLRRLLRLRLRRRLRRRLRRLRRRLLLLLLRLRRRLLLLRLRRRLRRRLRLRRLRLRLRLRLRRRLLRRLRLRRLRRLRRLLRLLLRRLRLLRRLRLRRLRRRLRRLLRLRLRLRRLLRLLRRLLLRLRLRRRLRRLLRRRLRLRLRRLLRLRLRLRRLRLRLRRLRRLLRRLRRRLRRRLLLRRRR"

        pretty_sure_this_is_the_konami_code
        |> String.graphemes()
        |> Enum.to_list()
        |> traverse(map, "AAA", 0)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
