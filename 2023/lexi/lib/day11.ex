defmodule Day11 do

  @type space :: :space | :galaxy | Integer.t()

  def char("#"), do: :galaxy
  def char("."), do: :space

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn { line, y_index } ->
      line
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn { c, x_index } ->
        { {x_index, y_index}, char(c) }
      end)
    end)
    |> Map.new()
  end

  def print_pairs(grid, p1, p2) do
    Enum.map(grid, fn {p, _} ->
      c = if p1 == p or p2 == p do
        :galaxy
      else
        :space
      end
      Map.put(grid, p, c)
    end)
  end

  def print(:space), do: "."
  def print(:galaxy), do: "#"
  def print(nil), do: "?"
  def print(grid) do

    xs = Enum.map(Map.keys(grid), fn {x, _y} ->
      x
    end)
    ys = Enum.map(Map.keys(grid), fn {_x, y} ->
      y
    end)
    max_x = Enum.max(xs)
    max_y = Enum.max(ys)
    Enum.each((0..max_y), fn y ->
      line = Enum.reduce((0..max_x), "", fn x, acc ->
        c = Map.get(grid, {x, y})
        acc <> print(c)
      end)
      IO.puts(line)
    end)

    # inside_count = Enum.count(grid, fn {{_x, _y}, {_c, _d, p}} ->
    #   p == @inside
    # end)

  end

  def get_expansion(grid) do
    xs = Enum.map(grid, fn {{x, _y}, _c} ->
      x
    end)
    ys = Enum.map(grid, fn {{_x, y}, _c} ->
      y
    end)
    cols_to_expand = Enum.filter((0..Enum.max(xs)), fn check_x ->
      Enum.all?(grid, fn {{x, _y}, c} ->
        check_x != x or c == :space
      end)
    end)

    rows_to_expand = Enum.filter((0..Enum.max(ys)), fn check_y ->
      Enum.all?(grid, fn {{_x, y}, c} ->
        check_y != y or c == :space
      end)
    end)
    {cols_to_expand, rows_to_expand}
  end

  def expand(grid) do
    xs = Enum.map(grid, fn {{x, _y}, _c} ->
      x
    end)
    ys = Enum.map(grid, fn {{_x, y}, _c} ->
      y
    end)
    {cols_to_expand, rows_to_expand} = get_expansion(grid)

    x_expanded_grid = Enum.reduce(cols_to_expand, {0, grid}, fn col_index_to_create, {added, acc} ->
      ng = Enum.map(acc, fn {{x, y}, c} ->
        if x >= col_index_to_create + added do
          {{x + 1, y}, c}
        else
          {{x, y}, c}
        end
      end) |> Map.new
      r = Enum.reduce((0..Enum.max(ys)), ng, fn y, ac ->
        Map.put(ac, {col_index_to_create + added, y}, :space)
      end)
      {added + 1, r}
    end)
    |> elem(1)

    # print(x_expanded_grid)

    new_num_xs = Enum.max(xs) + Enum.count(cols_to_expand)

    y_expanded_grid = Enum.reduce(rows_to_expand, {0, x_expanded_grid}, fn row_index_to_create, {added, acc} ->
      IO.puts("Making row at index #{row_index_to_create}")
      ng = Enum.map(acc, fn {{x, y}, c} ->
        if y >= row_index_to_create + added do
          # IO.puts("{#{x}, #{y}} needs to be shifted down one")
          {{x, y + 1}, c}
        else
          {{x, y}, c}
        end
      end) |> Map.new

      r = Enum.reduce((0..new_num_xs), ng, fn x, ac ->
        Map.put(ac, {x, row_index_to_create + added}, :space)
      end)
      {added + 1, r}
    end)
    |> elem(1)
    y_expanded_grid
  end

  def calculate_shortest_path(point1, point2) do
    {p1x, p1y} = point1
    {p2x, p2y} = point2
    abs(p2y - p1y) + abs(p2x - p1x)
  end

  def calculate_shortest_path_v2(point1, point2, expanded_cols, expanded_rows, expansion_factor \\ 1000000) do
    {p1x, p1y} = point1
    {p2x, p2y} = point2

    higher_x = Enum.max([p1x, p2x])
    lower_x = Enum.min([p1x, p2x])
    higher_y = Enum.max([p1y, p2y])
    lower_y = Enum.min([p1y, p2y])

    cols_crossed = Enum.to_list(lower_x..higher_x)
    rows_crossed = Enum.to_list(lower_y..higher_y)

    expansion_xs_crossed = expanded_cols -- (expanded_cols -- cols_crossed)
    expansion_ys_crossed = expanded_rows -- (expanded_rows -- rows_crossed)

    # IO.puts("for point #{inspect(point1)} and #{inspect(point2)}, the expansion cols and rows crossed between them are #{inspect(expansion_xs_crossed, charlists: :as_lists)} and #{inspect(expansion_ys_crossed, charlists: :as_lists )} ")

    expansions_crossed = Enum.count(expansion_xs_crossed) + Enum.count(expansion_ys_crossed)

    (abs(p2y - p1y) + abs(p2x - p1x)) + (expansions_crossed * expansion_factor) - expansions_crossed
  end

  def get_all_pairs_of_galaxies(grid) do
    galaxies = Enum.filter(grid, fn {{_x, _y}, c} ->
      c == :galaxy
    end)
    pairs = for {{x1, y1}, _} <- galaxies, {{x2, y2}, _} <- galaxies, do: [{x1, y1}, {x2, y2}]|>Enum.sort()

    MapSet.new(pairs) |> MapSet.to_list()
  end


  def run do
    case File.read("./lib/inputs/day11.txt") do
      {:ok, input} -> parse(input)
        |> expand
        |> get_all_pairs_of_galaxies
        |> Enum.map(fn [p1, p2] ->
          calculate_shortest_path(p1, p2)
        end)
        |> Enum.sum
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end


  def runP2 do
    case File.read("./lib/inputs/day11.txt") do
      {:ok, input} ->
        grid = parse(input)
        {cols, rows} = get_expansion(grid)
        grid |> Day11.get_all_pairs_of_galaxies
        |> Enum.map(fn [p1, p2] ->
          Day11.calculate_shortest_path_v2(p1, p2, cols, rows, 1000000)
        end)
        |> Enum.sum
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end
end
