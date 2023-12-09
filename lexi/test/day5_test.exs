defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  @input """
      seeds: 79 14 55 13\n
      \n
      seed-to-soil map:\n
      50 98 2\n
      52 50 48\n
      \n
      soil-to-fertilizer map:\n
      0 15 37\n
      37 52 2\n
      39 0 15\n
      \n
      fertilizer-to-water map:\n
      49 53 8\n
      0 11 42\n
      42 0 7\n
      57 7 4\n
      \n
      water-to-light map:\n
      88 18 7\n
      18 25 70\n
      \n
      light-to-temperature map:\n
      45 77 23\n
      81 45 19\n
      68 64 13\n
      \n
      temperature-to-humidity map:\n
      0 69 1\n
      1 0 69\n
      \n
      humidity-to-location map:\n
      60 56 37\n
      56 93 4\n
    """

  @tag timeout: 1000
  test "parse" do

    res = Almanac.parse(%{}, @input)
    # IO.inspect(res)
    # IO.inspect(res.maps[{:seed, :soil}][88])
    # assert res.seeds == [79,14,55,13]
    assert Day5.get_mapped_value(res, {:seed, :soil}, 79) == 81
    assert Day5.get_mapped_value(res, {:seed, :soil}, 14) == 14
    assert Day5.get_mapped_value(res, {:seed, :soil}, 55) == 57
    assert Day5.get_mapped_value(res, {:seed, :soil}, 13) == 13
  end

  test "get_lowest_location" do

    res = Almanac.parse(%{}, @input)

    # wl = res.maps[{:fertilizer, :water}]
    # Enum.sort(wl)
    # |> Enum.each(fn x -> IO.inspect(x) end)

    # IO.inspect()
    IO.inspect(res)
    e = Day5.get_lowest_location(res)
    assert e == 35
  end

  test "lowest_locations_by_seed_value_ranges" do

    res = Almanac.parse(%{}, @input)
    e = Day5.lowest_locations_by_seed_value_ranges(res)
    IO.inspect(e)
  end


  test "lowest_locations_by_seed_value_ranges_2" do

    res = Almanac.parse(%{}, """
    seeds: 10 2 30 15\n
    \n
    seed-to-soil map:\n
    1000 1 4\n
    \n
    soil-to-fertilizer map:\n
    0 15 37\n
    37 52 2\n
    39 0 15\n
    \n
    fertilizer-to-water map:\n
    49 53 8\n
    0 11 42\n
    42 0 7\n
    57 7 4\n
    \n
    water-to-light map:\n
    88 18 7\n
    18 25 70\n
    \n
    light-to-temperature map:\n
    45 77 23\n
    81 45 19\n
    68 64 13\n
    \n
    temperature-to-humidity map:\n
    0 69 1\n
    1 0 69\n
    \n
    humidity-to-location map:\n
    60 56 37\n
    56 93 4\n
    1 980 100\n
    """)
    e = Day5.lowest_locations_by_seed_value_ranges(res)
    IO.inspect(e)
  end



  test "reverse_mapping" do

    res = Almanac.parse(%{}, """
    seeds: 10 2 30 15\n
    \n
    seed-to-soil map:\n
    1000 1 4\n
    \n
    soil-to-fertilizer map:\n
    0 15 37\n
    37 52 2\n
    39 0 15\n
    \n
    fertilizer-to-water map:\n
    49 53 8\n
    0 11 42\n
    42 0 7\n
    57 7 4\n
    \n
    water-to-light map:\n
    88 18 7\n
    18 25 70\n
    \n
    light-to-temperature map:\n
    45 77 23\n
    81 45 19\n
    68 64 13\n
    \n
    temperature-to-humidity map:\n
    0 69 1\n
    1 0 69\n
    \n
    humidity-to-location map:\n
    60 56 37\n
    56 93 4\n
    """)
    # location 0 maps to 30 --- location 10 maps to 40... location 60 maps to humidity 90...
    e = Day5.reverse_mapping(res.maps[{:humidity, :location}])
    IO.inspect(e)

    f = Day5.reverse_mapping(res.maps[{:temperature, :humidity}])
    location_to_temperature = Day5.flatten_mappings(e, f)
    IO.inspect(location_to_temperature)
    g = Day5.reverse_mapping(res.maps[{:light, :temperature}])
    location_to_light = Day5.flatten_mappings(location_to_temperature, g)
    IO.inspect(location_to_light)
    y = Day5.reverse_mapping(res.maps[{:water, :light}])
    location_to_water = Day5.flatten_mappings(location_to_light, y)
    IO.inspect(location_to_water)
  end


  test "lowest_locations_by_seed_value_ranges_3" do

    # IO.puts("For location to humidity, we should get the ranges...")
    # IO.puts(" location 70 -> humidity 0 -> temp -> 0")
    # IO.puts(" location 79 -> humidity 9 -> temp -> 9")
    # IO.puts(" location 80 -> humidity 10 -> temp -> 10")
    # IO.puts(" location 10 -> humidity 80 -> temp -> 90")
    # IO.puts(" location 21 -> humidity 91 -> temp -> 81")
    res = Almanac.parse(%{}, @input)
    # location 0 maps to 30 --- location 10 maps to 40... location 60 maps to humidity 90...
    e = Day5.lowest_locations_by_seed_value_ranges(res)
    IO.inspect(e)
  end


  test "get_source_ranges_for_dest_ranges" do
    # has min of 2, max of 96. We need maps for everything in this range.
    res = Day5.get_source_ranges_for_dest_range(10, 5, [{13,{88, 8}},{15, {10, 3}}, {2, {13, 1}}, {6, {23, 4}}])
    assert res == [{13, {88, 2}}]
  end

  test "get_source_ranges_for_dest_range" do
    # has min of 2, max of 96. We need maps for everything in this range.
    res = Day5.get_source_ranges_for_dest_range(10, 5, [{13,{88, 8}},{15, {10, 3}}, {2, {13, 1}}, {6, {23, 4}}])
    assert res == [{13, {88, 2}}]
  end

  test "hydrated_mapping" do
    io = %{
      [{10, {100, 10}}, {100, {10, 10}}] =>
        [{0, {0, 10}}, {10, {100, 10}}, {20, {20, 80}}, {100, {10, 10}}]
    }

    Enum.each(io, fn {map, exr} ->
      act = Almanac.hydrated_mapping(map, 100)
      IO.inspect(act)
      assert Enum.sort(act) == Enum.sort(exr)
    end)
  end

  test "get_dest_mappings_for_source_range" do
    io = [
      %{:dest_start=>10, :dest_count=>5,  :sr_dest_start=>15, :sr_count=>3,  :sr_source_start=>40, :exp=>nil},
      %{:dest_start=>10, :dest_count=>5,  :sr_dest_start=>25, :sr_count=>3,  :sr_source_start=>40, :exp=>nil},
      %{:dest_start=>10, :dest_count=>5,  :sr_dest_start=>3,  :sr_count=>3,  :sr_source_start=>40, :exp=>nil},
      %{:dest_start=>10, :dest_count=>5,  :sr_dest_start=>7,  :sr_count=>3,  :sr_source_start=>40, :exp=>nil}, # 7, 8, 9
      %{:dest_start=>15, :dest_count=>5,  :sr_dest_start=>12, :sr_count=>4,  :sr_source_start=>28, :exp=>{15, {31, 1}}},
      %{:dest_start=>15, :dest_count=>25, :sr_dest_start=>12, :sr_count=>4,  :sr_source_start=>28, :exp=>{15, {31, 1}}},
      %{:dest_start=>10, :dest_count=>5,  :sr_dest_start=>10, :sr_count=>3,  :sr_source_start=>40, :exp=>{10, {40, 3}}},
      %{:dest_start=>10, :dest_count=>5,  :sr_dest_start=>14, :sr_count=>3,  :sr_source_start=>40, :exp=>{14, {40, 1}}},
      %{:dest_start=>10, :dest_count=>5,  :sr_dest_start=>8,  :sr_count=>20, :sr_source_start=>40, :exp=>{10, {42, 5}}},
      %{:dest_start=>10, :dest_count=>25, :sr_dest_start=>8,  :sr_count=>20, :sr_source_start=>40, :exp=>{10, {42, 18}}},
      %{:dest_start=>10, :dest_count=>25, :sr_dest_start=>10, :sr_count=>20, :sr_source_start=>40, :exp=>{10, {40, 20}}},
      %{:dest_start=>10, :dest_count=>20, :sr_dest_start=>10, :sr_count=>20, :sr_source_start=>40, :exp=>{10, {40, 20}}},
      %{:dest_start=>10, :dest_count=>20, :sr_dest_start=>10, :sr_count=>25, :sr_source_start=>40, :exp=>{10, {40, 20}}},
      %{:dest_start=>10, :dest_count=>5,  :sr_dest_start=>8,  :sr_count=>3,  :sr_source_start=>19, :exp=>{10, {21, 1}}},
      %{:dest_start=>10, :dest_count=>15, :sr_dest_start=>12, :sr_count=>5,  :sr_source_start=>24, :exp=>{12, {24, 5}}},
      %{:dest_start=>10, :dest_count=>15, :sr_dest_start=>22, :sr_count=>5,  :sr_source_start=>24, :exp=>{22, {24, 3}}},
      %{:dest_start=>10, :dest_count=>15, :sr_dest_start=>22, :sr_count=>5,  :sr_source_start=>24, :exp=>{22, {24, 3}}},
    ]
    Enum.each(io, fn x ->

      source_range = {x[:sr_dest_start], {x[:sr_source_start], x[:sr_count]}}
      res = Day5.get_dest_mappings_for_source_range(x[:dest_start], x[:dest_count], source_range)
      IO.inspect(x)
      assert res == x[:exp]
    end)
  end
end
