defmodule Almanac do
  defstruct seeds: [], maps: %{}

  @keys [
    {:seed, :soil },
    {:soil, :fertilizer },
    {:fertilizer, :water},
    {:water, :light},
    {:light, :temperature},
    {:temperature, :humidity},
    {:humidity, :location }
  ]

  def keys do
    @keys
  end



  def hydrated_mapping(map, highest_number_to_map)  do
    state = %{
      :new_mapping => [],
      :last_number_mapped => -1
    }

    res = Enum.sort_by(map, fn {_dest_start, {source_start, _count}} ->
      source_start
    end)
    |> Enum.reduce(state, fn {dest_start, {source_start, count}}, acc ->
      nm = acc[:new_mapping]
      lm = acc[:last_number_mapped]

      always_add = {dest_start, {source_start, count}}

      # IO.inspect("Checking if need to add extraa mapping while hydrating. lm: #{lm}, source_start: #{source_start}")
      to_add = if lm + 1 != source_start do
        # IO.inspect("Need to add an additional mapping while hydrating: ")
        # IO.inspect({lm + 1, {lm + 1, source_start - lm - 1}})
        [{lm + 1, {lm + 1, source_start - lm - 1}}, always_add]
      else
        [always_add]
      end
      %{
        :new_mapping => nm ++ to_add,
        :last_number_mapped => source_start + count - 1
      }
    end)
    int = Map.get(res, :new_mapping)
    highest_so_far = Map.get(res, :last_number_mapped)
    if highest_so_far < highest_number_to_map do
      diff = highest_number_to_map - highest_so_far
      Map.put(res, :new_mapping, int ++ [{ highest_so_far + 1, {highest_so_far + 1, highest_number_to_map}}])
      |> Map.get(:new_mapping)
    else
      int
    end
  end


  defp nums(input) do
    String.split(input)
    |> Enum.map(fn x -> Integer.parse(x) end)
    |> Enum.map(fn {num, _rest} -> num end)
  end
  def parse_map_internal([dest_start | [source_start | [range_length]]]) do
    [
      {dest_start, {source_start, range_length}}
    ]
  end
  def add_mapping(input, acc, key) do
    to_add = parse_map_internal(input)
    all_mappings = Map.get(acc, :maps, %{})
    this_mapping = Map.get(all_mappings, key, [])
    new_mappings = this_mapping ++ [to_add]
    new_map = Map.put(all_mappings, key, new_mappings)
    Map.put(acc, :maps, new_map)
  end

  def parse(acc, ["seed-to-soil map:" | rest]) do
    key = {:seed, :soil }
    parse(Map.put(acc, :current_key, key), rest)
  end
  def parse(acc, ["soil-to-fertilizer map:"| rest]) do
    key = {:soil, :fertilizer }
    parse(Map.put(acc, :current_key, key), rest)
  end
  def parse(acc, ["fertilizer-to-water map:" |rest]) do
    key = {:fertilizer, :water}
    parse(Map.put(acc, :current_key, key), rest)
  end
  def parse(acc, ["water-to-light map:" | rest]) do
    key = {:water, :light}
    parse(Map.put(acc, :current_key, key), rest)
  end
  def parse(acc, ["light-to-temperature map:" | rest]) do
    key = {:light, :temperature}
    parse(Map.put(acc, :current_key, key), rest)
  end
  def parse(acc, ["temperature-to-humidity map:" | rest]) do
    key = {:temperature, :humidity}
    parse(Map.put(acc, :current_key, key), rest)
  end
  def parse(acc, ["humidity-to-location map:" | rest]) do
    key = {:humidity, :location }
    parse(Map.put(acc, :current_key, key), rest)
  end
  def parse(acc, ["seeds: " <> seed_str | rest]) do
    seeds = nums(seed_str)
    parse(Map.put(acc, :seeds, seeds), rest)
  end
  def parse(acc, [""|rest]), do: parse(acc, rest)
  def parse(acc, [a|rest]), do: parse(parse(acc, a), rest)
  def parse(acc, ""), do: acc
  def parse(acc, []), do: acc

  def parse(acc, input) do
    case Integer.parse(String.slice(input, (0..1))) do
      :error ->
        # Full string to be parsed

        # get biggest number seen in entire string. Kinda mehh, but whatever
        biggest_num = Regex.scan(~r/(\d+)/, input, capture: :all_but_first)
        |> List.flatten
        |> Enum.map(fn x -> Integer.parse(x) end)
        |> Enum.map(fn {n, _} -> n end)
        |> Enum.sort(:desc)
        |> List.first
        IO.inspect("Biggest number seen is #{biggest_num}")

        i = String.split(input, "\n")
        |> Enum.map(fn x -> String.trim(x) end)
        res = parse(acc, i)
        %Almanac {
          seeds: res[:seeds],
          maps: @keys
          |> Enum.map(fn x ->
            # mm = if x == {:humidity, :location} do
              # hydrated_mapping(List.flatten(res[:maps][x]), )
            # else
            mm = hydrated_mapping(List.flatten(res[:maps][x]), biggest_num * 2)
            # end
            {x, mm }
          end)
          |> Map.new
        }
      {_, _} ->
        # Mapping line
        nums(input)
        |> add_mapping(acc, acc[:current_key])
    end
  end
end

defmodule Day5 do
  def get_mapped_value(almanac, key, val) do
    IO.puts("Getting mapped value #{inspect(key)} for #{val}")
    in_range = almanac.maps[key]
    |> Enum.map(fn {dest, {src, range}} ->
      if val >= src and val < src + range do
        # how much above src is val?
        above = val-src
        ret = dest + above
        ret
      else
        false
      end
    end)
    |> Enum.filter(fn x -> x end)

    ret = List.first(in_range, val)
    IO.puts("... it's #{ret}")
    ret

  end
  def get_lowest_location(almanac) do
    almanac.seeds
    |> Enum.map(fn seed ->
      IO.puts("seed: #{seed}")
      Almanac.keys
      |> Enum.reduce(seed, fn key, current_value -> get_mapped_value(almanac, key, current_value) end)
    end)
    |> Enum.sort
    |> List.first
  end

  # Source Range Destination starts higher than the destination can ever get to
  def get_dest_mappings_for_source_range(dest_start, count, {t_dest_start, {_t_source_start, _t_len}})
    when dest_start + count <= t_dest_start do
      # IO.inspect("for the range (dest_start=#{dest_start}) and t_dest_start=#{t_dest_start} and dest_count=#{count}, we think that this source's range is ALWAYS higher than the destination range")
    nil
  end

  # Destination starts higher than Source Range Destination ever gets to.
  def get_dest_mappings_for_source_range(dest_start, _count, {t_dest_start, {_t_source_start, t_len}})
    when t_dest_start + t_len <= dest_start do
      # IO.inspect("for the range (dest_start=#{dest_start}) and t_dest_start=#{t_dest_start} and t_len=#{t_len}, we think that this source's range is ALWAYS lower than the destination range")
    nil
  end

  # The destination range is fully encompassed by the Source Range Destination
  def get_dest_mappings_for_source_range(dest_start, count, {t_dest_start, {t_source_start, t_len}})
    when dest_start >= t_dest_start
      and (dest_start + count) < (t_dest_start + t_len) do
    diff = t_source_start + (dest_start - t_dest_start)
    # IO.inspect("for the range (dest_start=#{dest_start}) and count=#{count} and t_dest_start=#{t_dest_start} and t_source_start=#{t_source_start} and t_len=#{t_len},
    #   we think that this destination range is ALWAYS within the source range. Thus, we return the new range: {#{dest_start}, {#{diff}, #{count}}}")

    {dest_start, {diff, count}}
  end

  # The destination range fully encompasses the Source Range Destination
  def get_dest_mappings_for_source_range(dest_start, count, {t_dest_start, {t_source_start, t_len}})
    when t_dest_start >= dest_start
      and (dest_start + count) >= (t_dest_start + t_len) do
    # IO.inspect("for the range (dest_start=#{dest_start}) and count=#{count} and t_dest_start=#{t_dest_start} and t_source_start=#{t_source_start} and t_len=#{t_len},
    # we think that this destination range FULLY SURROUNDS the source range. Thus, we return the new range: {#{t_dest_start}, {#{t_source_start}, #{t_len}}}")

    {t_dest_start, {t_source_start, t_len}}
  end

  # The destination range ONLY intersects with the lower bound of the Source Range Destination
  def get_dest_mappings_for_source_range(dest_start, count, {t_dest_start, {t_source_start, t_len}})
    when dest_start < t_dest_start
      and (dest_start + count) < (t_dest_start + t_len) do
    diff = count - (t_dest_start - dest_start)
    # IO.inspect("for the range (dest_start=#{dest_start}) and count=#{count} and t_dest_start=#{t_dest_start} and t_source_start=#{t_source_start} and t_len=#{t_len},
    # we think that this destination range INTERSECTS the source range at the TOP END. Thus, we return the new range: {#{t_dest_start}, {#{t_source_start}, #{diff}}}")

    {t_dest_start, {t_source_start, diff}}
  end

  # The destination range ONLY intersects with the upper bound of the Source Range Destination
  def get_dest_mappings_for_source_range(dest_start, count, {t_dest_start, {t_source_start, t_len}})
    when dest_start > t_dest_start
      and (dest_start + count) >= (t_dest_start + t_len) do
    count_diff = t_len - (dest_start - t_dest_start)
    source_start_diff = t_source_start + (dest_start - t_dest_start)
    # IO.inspect("for the range (dest_start=#{dest_start}) and count=#{count} and t_dest_start=#{t_dest_start} and t_source_start=#{t_source_start} and t_len=#{t_len},
    # we think that this destination range INTERSECTSS the source range at the BOTTOM END. Thus, we return the new range: {#{dest_start}, {#{source_start_diff}, #{count_diff}}}")

    {dest_start, {source_start_diff, count_diff}}
  end

  # We're going to build the location -> seed ranges
  def get_source_ranges_for_dest_range(dest_start, count, all_source_ranges)  do
    # IO.inspect("000000000000000000")
    # IO.inspect(all_source_ranges)
    Enum.map(all_source_ranges, fn x ->
      get_dest_mappings_for_source_range(dest_start, count, x)
    end)
    |> Enum.filter(fn x -> x end)
  end


  def get_source_ranges_for_dest_ranges(source_and_dest_ranges)  do
    Enum.flat_map(source_and_dest_ranges, fn {dest_start, count, all_source_ranges} ->
      get_source_ranges_for_dest_range(dest_start, count, all_source_ranges)
    end)
    # |> IO.inspect
  end

  # Location 0 is
  # humidity 70...100 -> location 0...30
  # which should break into
  # temp 70...80 -> humid 70...80, AND temp 81...90 -> humid 91...100, AND temp 90...100 -> humid 81...90, AND temp 100 -> humid 100

  def flatten_mappings(from_map, to_map) do

    s_from = Enum.sort(from_map)
    s_to = Enum.sort(to_map)

    Enum.flat_map(s_from, fn {dest_start, {source_start, count}} ->
      # IO.inspect("Mapping from the current map's dest_start #{dest_start}, source_start #{source_start}, count #{count}")
      res = get_source_ranges_for_dest_range(source_start, count, s_to)
      |> Enum.map(fn {new_dest_start, {new_source_start, new_count}} ->
        diff = dest_start - source_start
        {new_dest_start + diff, {new_source_start, new_count}}
      end)
      # IO.inspect(res)
      # IO.inspect("ssssssssssssssssssssssssss")
      res
    end)
  end

  def reverse_mapping(map) do
    Enum.map(map, fn {dest_start, {source_start, count}} ->
      {source_start, {dest_start, count}}
    end)
  end

  def lowest_locations_by_seed_value_ranges(almanac) do

    # IO.inspect("=========================")
    location_to_humidity = almanac.maps[{:humidity, :location }]
    # IO.inspect(location_to_humidity)
    [
      {:seed, :soil },
      {:soil, :fertilizer },
      {:fertilizer, :water},
      {:water, :light},
      {:light, :temperature},
      {:temperature, :humidity},
    ]
    |> List.foldr(location_to_humidity, fn key, acc ->
      # IO.inspect("=========================")
      # IO.inspect(acc)
      # IO.inspect(key)
      # IO.inspect(almanac.maps[key])
      # reverse_mapped = reverse_mapping(almanac.maps[key])
      # IO.inspect(reverse_mapped)
      # IO.inspect("Now adding the map of ...")
      # IO.inspect(key)
      flatten_mappings(acc, almanac.maps[key])
    end)
  end

  def find_lowest_seed_in_locations(loc_map, almanac) do
    # IO.inspect(loc_map)
    seed_ranges = Enum.chunk_every(almanac.seeds, 2, 2)
    # |> Enum.sort
    |> Enum.map(fn [s, c] -> {s, c} end)

    IO.inspect(seed_ranges)

    Enum.find(loc_map, fn {location, {first_seed_for_location, seed_count}} ->
      last_seed_for_location = first_seed_for_location + seed_count - 1
      IO.inspect("checking seed range #{first_seed_for_location} -> #{last_seed_for_location} for location #{location}")

      Enum.find(seed_ranges, fn {range_start, cnt} ->
        this_range_end = range_start + cnt

        IO.inspect("checking seeds... GIVEN seed range #{range_start} -> #{this_range_end}")
        # IO.inspect("#{last_seed_for_location} < #{range_start} ? and also,  #{this_range_end} > #{first_seed_for_location}? and also #{last_seed_for_location} <= #{range_start}")

        this_seed_range_too_low = this_range_end <= first_seed_for_location
        this_seed_range_too_high = range_start > last_seed_for_location

        not this_seed_range_too_high and not this_seed_range_too_low

      end)
    end)

  end

  def runP1 do
    case File.read("./lib/inputs/day5.txt") do
      {:ok, input} -> Almanac.parse(%{}, input)
      |> get_lowest_location
      |> IO.inspect

      {:error, reason} -> IO.write(reason)
    end
  end


  def runP2 do
    case File.read("./lib/inputs/day5.txt") do
      {:ok, input} ->
        almanac = Almanac.parse(%{}, input)
        lowest_locations_by_seed_value_ranges(almanac)
        |> find_lowest_seed_in_locations(almanac)
        |> IO.inspect

      {:error, reason} -> IO.write(reason)
    end
  end
end
