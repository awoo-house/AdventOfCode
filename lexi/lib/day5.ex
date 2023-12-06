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

  defp nums(input) do
    String.split(input)
    |> Enum.map(fn x -> Integer.parse(x) end)
    |> Enum.map(fn {num, _rest} -> num end)
  end
  def parse_map_internal([dest_start | [source_start | [range_length]]]) do
    [
      {source_start, {dest_start, range_length}}
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
        i = String.split(input, "\n")
        |> Enum.map(fn x -> String.trim(x) end)
        res = parse(acc, i)
        %Almanac {
          seeds: res[:seeds],
          maps: @keys |> Enum.map(fn x -> {x, List.flatten(res[:maps][x]) } end) |> Map.new
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
    |> Enum.map(fn {src, {dest, range}} ->
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
      {:ok, input} -> input
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
