defmodule Day10 do

  def pretty("|"), do: "║"
  def pretty("-"), do: "═"
  def pretty("L"), do: "╚"
  def pretty("J"), do: "╝"
  def pretty("7"), do: "╗"
  def pretty("F"), do: "╔"
  def pretty("."), do: "."
  def pretty("S"), do: "✪"

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn { line, y_index } ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn { char, x_index } ->
        { {x_index, y_index}, { char, -1, pretty(char)} }
      end)
    end)
    |> Map.new()
  end

  def get_max_distance(hydrated_grid) do
    hydrated_grid
    |> Enum.max_by(fn {_idx, {_char, distance, _p}} ->
      distance
    end)
    |> then(fn {_idx, {_char, distance, _p}} -> distance/2 end)
  end

  def build_graph(grid) do
    {{x, y}, _start} = Enum.find(grid, fn {{_x, _y}, {char, _, _p}} -> char == "S" end)
    up = {x, y-1}
    down = {x, y+1}
    left = {x-1, y}
    right =  {x+1, y}

    valids = Map.new()
    |> Map.put(up, {["|", "7", "F"], :from_south})
    |> Map.put(down, {["|", "L", "J"], :from_north})
    |> Map.put(left, {["-", "L", "F"], :from_east})
    |> Map.put(right, {["-", "J", "7"], :from_west})

    {first_idx, first_char, first_dir, dist} = Enum.filter(valids, fn {x, {valid, _dir}} ->
      Enum.any?(valid, fn v ->
        {char, _, _p} = Map.get(grid, x, {nil, nil})
        v == char
      end)
    end)
    |> Enum.map(fn {index, {_v, dir}} ->
      {char, _n, _p} = Map.get(grid, index)
      {index, char, dir, 1}
    end)
    |> List.first

    traverse(grid, first_char, first_idx, first_dir, dist)

  end

  def next_index({x, y}, "|", :from_south), do: {{x, y-1}, :from_south}
  def next_index({x, y}, "|", :from_north), do: {{x, y+1}, :from_north}
  def next_index({x, y}, "-", :from_west), do: {{x+1, y}, :from_west}
  def next_index({x, y}, "-", :from_east), do: {{x-1, y}, :from_east}
  def next_index({x, y}, "L", :from_north), do: {{x+1, y}, :from_west}
  def next_index({x, y}, "L", :from_east), do: {{x, y-1}, :from_south}
  def next_index({x, y}, "J", :from_north), do: {{x-1, y}, :from_east}
  def next_index({x, y}, "J", :from_west), do: {{x, y-1}, :from_south}
  def next_index({x, y}, "7", :from_south), do: {{x-1, y}, :from_east}
  def next_index({x, y}, "7", :from_west), do: {{x, y+1}, :from_north}
  def next_index({x, y}, "F", :from_south), do: {{x+1, y}, :from_west}
  def next_index({x, y}, "F", :from_east), do: {{x, y+1}, :from_north}


  def traverse(grid, current_char, {x, y}, direction, distance_from_s) do
    if current_char == "S" do
      grid
    else
      {next_idx, next_dir} = next_index({x, y}, current_char, direction)
      {next_char, _, _p} = Map.get(grid, next_idx)
      new_grid = Map.put(grid, {x, y}, {current_char, distance_from_s + 1, pretty(current_char)})
      traverse(new_grid, next_char, next_idx, next_dir, distance_from_s + 1)
    end
  end

  def label_ground(grid) do

    def_outside = Enum.filter(grid, fn {{x, y}, {c, _d, _p}} ->
      is_left = x == 0
      is_top = y == 0
      is_right = not Map.has_key?(grid, {x+1, y})
      is_bottom = not Map.has_key?(grid, {x, y+1})
      c == "." and (is_bottom or is_left or is_right or is_top)

    end)
    Enum.reduce(def_outside, grid, fn {{x, y}, {c, d, _p}}, acc ->
      Map.put(acc, {x, y}, {c, d, "∅"})
    end)

    # label any ground touching the def outside with outside
    Enum.reduce(def_outside, grid, fn {{x, y}, {c, d, _p}}, acc ->
      Map.put(acc, {x, y}, {c, d, "∅"})
    end)
  end

  def print(grid) do
    xs = Enum.map(grid, fn {{x, _y}, {_c, _d, _p}} ->
      x
    end)
    ys = Enum.map(grid, fn {{_x, y}, {_c, _d, _p}} ->
      y
    end)
    max_x = Enum.max(xs)
    max_y = Enum.max(ys)
    Enum.each((0..max_y), fn y ->
      line = Enum.reduce((0..max_x), "", fn x, acc ->
        {_char, _distance, p} = Map.get(grid, {x, y})
        acc <> " " <> p
      end)
      IO.puts(line)
    end)
  end

  def run do
    case File.read("./lib/inputs/day10.txt") do
      {:ok, input} -> parse(input)
        |> build_graph
        |> get_max_distance
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
