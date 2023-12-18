defmodule Advent10 do

  def bfs(grph) do
    start = grph[:start]
    shape = grph[:shape]
    init  = %{ :start => start, :shape => shape }

    bfs(grph, [{start, 0}], init)
  end

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
    char_grid =
      inp
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(&String.to_charlist/1)

    grid =
      char_grid
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
         ( {?F, x, y}, acc ) -> Map.put(acc, {x, y}, { {x+1, y}, {x, y+1} })
         ( {?S, x, y}, acc ) -> Map.put(acc, :start, {x, y})
         ( {c, x, y}, _ ) -> raise "Unknown character '#{c}' @ {#{x}, #{y}}"
         ( o, _ ) -> raise "Unknown input #{inspect(o)}!!!"
      end)

    [ln | _] = char_grid
    w = length(ln)
    h = length(char_grid)

    start = grid[:start]
    grid = Map.put(grid, :shape, { w-1, h-1 })

    [s1, s2] = Map.filter(grid, fn {_, {l, r}} -> l == start or r == start end)
                |> Map.keys

    Map.put(grid, start, {s1, s2})
  end

  def find_max(inp) do
    parse(inp)
    |> then(fn grph -> bfs(grph) end)
    |> Map.values
    |> Enum.max
  end

  #### IT'S COMP GEO TIME BABY! #####################################################

  def scan_line(map, y) do
    {w, _} = map[:shape]

    {_, ins} = Enum.reduce(0..w, {:out, []},
      fn
        ##### OUTSIDE #####################
        (x, {:out, acc}) ->
          case Map.get(map, {x, y}) do
            nil -> {:out, acc}
            _   ->
              if dmatch(map, {x,y}, :up, :down) or
                 dmatch(map, {x,y}, :left, :down) or
                 dmatch(map, {x,y}, :right, :down)
                do   {:in, acc}
                else {:out, acc}
              end
          end
        ##### INSIDE ######################
        (x, {:in, acc}) ->
          case Map.get(map, {x, y}) do
            nil -> {:in, [{x, y} | acc]}
            _   ->
              if dmatch(map, {x,y}, :up, :down) or
                 dmatch(map, {x,y}, :left, :down) or
                 dmatch(map, {x,y}, :right, :down)
                do   {:out, acc}
                else {:in, acc}
              end
          end
      end)

      ins
  end

  defp node_dir(map, node) do
    Advent10.Node.node_dirs(node, Map.get(map, node))
  end

  defp dmatch(map, node, a, b) do
    {x, y} = node_dir(map, node)
    (x == a and y == b) or (x == b and y == a)
  end

  def in_points(map) do
    route = bfs(map)
    map = Map.filter(map, fn
      {k, _} -> Map.has_key?(route, k)
    end)

    {_, h} = map[:shape]
    pts = Enum.flat_map(0..h, &(scan_line(map, &1)))
    Map.put(map, :in_points, pts)
  end

  ###################################################################################

  def print_map(map, fmt_val \\ &Advent10.Node.pretty/2) do
    start = map[:start]
    {w, h} = map[:shape]
    in_pts = map[:in_points]

    for y <- 0..h do
      for x <- 0..w do
        if !is_nil(in_pts) and Enum.member?(in_pts, {x,y})
        do IO.write("I")
        else
          case Map.get(map, {x, y}) do
            _ when {x,y} == start -> IO.write("S")
            { l, r } -> IO.write(fmt_val.({x,y}, { l, r }))
            nil -> IO.write(".")
            n -> IO.write(fmt_val.({x,y}, n))
          end
        end
      end
      IO.puts("")
    end
  end

  #### ENTRYPOINT ###################################################################

  def run do
    case File.read("./lib/Puzz10.input.txt") do
      {:ok, inp} ->
        parsed = Advent10.parse(inp)
        out = Advent10.in_points(parsed)

        IO.puts("Longest: #{length(out[:in_points])}")

      {:error, e} -> IO.puts("Error reading file: #{inspect(e)}!")
    end
  end
end
