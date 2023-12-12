defmodule Day10 do

  @updown         "║"
  @leftright      "═"
  @upright        "╚"
  @upleft         "╝"
  @downleft       "╗"
  @downright      "╔"
  @ground         "."
  # @start          "✪"
  @outside        "∅"
  @outside_squp   "⁰"
  @outside_sqdown "₀"
  @inside         "◆"
  @inside_squp    "◠"
  @inside_sqdown  "◡"

  def pretty("|"), do: @updown
  def pretty("-"), do: @leftright
  def pretty("L"), do: @upright
  def pretty("J"), do: @upleft
  def pretty("7"), do: @downleft
  def pretty("F"), do: @downright
  def pretty("."), do: @ground
  # def pretty("S"), do: @start

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn { line, y_index } ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn { char, x_index } ->
        { {x_index, y_index}, { char, -1, @ground} }
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
    # Map.keys(grid)
    # |> IO.inspect
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

    paths = Enum.filter(valids, fn {x, {valid, _dir}} ->
      Enum.any?(valid, fn v ->
        {char, _, _p} = Map.get(grid, x, {nil, nil})
        v == char
      end)
    end)
    |> Enum.map(fn {index, {_v, dir}} ->
      {char, _n, _p} = Map.get(grid, index)
      {index, char, dir, 1}
    end)

    p = case paths |> Enum.map(fn {_, _, dir, _} -> dir end) do
      [:from_south, :from_north] -> @updown
      [:from_south, :from_west] -> @upright
      [:from_south, :from_east] -> @upleft
      [:from_north, :from_south] -> @updown
      [:from_north, :from_west] -> @downright
      [:from_north, :from_east] -> @downleft
      [:from_east, :from_north] -> @downleft
      [:from_east, :from_west] -> @leftright
      [:from_east, :from_south] -> @updown
      [:from_west, :from_north] -> @downright
      [:from_west, :from_south] -> @upright
      [:from_west, :from_east] -> @leftright
    end

    ng = Map.put(grid, {x, y}, {"S", 1, p})
    {first_idx, first_char, first_dir, dist} = paths |> List.first

    # Map.keys(grid)
    # |> IO.inspect

    traverse(ng, first_char, first_idx, first_dir, dist)
  end

  def next_index({x, y}, "|", :from_south), do: {{x, y-1}, :from_south, }
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

    xs = Enum.map(grid, fn {{x, _y}, {_c, _d, _p}} ->
      x
    end)
    ys = Enum.map(grid, fn {{_x, y}, {_c, _d, _p}} ->
      y
    end)
    max_x = Enum.max(xs)
    max_y = Enum.max(ys)
    gai = %{
      :is_inside => false,
      :cur_squeeze_dir => nil,
      :grid => grid
    }
    Enum.reduce((0..max_y), gai, fn y, ac ->
      a = %{
        :is_inside => false,
        :cur_squeeze_dir => nil,
        :grid => ac[:grid]
      }
      Enum.reduce((0..max_x), a, fn x, acc ->
        is_inside = acc[:is_inside]
        last_squeeze_dir = acc[:cur_squeeze_dir]
        {_char, d, p} = Map.get(acc[:grid], {x, y})
        # new_inside = if is_inside do
        #   if p in [@updown, ]
        # else

        # end

        {new_inside, squeeze_dir, new_p} = case {is_inside, last_squeeze_dir, p} do
          {true,  _, @updown} -> {false, nil, @outside}
          {false, _, @updown} -> {true, nil, @outside}
          {false, _, @ground} -> {false, nil, @outside}

          {false, nil, @upright} -> {false, :down, @outside_sqdown}
          {false, nil, @downright} -> {false, :up, @outside_squp}

          {false, :up, @leftright} -> {false, :up, @outside_squp}
          {false, :up, @downright} -> {false, :up, @outside_squp}
          {false, :up, @downleft} -> {false, :up, @outside_squp}
          {false, :up, @upleft} -> {true, nil, @inside}
          {false, :up, @upright} -> {false, :down, @outside_sqdown}

          {false, :down, @downleft} -> {true, nil, @inside}
          {false, :down, @leftright} -> {false, :down, @outside_sqdown}
          {false, :down, @upleft} -> {false, :down, @outside_sqdown}
          {false, :down, @upright} -> {false, :down, @outside_sqdown}
          {false, :down, @downright} -> {false, :up, @outside_squp}


          {true, nil, @downright} -> {true, :up, @inside_squp}
          {true, nil, @upright} -> {true, :down, @inside_sqdown}
          {true, nil, @ground} -> {true, nil, @inside}

          {true, :up, @leftright} -> {true, :up, @inside_squp}
          {true, :up, @downleft} -> {true, :up, @inside_squp}
          {true, :up, @upleft} -> {false, nil, @outside}
          {true, :up, @downright} -> {true, :up, @inside_squp}
          {true, :up, @upright} -> {true, :down, @inside_sqdown}
          {true, :up, @ground} -> {true, nil, @inside}

          {true, :down, @downleft} -> {false, nil, @outside}
          {true, :down, @upleft} -> {true, :down, @inside_sqdown}
          {true, :down, @upright} -> {true, :down, @inside_sqdown}
          {true, :down, @ground} -> {true, nil, @inside}
          {true, :down, @leftright} -> {true, :down, @inside_sqdown}
          {true, :down, @downright} -> {true, :up, @inside_sqdown}


        end

        # IO.inspect("{#{p}, #{is_inside}, #{last_squeeze_dir}} --> {#{new_p}, #{new_inside}, #{squeeze_dir}}")
        this_grid = if d < 0 do
          # is ground
          new_char = if is_inside do @inside else @outside end
          Map.put(acc[:grid], {x, y}, {new_char, -1, new_p})
        else
          acc[:grid]
        end
        %{
          :is_inside => new_inside,
          :cur_squeeze_dir => squeeze_dir,
          :grid => this_grid
        }
      end)
    end)
    |> then(fn x -> x[:grid] end)
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
        acc <> p
      end)
      IO.puts(line)
    end)

    inside_count = Enum.count(grid, fn {{_x, _y}, {_c, _d, p}} ->
      p == @inside
    end)

    IO.puts("The number of tiles enclosed by the loop is #{inside_count}")
  end

  def run do
    case File.read("./lib/inputs/day10.txt") do
      {:ok, input} -> parse(input)
        |> build_graph
        |> label_ground
        |> print
      {:error, reason} -> IO.write(reason)
    end
  end
end
