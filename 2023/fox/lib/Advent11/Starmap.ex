defmodule Advent11.Starmap do
  defstruct [:galaxy_coords, :empty_cols, :empty_rows]

  @debug false
  @type t() :: %Advent11.Starmap{}
  @type coord() :: { integer(), integer() }

  ##### PUBLIC API #############################################################

  @spec new(String.t()) :: t()
  def new(inp) do
    char_grid = String.split(inp, "\n")
                |> Enum.map(&String.trim/1)
                |> Enum.filter(&(String.length(&1) > 0))
                |> Enum.map(&String.to_charlist/1)

    galaxy_coords = get_galaxy_coordinates(char_grid)
    empty_rows = char_grid |> get_empty_rows
    empty_cols = char_grid |> transpose |> get_empty_rows

    %Advent11.Starmap{ galaxy_coords: MapSet.new(galaxy_coords), empty_cols: empty_cols, empty_rows: empty_rows }
  end

  @spec get_galaxy_pairs(t()) :: list({ {integer(), integer()}, {integer(), integer()} })
  def get_galaxy_pairs(%Advent11.Starmap{ galaxy_coords: coords }) do
    get_combos(MapSet.to_list(coords), MapSet.to_list(coords))
  end

  defp get_combos(_, []), do: []
  defp get_combos([], _), do: []
  defp get_combos([a | as], [b | bs]) do
    [{a, b} | get_combos([a | as], bs)]
    ++ get_combos(as, bs)
  end

  @spec expand(t()) :: t()
  def expand(%Advent11.Starmap{ galaxy_coords: galaxy_coords, empty_cols: empty_cols, empty_rows: empty_rows }) do
    # row_sorted = Enum.sort_by(galaxy_coords, fn ({_, b}) -> b end)
    # expanded_coords = expand_row(row_sorted, empty_cols)

    expanded_coords = galaxy_coords
    transposed = Enum.map(expanded_coords, fn ({a, b}) -> {b, a} end)
    row_sorted = Enum.sort_by(transposed, fn ({_, b}) -> b end)
    expanded_coords = expand_row(row_sorted, empty_rows)

    transposed = Enum.map(expanded_coords, fn ({a, b}) -> {b, a} end)

    %Advent11.Starmap{ galaxy_coords: MapSet.new(transposed), empty_cols: [], empty_rows: [] }
  end

  ##### PRIVATE API ############################################################

  @spec expand_row(list(coord()), list(integer()), integer(), list()) :: list(coord())
  # (0, 0) [ 3, ... ]
  # (0, 1) [ 3, ... ]
  def expand_row(coords, cols_to_skip, skip_count \\ 0, opts \\ [])
  def expand_row([], _, _, _), do: []
  def expand_row(rest, [], _, _), do: rest
  def expand_row([{row, col} | pts], [col_to_skip | cols], skip_count, opts) when col < col_to_skip do
    # IO.puts("Case 1: #{inspect({row, col})} col_to_skip: #{col_to_skip}")
    [{row, col + skip_count} | expand_row(pts, [col_to_skip | cols], skip_count, opts)]
  end
  def expand_row([{row, col} | pts], [_ | cols], skip_count, opts) do
    # IO.puts("Case 2: #{inspect({row, col})} col_to_skip: #{col_to_skip}")
    expand_by = Keyword.get(opts, :expand_by, 1)
    nsk = skip_count + expand_by
    # IO.puts("nsk = #{nsk}")
    [{row, col + nsk} | expand_row(pts, cols, nsk, opts)]
  end

  @spec get_galaxy_coordinates(list(charlist())) :: list({integer(), integer()})
  def get_galaxy_coordinates(dat) do
    get_indices(dat)
    |> Enum.reduce([], fn
      ({row, col}, acc) ->
        if get_row_col(dat, row, col) == ?#
          do [ {row, col} | acc]
          else acc
        end
      end)
  end

  @spec get_galaxy_pairs(t()) :: list({ {integer(), integer()}, {integer(), integer()} })
  def get_galaxy_pairs(map) do
    coords = get_galaxy_coordinates(map)
    cross_product(coords, coords)
    |> Enum.reduce([], fn
      ({ l, r }, acc) ->
        unless Enum.member?(acc, {l,r}) or Enum.member?(acc, {r,l})
          do [{l,r} | acc]
          else acc
        end
      end)
  end


  @spec get_empty_rows(list(charlist())) :: list(integer())
  def get_empty_rows(lines) do
    lines
    |> Enum.with_index
    |> Enum.filter(fn
      { ln, _ } -> Enum.all?(ln, &(&1 == ?.))
    end)
    |> Enum.map(fn
      { _, i } -> i
    end)
  end

  defp get_rows_cols(lns) do
    rows = length(lns)
    cols = length(Enum.at(lns, 0))

    {rows, cols}
  end

  defp cross_product(as, bs) do
    Enum.flat_map(as, fn a -> Enum.map(bs, fn b -> { a, b } end) end)
  end

  defp get_indices(lns) do
    { rows, cols } = get_rows_cols(lns)
    cross_product(0..(cols-1), (0..(rows-1)))
    |> Enum.map(fn {a, b} -> {b, a} end)
  end

  @spec transpose(list(list(t))) :: list(list(t)) when t: any()
  def transpose(lns) do
    {rows, cols} = get_rows_cols(lns)

    if @debug, do: IO.puts("Transposing a #{cols}x#{rows} list...")

    indices = get_indices(lns)
    if @debug, do: IO.inspect(indices)

    Enum.reduce(indices, [], fn
      (nil, _) -> raise "GOT NIL FOR INDEX?!"
      ({row, col}, acc) ->
        if @debug, do: IO.puts("SUPER DEBUG #{inspect({row,col})}")
        elt = get_row_col(lns, row, col)
        if is_nil(elt), do: raise "COULD NOT FIND ELEMENT AT #{inspect({row, col})} IN INDICES"
        if @debug, do: print_debug_step(lns, row, rows, col, cols)
        if @debug, do: IO.puts("Recording #{to_string([elt])}")
        if @debug, do: IO.puts("========================================")
        [elt | acc]
    end)
    |> Enum.reverse
    |> Enum.chunk_every(rows)
  end

  defp get_row_col(lns, row, col) do
    Enum.at(lns, row) |> Enum.at(col)
  end

  defp print_debug_step(lns, row, rows, col, cols) do
    for r <- 0..(rows-1) do
      for c <- 0..(cols-1) do
        if row == r and col == c
          do   IO.write(IO.ANSI.green() <> to_string([get_row_col(lns, r, c)]) <> IO.ANSI.reset())
          else IO.write(to_string([get_row_col(lns, r, c)]))
        end
      end
      IO.puts("")
    end

    IO.puts("==========")
  end


  ##############################################################################

  defimpl Inspect, for: Advent11.Starmap do
    def inspect(%Advent11.Starmap{ galaxy_coords: dat, empty_cols: empty_cols, empty_rows: empty_rows }, _opts) do
      "<Starmap #{inspect(dat)} empty_cols: #{inspect(empty_cols)} empty_rows: #{inspect(empty_rows)}>"
    end
  end

end
