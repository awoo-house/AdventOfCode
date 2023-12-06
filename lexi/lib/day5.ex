defmodule Almanac do
  defstruct seeds: [], maps: %{}

  defp nums(input) do
    IO.puts(input)
    String.split(input)
    |> Enum.map(fn x -> Integer.parse(x) end)
    |> Enum.map(fn {num, _rest} -> num end)
  end
  def parse_map_internal([dest_start | [source_start | [range_length]]]) do
    (0..range_length)
    |> Enum.map(fn to_add ->
      {source_start + to_add, dest_start + to_add}
    end)
  end
  def add_mapping(acc, key, input) do
    to_add = {key, parse_map_internal(input)}
    all_mappings = Map.get(acc, :maps, %{})
    this_mapping = Map.get(all_mappings, key, [])
    new_mappings = this_mapping ++ to_add
    new_map = Map.put(all_mappings, key, new_mappings)
    Map.put(acc, :maps, new_map)
  end

  def parse(acc, ["seed-to-soil map:" | input]) do
    IO.puts("----------")
    IO.inspect(input)
    # IO.inspect(rest)
    {{{:seed, :soil}, parse(acc, input)}}
  end
  def parse(acc, ["soil-to-fertilizer map:"| [input | ["" | rest]]]) do
    key = {:soil, :fertilizer }
     parse(add_mapping(acc, key, input), rest)
  end
  def parse(acc, ["fertilizer-to-water map:" |[input | ["" | rest]]]) do
    key = {:fertilizer, :water}
    parse(add_mapping(acc, key, input), rest)
  end
  def parse(acc, ["water-to-light map:" | [input | ["" | rest]]]) do
    key = {:water, :light}
    parse(add_mapping(acc, key, input), rest)
  end
  def parse(acc, ["light-to-temperature map:" | [input | ["" | rest]]]) do
    key = {:light, :temperature}
    parse(add_mapping(acc, key, input), rest)
  end
  def parse(acc, ["temperature-to-humidity map:" | [input | ["" | rest]]]) do
    key = {:temperature, :humidity}
    parse(add_mapping(acc, key, input), rest)
  end
  def parse(acc, ["humidity-to-location map:" | [input | ["" | rest]]]) do
    key = {:humidity, :location }
    parse(add_mapping(acc, key, input), rest)
  end
  def parse(acc, ["seeds: " <> seed_str | rest]) do
    seeds = nums(seed_str)
    parse(Map.put(acc, :seeds, seeds), rest)
  end
  def parse(acc, [""|rest]), do: parse(acc, rest)
  def parse(acc, [a|rest]), do: parse(acc, a)
  def parse(acc, ""), do: acc

  def parse(acc, input) do
    IO.inspect(input)
    case Integer.parse(String.slice(input, (0..1))) do
      :error ->
        # Full string to be parsed
        i = String.split(input, "\n")
        |> Enum.map(fn x -> String.trim(x) end)
        res = parse(acc, i)
        IO.inspect(res)
      {_, _} ->
        nums(input)
        |> parse_map_internal
    end
  end
end

defmodule Day5 do



  def runP1 do
    case File.read("./lib/inputs/day5.txt") do
      {:ok, input} -> input
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
