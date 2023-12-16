defmodule Advent11.Starmap do
  defstruct [:dat]

  @debug false


  @type t() :: %Advent11.Starmap{}

  @spec new(String.t()) :: t()
  def new(inp) do
    String.split(inp, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&String.to_charlist/1)
    |> then(fn dat -> %Advent11.Starmap{ dat: dat } end)
  end

  @spec fmap(t(), (list(charlist()) -> list(charlist()))) :: t()
  def fmap(%Advent11.Starmap{ dat: dat }, f) do
    f.(dat) |> then(fn out -> %Advent11.Starmap{ dat: out } end)
  end

  @spec expand(t()) :: t()
  def expand(map) do
    map |>
    fmap(fn inp ->
      expand_across(inp)
      |> transpose
      |> expand_across
      |> transpose
    end)
  end

  @spec expand_across(list(charlist())) :: list(charlist())
  def expand_across([]), do: []
  def expand_across([ln | rest]) do
    empty? = Enum.all?(ln, fn c -> c == ?. end)
    if empty?
      do [ln, ln | expand_across(rest)]
      else [ln | expand_across(rest)]
    end
  end

  @spec transpose(list(list(t))) :: list(list(t)) when t: any()
  def transpose(lns) do
    rows = length(lns)
    cols = length(Enum.at(lns, 0))

    if @debug, do: IO.puts("Transposing a #{cols}x#{rows} list...")

    indices = Stream.flat_map(0..(cols-1), fn col -> Stream.map(0..(rows-1), fn row -> { row, col } end) end)
              |> Enum.to_list

    Enum.reduce(indices, [], fn
      ({row, col}, acc) ->
        elt = get_row_col(lns, row, col)
        if @debug, do: print_debug_step(lns, row, rows, col, cols)
        if @debug, do: IO.puts("Recording #{to_string([elt])}")
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
    def inspect(%Advent11.Starmap{ dat: dat }, _opts) do
      Enum.map(dat, &to_string/1)
      |> Enum.join("\n")
    end
  end

end
