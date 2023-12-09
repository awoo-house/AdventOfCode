defmodule Advent5Test do
  use ExUnit.Case
  doctest Advent5

  ##### FULL TREE TESTS ########################################################

  @tag timeout: 1000
  test "location" do
    almanac = Advent5.read_almanac("lib/Puzz5.example.input.txt")
    assert Advent5.get_locs_for_seed(almanac.maps, 123, :location) == 123
  end

  @tag timeout: 1000
  test "humidity-to-location" do
    almanac = Advent5.read_almanac("lib/Puzz5.example.input.txt")
    assert Advent5.get_locs_for_seed(almanac.maps, 90, :humidity) == 94
  end

  @tag timeout: 1000
  test "temperature-to-location" do
    almanac = Advent5.read_almanac("lib/Puzz5.example.input.txt")
    assert Advent5.get_locs_for_seed(almanac.maps, 69, :temperature) == 0
    assert Advent5.get_locs_for_seed(almanac.maps, 56, :temperature) == 61
  end

  @tag timeout: 1000
  test "light-to-location" do
    almanac = Advent5.read_almanac("lib/Puzz5.example.input.txt")
    assert Advent5.get_locs_for_seed(almanac.maps, 74, :light) == 82
    assert Advent5.get_locs_for_seed(almanac.maps, 42, :light) == 43
  end

  @tag timeout: 1000
  test "the full deal" do
    almanac = Advent5.read_almanac("lib/Puzz5.example.input.txt")
    assert Advent5.get_locs_for_seed(almanac.maps, 14) == 43
    assert Advent5.get_locs_for_seed(almanac.maps, 79) == 82
    assert Advent5.get_locs_for_seed(almanac.maps, 55) == 86
    assert Advent5.get_locs_for_seed(almanac.maps, 13) == 35
  end

  @tag timeout: 1000
  test "lowest_num" do
    almanac = Advent5.read_almanac("lib/Puzz5.example.input.txt")
    assert Advent5.get_lowest_loc_num(almanac.maps) == 35
  end

  ##### COMPONENT TESTS ########################################################

  test "get_output_id" do
    almanac = Advent5.read_almanac("lib/Puzz5.example.input.txt")
    entries = almanac.maps.seed.entries

    assert Advent5.get_output_id(entries, 10) == 10

    assert Advent5.get_output_id(entries, 98) == 50
    assert Advent5.get_output_id(entries, 99) == 51

    assert Advent5.get_output_id(entries, 53) == 55

  end

  test "get_mapped_id" do
    entry = %{ source_start: 98, dest_start: 50, length: 2 }
    assert Advent5.get_mapped_id(entry, 20) == :unmapped
    assert Advent5.get_mapped_id(entry, 97) == :unmapped

    assert Advent5.get_mapped_id(entry, 98) == 50
    assert Advent5.get_mapped_id(entry, 99) == 51

    assert Advent5.get_mapped_id(entry, 100) == :unmapped
  end

  ##### INPUT TESTS ############################################################

  test "tokenize" do
    inp = File.read!("lib/Puzz5.example.input.txt")
    toks = Advent5.Token.tokenize(inp)

    IO.inspect(toks)
  end

  @tag timeout: 1000
  test "parse" do
    inp = File.read!("lib/Puzz5.example.input.txt")
    toks = Advent5.Token.tokenize(inp)
    parse = Advent5.Parse.parseAlmanac(toks)

    IO.inspect(parse)
  end
end
