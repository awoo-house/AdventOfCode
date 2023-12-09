defmodule Advent5 do
  alias Advent5.Parse, as: P

  def read_almanac(path) do
    case File.read(path) do
      {:error, reason} -> throw ("Cannot open #{path}, because #{reason}")
      {:ok, contents} ->
        Advent5.Token.tokenize(contents) |>
          P.parseAlmanac
    end
  end

  ##############################################################################

  # First pass; very silly:
  @spec get_lowest_loc_num(P.almanac()) :: integer()
  def get_lowest_loc_num(almanac) do
    Enum.reduce(almanac.seeds, nil, fn
      (seed_id, nil) -> get_locs_for_seed(almanac.maps, seed_id)
      (seed_id, acc) -> min(acc, get_locs_for_seed(almanac.maps, seed_id))
     end)
  end

  @spec get_locs_for_seed(P.almanacMaps(), integer(), atom()) :: integer()
  def get_locs_for_seed(maps, id, which_map \\ :seed)
  def get_locs_for_seed(_, id, :location), do: id
  def get_locs_for_seed(maps, id, which_map) do
    map = maps[which_map]
    next_map = map.to_map
    next_id = get_output_id(map.entries, id)

    get_locs_for_seed(maps, next_id, next_map)
  end


  @spec get_output_id([P.mapEntry()], integer()) :: integer()
  def get_output_id([], id), do: id
  def get_output_id([m | ms], id) do
    case get_mapped_id(m, id) do
      :unmapped -> get_output_id(ms, id)
      new_id -> new_id
    end
  end


  @spec get_mapped_id(P.mapEntry(), integer()) :: integer() | :unmapped
  def get_mapped_id(%{ source_start: s }, id) when id < s, do: :unmapped
  def get_mapped_id(%{ source_start: s, length: l }, id) when id >= s + l, do: :unmapped
  def get_mapped_id(%{ source_start: s, dest_start: d }, id), do: d + (id - s)


  ##############################################################################

  def run do
    read_almanac("./lib/Puzz5.input.txt")
      |> get_lowest_loc_num
      |> IO.inspect
  end
end
