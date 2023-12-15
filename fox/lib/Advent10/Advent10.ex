defmodule Advent10 do

  def bfs(grph, queue, out \\ %{})
  def bfs(grph, {l, r}, out), do: bfs(grph, [{{l, r}, 0}], out)
  def bfs(_, [], out), do: out
  def bfs(grph, [{node, dist} | nodes], out) do
    # IO.puts("Considering #{inspect(node)}@#{inspect(dist)}...")
    case Map.get(out, node) do
      nil ->
        case Map.get(grph, node) do
          nil ->
            # IO.puts("  Unknown node")
            bfs(grph, nodes, Map.put(out, node, dist))
          {l, r} ->
            # Add my distance
            out = Map.put(out, node, dist)
            next = nodes ++ [{l, dist+1}, {r, dist+1}]
            # IO.puts("  Work Queue is: #{inspect(next)}")
            bfs(grph, next, out)
        end
      _ ->
        # IO.puts("  Already seen #{inspect(node)}; skip!")
        bfs(grph, nodes, out)
    end
  end


  def parse(inp) do
    grid =
      inp
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(&String.to_charlist/1)
      |> Enum.with_index
      |> Enum.map(fn { ln, y } ->
        Enum.map(Enum.with_index(ln),
          fn { chr, x } -> { chr, x, y }
        end)
      end)
      |> List.flatten
      |> Enum.reduce(%{},
      fn
         ( {?., _, _}, acc ) -> acc
         ( {?|, x, y}, acc ) -> Map.put(acc, {x, y}, { {x, y-1}, {x, y+1} })
         ( {?-, x, y}, acc ) -> Map.put(acc, {x, y}, { {x-1, y}, {x+1, y} })
         ( {?L, x, y}, acc ) -> Map.put(acc, {x, y}, { {x, y-1}, {x+1, y} })
         ( {?J, x, y}, acc ) -> Map.put(acc, {x, y}, { {x-1, y}, {x, y-1} })
         ( {?7, x, y}, acc ) -> Map.put(acc, {x, y}, { {x-1, y}, {x, y+1} })
         ( {?F, x, y}, acc ) -> Map.put(acc, {x, y}, { {x+1, y}, {x, y-1} })
         ( {?S, x, y}, acc ) -> Map.put(acc, :start, {x, y})
         ( {c, x, y}, _ ) -> raise "Unknown character '#{c}' @ {#{x}, #{y}}"
         ( o, _ ) -> raise "Unknown input #{inspect(o)}!!!"
      end)

    start = grid[:start]

    [s1, s2] = Map.filter(grid, fn {_, {l, r}} -> l == start or r == start end)
                |> Map.keys

    Map.put(grid, start, {s1, s2})
  end
end
