defmodule Advent14.DishMap do
  alias MapSet

  defstruct [:rocks, :blocks, :rows, :cols]

  @type coord() :: %{ row: integer(), col: integer() }
  @type t() :: %Advent14.DishMap{rocks: MapSet.t(coord()), blocks: MapSet.t(coord()), rows: integer(), cols: integer() }

  @spec new(String.t()) :: t()
  def new(inp) do
    lines = String.split(inp, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&to_charlist/1)
    |> Enum.filter(&(length(&1) > 0))

    rows = length(lines)
    cols = length(Enum.at(lines, 0))

    lines
    |> Enum.with_index()
    |> Enum.map(
      fn {ln, row} ->
        Enum.with_index(ln)
        |> Enum.map(fn
          {chr, col} -> {chr, %{ row: row, col: col }}
        end)
      end
    )
    |> Enum.to_list()
    |> List.flatten
    |> acc_line
    |> then(fn { rocks, blocks } -> %Advent14.DishMap{ rocks: rocks, blocks: blocks, rows: rows, cols: cols } end)
  end

  @spec acc_line(list({char(), coord()}), list(coord()), list(coord())) :: { list(coord()), list(coord()) }
  defp acc_line(inp, rocks \\ MapSet.new(), blocks \\ MapSet.new())
  defp acc_line([], rocks, blocks), do: { rocks, blocks }
  defp acc_line([{?O, c} | rest], rocks, blocks), do: acc_line(rest, MapSet.put(rocks, c), blocks)
  defp acc_line([{?#, c} | rest], rocks, blocks), do: acc_line(rest, rocks, MapSet.put(blocks, c))
  defp acc_line([_       | rest], rocks, blocks), do: acc_line(rest, rocks, blocks)



  defimpl Inspect, for: Advent14.DishMap do
    def inspect(%Advent14.DishMap{ rocks: rocks, blocks: blocks, rows: rows, cols: cols }, _opts) do
      Enum.reduce(0..(rows-1), [], fn
        ( r, line_acc ) ->
          line = Enum.reduce(0..(cols-1), [], fn
            ( c, col_acc ) ->
              is_rock?  = MapSet.member?(rocks,  %{row: r, col: c})
              is_block? = MapSet.member?(blocks, %{row: r, col: c})

              if is_rock? and is_block? do
                raise "ERROR! Coordinate <#{c}, #{r}> is both a rock and a block!"
              else
                if is_rock? do [?O | col_acc]
                else
                  if is_block? do [?# | col_acc]
                  else [?. | col_acc]
                  end
                end
              end
          end)

          [ to_string(line |> Enum.reverse) | line_acc ]
      end)
      |> Enum.reverse
      |> Enum.join("\n")
    end
  end


end
