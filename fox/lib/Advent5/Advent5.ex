defmodule Advent5 do
  alias Advent5.Parse, as: P
  alias Advent5.MapEntry

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

  # @spec get_lowest_loc_num_from_seed_ranges(P.almanac()) :: integer()
  # def get_lowest_loc_num_from_seed_ranges(almanac) do

  # end


  @doc """
    THIS EXPECTS THE MAP ENTRIES (bs) TO BE SORTED BY SOURCE ID!
  """
  @spec mk_entry_overlaps(P.mapEntry(), list(P.mapEntry())) :: list(P.mapEntry())
  def mk_entry_overlaps(a, []), do: [a]
  def mk_entry_overlaps(a, bs) when a.length <= 0, do: bs
  #   1) -------
  #             -----
  def mk_entry_overlaps(a, [b | bs]) when a.dest_start + a.length < b.source_start do
    [b | mk_entry_overlaps(a, bs)]
  end
  #   2) -------
  #         -----
  def mk_entry_overlaps(a, [b | bs]) when a.dest_start < b.source_start and (a.dest_start + a.length) >= b.source_start do
    # Gets transformed to:
    #   2) ---|----|
    #         |----|-

    new_start_len = b.source_start - a.dest_start
    mid_len = min(a.length - new_start_len, b.length)

    start = %MapEntry{ source_start: a.source_start, dest_start: a.dest_start, length: new_start_len }
    mid   = %MapEntry{ source_start: a.source_start + new_start_len, dest_start: b.dest_start, length: mid_len }
    acc   = %MapEntry{ source_start: b.source_start + mid_len, dest_start: b.dest_start + mid_len, length: b.length - mid_len }

    [start, mid | mk_entry_overlaps(acc, bs)]
  end
  #   4)   -------
  #      -----
  def mk_entry_overlaps(a, [b | bs]) when b.source_start <= a.dest_start do
    # Gets transformed to:
    #   4)   |----|---
    #      -|----|
    new_start_len = a.dest_start - b.source_start
    new_mid_len   = b.length - new_start_len

    start = %MapEntry{ source_start: b.source_start, dest_start: b.dest_start, length: new_start_len }
    mid   = %MapEntry{ source_start: a.source_start, dest_start: b.dest_start, length: new_mid_len }
    acc   = %MapEntry{ source_start: a.source_start + new_mid_len, dest_start: a.dest_start + new_mid_len, length: (a.length - new_mid_len) }

    [start, mid | mk_entry_overlaps(acc, bs)]
  end




  # def mk_entry_overlaps(a, [b | bs]) when a.dest_start >= b.source_start and a.dest_start < (b.source_start + b.length-1) do
  #   new_entry_length = min(a.length, b.length)

  #   new_entry = %MapEntry{ source_start: a.source_start, dest_start: b.dest_start, length: new_entry_length }
  #   new_acc = %MapEntry{ source_start: a.source_start + new_entry_length, dest_start: a.dest_start + new_entry_length, length: a.length - new_entry_length }

  #   [new_entry | mk_entry_overlaps(new_acc, bs)]
  # end
  # def mk_entry_overlaps(a, [b | bs]) do
  #   [b | mk_entry_overlaps(a, bs)]
  # end

  @spec sorted_entries(P.almanac(), atom()) :: list(P.mapEntry())
  def sorted_entries(almanac, which_map) do
    Enum.sort_by(almanac.maps[which_map].entries, fn e -> e.source_start end)
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
      # |> get_lowest_loc_num_from_seed_ranges
      |> IO.inspect
  end
end
