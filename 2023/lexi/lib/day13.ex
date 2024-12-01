defmodule VolcanoLine do
  defstruct line: [], dir: nil, index: -1

  @type t(line, dir, index) :: %VolcanoLine{line: line, dir: dir, index: index}
  @type t :: %VolcanoLine{line: list(boolean()), dir: :vert | :horz, index: integer()}

  @spec diffs_in_lines(%VolcanoLine{}, %VolcanoLine{}) :: integer()
  def diffs_in_lines(l1, l2) do
    Enum.zip(l1.line, l2.line)
    |> Enum.count(fn {x, y} -> (x and not y) or (not x and y) end)
  end

  @spec equal?(%VolcanoLine{}, %VolcanoLine{}) :: boolean()
  def equal?(l1, l2) do
    l1.line == l2.line
  end
end

defmodule VolcanoArea do
  defstruct verticals: [], horizontals: [], max_y: nil, max_x: nil

  def at(a, :horz, i) do
    Enum.filter(a.horizontals, fn x -> x.index == i end)
    |> List.first()
  end

  def at(a, :vert, i) do
    Enum.filter(a.verticals, fn x -> x.index == i end)
    |> List.first()
  end
  @type t(verts, horz, maxy, maxx) :: %VolcanoArea{verticals: verts, horizontals: horz, max_x: maxx, max_y: maxy}
  @type t :: %VolcanoArea{verticals: list(VolcanoLine.t()), horizontals: list(VolcanoLine.t()), max_x: integer(), max_y: integer()}
end


defmodule Day13 do

  def parse_run(problem) do
    grid = String.split(problem, "\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn { line, y_index } ->
        line
        |> String.trim()
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn { c, x_index } ->
          { {x_index, y_index}, c == "#" }
        end)
      end)
      |> Map.new()


    xs = Enum.map(Map.keys(grid), fn {x, _y} ->
      x
    end)
    ys = Enum.map(Map.keys(grid), fn {_x, y} ->
      y
    end)
    max_x = Enum.max(xs)
    max_y = Enum.max(ys)

    horz = Enum.map((0..max_y), fn y ->
      lines = Enum.map((0..max_x), fn x ->
        Map.get(grid, {x, y})
      end)
      %VolcanoLine{line: lines, dir: :horz, index: y}
    end)


    vert = Enum.map((0..max_x), fn x ->
      lines = Enum.map((0..max_y), fn y ->
        Map.get(grid, {x, y})
      end)

      %VolcanoLine{line: lines, dir: :vert, index: x}
    end)

    %VolcanoArea{verticals: vert, horizontals: horz, max_y: max_y, max_x: max_x}


  end

  def parse(input) do
    String.split(input, "\n\n")
    |> Enum.map(&parse_run/1)
  end

  defp is_real_mirror(area, dir, x1, x2, smudges) do
    max = case dir do
      :vert -> area.max_x
      :horz -> area.max_y
    end
    Enum.reduce_while((1..max), smudges, fn to_move, smudges_left ->
      case {VolcanoArea.at(area, dir, x1.index - to_move), VolcanoArea.at(area, dir, x2.index + to_move)} do
        {nil, _} -> {:halt, smudges_left}
        {_, nil} -> {:halt, smudges_left}
        {a1, a2} -> case VolcanoLine.diffs_in_lines(a1, a2) do
          x when x <= smudges_left -> {:cont, smudges_left - x}
          x -> {:halt, x}
        end
      end
    end)
  end


  defp find_mirrors_with_smudges(area, dir, l, on_mirror, in_reflection) do
    # IO.puts("Finding mirrors with #{inspect(on_mirror)} smudges ON the mirror, and #{inspect(in_reflection)} smudges reflected")
    find_maybe_mirrors(l, on_mirror)
    # |> IO.inspect()
    |> Enum.map(fn [x1, x2] -> {[x1, x2], is_real_mirror(area, dir, x1, x2, in_reflection)} end)
    |> Enum.filter(fn {_, x} -> x == 0 end)
    |> Enum.map(fn {[x1, x2], _} -> {[x1, x2], x1.index + 1} end)
  end

  def find_mirrors(area, dir) do
     l = case dir do
      :vert -> area.verticals
      :horz -> area.horizontals
    end

    # Two cases:
    # Case 1: the smudge is ON the mirror lines that are right next to each other.
    #    In that case, just try to fix that one, and then use the same code from p1
    # Case 2: there exist on-smudged mirrors, and we just need to make sure that there is
    #    exactly one diff in the mirrored lines
    case find_mirrors_with_smudges(area, dir, l, 1, 0) do
      [] -> find_mirrors_with_smudges(area, dir, l, 0, 1)
      x -> x
    end

  end

  defp find_maybe_mirrors(lines, smudges) do
    # IO.inspect(lines)
    # IO.inspect(smudges)
    lines
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn r ->
      case r do
        [_] -> false
        [f, l] -> VolcanoLine.diffs_in_lines(f, l) == smudges
      end
    end)
  end

  def calc(areas) do
    areas
    |> Enum.reduce(0, fn a, acc ->
      # IO.inspect("Horizontal mirrors...")
      horz_mirrors = find_mirrors(a, :horz)
      # |> IO.inspect
      |> Enum.map(fn {_lines, amt} -> amt * 100 end)
      |> Enum.sum()


      # IO.inspect("Vertical mirrors...")
      vert_mirrors = find_mirrors(a, :vert)
      # |> IO.inspect
      |> Enum.map(fn {_lines, amt} -> amt  end)
      |> Enum.sum()

      acc + horz_mirrors + vert_mirrors
    end)
  end

  def runP1 do
    case File.read("./lib/inputs/day13.txt") do
      {:ok, input} -> parse(input) |> calc |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end


  def runP2 do
    case File.read("./lib/inputs/day13.txt") do
      {:ok, input} -> parse(input)
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end
end
