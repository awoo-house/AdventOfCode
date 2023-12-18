defmodule Advent14 do
  alias MapSet

  alias Advent14.DishMap

  @type dir() :: :north | :south | :east | :west

  ##### ENTRYPOINT #############################################################

  def run do
    case File.read("./lib/Puzz14.input.txt") do
      {:error, why} -> raise "Could not read file! #{inspect(why)}"
      {:ok, inp} ->
        inp = DishMap.new(inp)
        IO.puts("Magic Number = #{calc_weight(inp)}")
    end
  end

  ##### API ####################################################################

  @spec calc_weight(DishMap.t()) :: integer()
  def calc_weight(dmap) do
    # %DishMap{ rocks: rocks, rows: rows } = scooch_rocks_up(dmap)

    # rocks
    # |> Enum.reduce(0, fn
    #   (%{ row: rock_row }, acc) -> acc + (rows - rock_row)
    # end)
  end

  ##### ALGORITHM ##############################################################

  @spec sort_for_dir(list(DishMap.coord()), dir()) :: list(DishMap.coord())
  defp sort_for_dir(rocks, :north), do: Enum.sort_by(rocks, fn %{ row: row } -> row end)
  defp sort_for_dir(rocks, :south), do: Enum.sort_by(rocks, fn %{ row: row } -> row end, :desc)
  defp sort_for_dir(rocks, :east ), do: Enum.sort_by(rocks, fn %{ col: col } -> col end)
  defp sort_for_dir(rocks, :west ), do: Enum.sort_by(rocks, fn %{ col: col } -> col end, :desc)

  # @spec scooch_rocks(DishMap.t(), dir()) :: DishMap.t()
  def scooch_rocks_up(dmap, dir) do
    rocks =
      sort_for_dir(dmap.rocks, dir)
      |> Enum.reduce(dmap.rocks, fn
        (rock, acc) ->
          new_rock = scooch_rock_up(acc, dmap.blocks, rock)

          rocks_without_old = MapSet.delete(acc, rock)
          rocks_with_new = MapSet.put(rocks_without_old, new_rock)

          rocks_with_new
        end)

    %{ dmap | rocks: rocks }
  end

  def scooch_rock(rocks, blocks, rock, dir) do

  end

  def scooch_rock_up(_rocks, _blocks, %{ row: 0, col: rock_col }), do: %{ row: 0, col: rock_col }
  def scooch_rock_up(rocks, blocks, rock) do
    highest_rock  = highest_coord_above(rocks, rock)
    highest_block = highest_coord_above(blocks, rock)

    case comp(highest_rock, highest_block) do
      nil          -> %{row: 0, col: rock.col}
      %{ row: rr } -> %{row: rr + 1, col: rock.col}
    end
  end

  defp comp(nil, b), do: b
  defp comp(a, nil), do: a
  defp comp(%{row: a, col: b}, %{row: c}) when a > c, do: %{row: a, col: b}
  defp comp(_, b), do: b

  @spec highest_coord_above(list(DishMap.coord()), DishMap.coord()) :: DishMap.coord() | nil
  def highest_coord_above(coords, %{ row: r, col: c }) do
    coords
    |> Enum.filter(fn %{ col: cc } -> c == cc end)
    |> Enum.filter(fn %{ row: rr } -> rr < r end)
    |> then(fn
      [] -> nil
      xs -> Enum.max_by(xs, fn %{ row: rr } -> rr end)
    end)
  end

end
