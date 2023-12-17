defmodule Advent13 do
  import Bitwise

  @type mirrormap() :: list(integer())

  ##### API ####################################################################

  @spec find_mirror_line(String.t()) :: { :row, integer() }, { :col, integer() }
  def find_mirror_line(inp) do
    case parse_and_find(inp) do
      nil -> case parse_and_find(inp, transpose: true) do
        nil -> raise "COULD NOT FIND A MIRROR LINE FOR INPUT:\n#{inp}\n======================="
        col -> { :col, col }
      end
      row -> { :row, row }
    end
  end

  @spec parse_and_find(String.t(), keyword()) :: integer() | nil
  defp parse_and_find(inp, opts \\ []) do
    parsed = parse(inp, opts)
    maybes = find_possible_mirror_lines(parsed)
    find_mirror_row(parsed, maybes)
  end

  ##### ALGORITHM ##############################################################

  #   012345678
  # 0 #...##..#
  # 1 #....#..#
  # 2 ..##..###
  # 3 #####.##.
  # 4 #####.##.
  # 5 ..##..###
  # 6 #....#..#

  @spec parse(String.t(), keyword()) :: mirrormap()
  def parse(inp, opts \\ []) do
    String.split(inp, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&String.to_charlist/1)
    |> then(fn xs -> if Keyword.get(opts, :transpose, false) do transpose(xs) else xs end end)
    |> Enum.map(&line_to_int/1)
  end

  @spec line_to_int(charlist(), integer()) :: integer()
  def line_to_int(chars       , acc \\ 0)
  def line_to_int([]          , acc), do: acc
  def line_to_int([?# | chars], acc), do: line_to_int(chars, (acc <<< 1) + 1)
  def line_to_int([?. | chars], acc), do: line_to_int(chars, acc <<< 1)

  @spec find_possible_mirror_lines(mirrormap()) :: list(integer())
  def find_possible_mirror_lines(xs) do
    Enum.zip(xs, Enum.drop(xs, 1))
    |> Enum.with_index
    |> Enum.filter( fn { {a,b}, _ } -> bxor(a,b) == 0 end)
    |> Enum.map(fn { _, i } -> i end)
  end

  @spec check_mirror_line(mirrormap(), integer()) :: boolean()
  def check_mirror_line(xs, row) do
    down = Stream.take(xs, row+1) |> Enum.reverse
    up   = Stream.drop(xs, row+1)

    Enum.zip(down, up)
    |> Enum.all?(fn
      { a, b } ->
        IO.puts("Checking #{a} and #{b}")
        bxor(a, b) == 0
    end)
  end

  @spec find_mirror_row(mirrormap(), list(integer())) :: integer() | nil
  def find_mirror_row(xs, possible_lines) do
    Enum.find(possible_lines, fn row -> check_mirror_line(xs, row) end)
  end

  ##### UTILS ##################################################################

  @spec transpose(list(list(t))) :: list(list(t)) when t: any()
  def transpose(lns) do
    {rows, cols} = get_rows_cols(lns)
    indices = get_indices(lns)

    Enum.reduce(indices, [], fn
      (nil, _) -> raise "GOT NIL FOR INDEX?!"
      ({row, col}, acc) ->
        elt = Enum.at(lns, row) |> Enum.at(col)
        if is_nil(elt), do: raise "COULD NOT FIND ELEMENT AT #{inspect({row, col})} IN INDICES"
        [elt | acc]
    end)
    |> Enum.reverse
    |> Enum.chunk_every(rows)
  end

  defp get_rows_cols(lns) do
    rows = length(lns)
    cols = length(Enum.at(lns, 0))

    {rows, cols}
  end

  defp get_indices(lns) do
    { rows, cols } = get_rows_cols(lns)
    Enum.flat_map(0..(cols-1), fn a -> Enum.map((0..rows-1), fn b -> { a, b } end) end)
    |> Enum.map(fn {a, b} -> {b, a} end)
  end
end
