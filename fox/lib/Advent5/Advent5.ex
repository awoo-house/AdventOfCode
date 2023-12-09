defmodule Advent5 do
  alias Advent5.Parse, as: P

  # First pass; very silly:
  @spec min_loc_for_seed(P.almanac(), integer()) :: integer()
  def min_loc_for_seed(_almanac, _seed) do
    0
  end

  @spec get_locs_for_seed(P.almanacMaps(), atom(), integer()) :: list(integer())
  def get_locs_for_seed(maps, seed, whichMap \\ :seed) do

  end

  @spec get_output_id(P.mapEntry(), integer()) :: integer()
  def get_output_id(%{ source_start: s }, id) when id < s, do: id
  def get_output_id(%{ source_start: s, length: l }, id) when id >= s + l, do: id
  def get_output_id(%{ source_start: s, dest_start: d }, id), do: d + (id - s)

end
