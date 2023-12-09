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

      to_add = if lm + 1 != source_start do
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
      Map.put(res, int, int ++ {highest_so_far, {highest_so_far, diff}})
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
            mm = if x == {:humidity, :location} do
              List.flatten(res[:maps][x])
            else
              hydrated_mapping(List.flatten(res[:maps][x]), biggest_num)
            end
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
      IO.inspect("for the range (dest_start=#{dest_start}) and t_dest_start=#{t_dest_start} and dest_count=#{count}, we think that this source's range is ALWAYS higher than the destination range")
    nil
  end

  # Destination starts higher than Source Range Destination ever gets to.
  def get_dest_mappings_for_source_range(dest_start, _count, {t_dest_start, {_t_source_start, t_len}})
    when t_dest_start + t_len <= dest_start do
      IO.inspect("for the range (dest_start=#{dest_start}) and t_dest_start=#{t_dest_start} and t_len=#{t_len}, we think that this source's range is ALWAYS lower than the destination range")
    nil
  end

  # The destination range is fully encompassed by the Source Range Destination
  def get_dest_mappings_for_source_range(dest_start, count, {t_dest_start, {t_source_start, t_len}})
    when dest_start >= t_dest_start
      and (dest_start + count) < (t_dest_start + t_len) do
    diff = t_source_start + (dest_start - t_dest_start)
    IO.inspect("for the range (dest_start=#{dest_start}) and count=#{count} and t_dest_start=#{t_dest_start} and t_source_start=#{t_source_start} and t_len=#{t_len},
      we think that this destination range is ALWAYS within the source range. Thus, we return the new range: {#{dest_start}, {#{diff}, #{count}}}")

    {dest_start, {diff, count}}
  end

  # The destination range fully encompasses the Source Range Destination
  def get_dest_mappings_for_source_range(dest_start, count, {t_dest_start, {t_source_start, t_len}})
    when t_dest_start >= dest_start
      and (dest_start + count) >= (t_dest_start + t_len) do
    IO.inspect("for the range (dest_start=#{dest_start}) and count=#{count} and t_dest_start=#{t_dest_start} and t_source_start=#{t_source_start} and t_len=#{t_len},
    we think that this destination range FULLY SURROUNDS the source range. Thus, we return the new range: {#{t_dest_start}, {#{t_source_start}, #{t_len}}}")

    {t_dest_start, {t_source_start, t_len}}
  end

  # The destination range ONLY intersects with the lower bound of the Source Range Destination
  def get_dest_mappings_for_source_range(dest_start, count, {t_dest_start, {t_source_start, t_len}})
    when dest_start < t_dest_start
      and (dest_start + count) < (t_dest_start + t_len) do
    diff = count - (t_dest_start - dest_start)
    IO.inspect("for the range (dest_start=#{dest_start}) and count=#{count} and t_dest_start=#{t_dest_start} and t_source_start=#{t_source_start} and t_len=#{t_len},
    we think that this destination range INTERSECTS the source range at the TOP END. Thus, we return the new range: {#{t_dest_start}, {#{t_source_start}, #{diff}}}")

    {t_dest_start, {t_source_start, diff}}
  end

  # The destination range ONLY intersects with the upper bound of the Source Range Destination
  def get_dest_mappings_for_source_range(dest_start, count, {t_dest_start, {t_source_start, t_len}})
    when dest_start > t_dest_start
      and (dest_start + count) >= (t_dest_start + t_len) do
    count_diff = t_len - (dest_start - t_dest_start)
    source_start_diff = t_source_start + (dest_start - t_dest_start)
    IO.inspect("for the range (dest_start=#{dest_start}) and count=#{count} and t_dest_start=#{t_dest_start} and t_source_start=#{t_source_start} and t_len=#{t_len},
    we think that this destination range INTERSECTSS the source range at the BOTTOM END. Thus, we return the new range: {#{dest_start}, {#{source_start_diff}, #{count_diff}}}")

    {dest_start, {source_start_diff, count_diff}}
  end

  # We're going to build the location -> seed ranges
  def get_source_ranges_for_dest_range(dest_start, count, all_source_ranges)  do
    IO.inspect(all_source_ranges)
    Enum.map(all_source_ranges, fn x ->
      get_dest_mappings_for_source_range(dest_start, count, x)
    end)
    |> Enum.filter(fn x -> x end)
  end


  def get_source_ranges_for_dest_ranges(source_and_dest_ranges)  do
    Enum.flat_map(source_and_dest_ranges, fn {dest_start, count, all_source_ranges} ->
      get_source_ranges_for_dest_range(dest_start, count, all_source_ranges)
    end)
    |> IO.inspect
  end

  # Location 0 is
  # humidity 70...100 -> location 0...30
  # which should break into
  # temp 70...80 -> humid 70...80, AND temp 81...90 -> humid 91...100, AND temp 90...100 -> humid 81...90, AND temp 100 -> humid 100

  def lowest_locations_by_seed_value_ranges(almanac) do
    location_key = {:humidity, :location }
    sorted_locations = Enum.sort(almanac.maps[location_key])
    IO.inspect(sorted_locations)
    rr = Enum.flat_map(sorted_locations, fn {location_start, {humidity_start, range1}} ->

      IO.inspect("STARTING inverse map creation. Location #{location_start} .... #{location_start + range1}")
      IO.inspect({location_start, humidity_start, range1})

      IO.inspect("ABOUT TO GET INVERSE RANGES FOR {:temperature, :humidity} AGAINST HUMIDITY START #{humidity_start} AND RANGE #{range1}")
      temperature_ranges_for_this_location =
        get_source_ranges_for_dest_range(humidity_start, range1, almanac.maps[{:temperature, :humidity}])

      IO.inspect("We believe that for the location range of (#{location_start}...#{range1}, these are the humidity->temp inverse mappings:")
      IO.inspect(temperature_ranges_for_this_location)
      Enum.flat_map(temperature_ranges_for_this_location, fn {humidity_start, {temperature_start, range2}} ->
        IO.puts("humidity_start: " <> Integer.to_string(humidity_start))
        IO.inspect("ABOUT TO GET INVERSE RANGES FOR {:light, :temperature} AGAINST TEMPERATURE START #{temperature_start} AND RANGE #{range2}")

        light_ranges_for_this_location =
          get_source_ranges_for_dest_range(temperature_start, range2, almanac.maps[{:light, :temperature}])

          IO.inspect("-----4----location #{location_start}")
          IO.inspect(light_ranges_for_this_location)
          Enum.flat_map(light_ranges_for_this_location, fn {temperature_start, {light_start, range3}} ->
            IO.puts("temperature_start: " <> Integer.to_string(temperature_start))
            water_ranges_for_this_location =
              get_source_ranges_for_dest_range(light_start, range3, almanac.maps[{:water, :light}])


            IO.inspect("---5-------location #{location_start}")
            IO.inspect(water_ranges_for_this_location)
            Enum.flat_map(water_ranges_for_this_location, fn {light_start, {water_start, range4}} ->
              IO.puts("light_start: " <> Integer.to_string(light_start))
              fertilizer_ranges_for_this_location =
                get_source_ranges_for_dest_range(water_start, range4, almanac.maps[{:fertilizer, :water}])

                IO.inspect("-----6-----location #{location_start}")
                IO.inspect(fertilizer_ranges_for_this_location)
                Enum.flat_map(fertilizer_ranges_for_this_location, fn {water_start, {fertilizer_start, range5}} ->
                  IO.puts("water_start: " <> Integer.to_string(water_start))
                  soil_ranges_for_this_location =
                    get_source_ranges_for_dest_range(fertilizer_start, range5, almanac.maps[{:soil, :fertilizer}])

                  IO.inspect("-----7-----location #{location_start}")
                  IO.inspect(soil_ranges_for_this_location)
                  Enum.flat_map(soil_ranges_for_this_location, fn {fertilizer_start, {soil_start, range6}} ->
                    IO.puts("fertilizer_start: " <> Integer.to_string(fertilizer_start))
                    seed_ranges_for_this_location =
                      get_source_ranges_for_dest_range(soil_start, range6, almanac.maps[{:seed, :soil}])
                    IO.inspect("-----8----- location #{location_start}")
                    IO.inspect(seed_ranges_for_this_location)
                    %{:location_start => soil_start, :range => range6, :seed_ranges_for_this_location => seed_ranges_for_this_location}
                  end)
                end)
            end)
          end)
      end)
    end)
    IO.inspect("==p..=.=")
    IO.inspect(rr)
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
      {:ok, input} -> Almanac.parse(%{}, input)
      |> lowest_locations_by_seed_value_ranges
      |> Enum.each(fn ar ->
        IO.inspect(ar)
      end)

      {:error, reason} -> IO.write(reason)
    end
  end
end
