defmodule Advent5Test do
  use ExUnit.Case
  doctest Advent5

  alias Advent5.MapEntry, as: M

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

  ##### LETS DO IT SMARTER #####################################################

  test "Case II" do
    a = %M{ source_start: 0, dest_start: 100, length: 7 }
                   b = %M{ source_start: 104, dest_start: 200, length: 5 }

    x =  %M{ source_start: 0, dest_start: 100, length: 4 } # 3 to go
    y =  %M{ source_start: 4, dest_start: 200, length: 3 } # 0 to go
    z =  %M{ source_start: 107, dest_start: 203, length: 2 } # Acc, tacked on at the very end

    out = Advent5.mk_entry_overlaps(a, [b])
    IO.inspect(out)

    [t, u, v] = out

    assert t == x
    assert u == y
    assert v == z
  end

  test "Case IV" do
    a = %M{ source_start: 95, dest_start: 100, length: 7 }
    b = %M{ source_start: 90, dest_start: 200, length: 5 }

    x =  %M{ source_start: 90, dest_start: 200, length: 5 } # 3 to go
    y =  %M{ source_start: 95, dest_start: 205, length: 2 } # 0 to go

    out = Advent5.mk_entry_overlaps(a, [b])
    IO.inspect(out)

    # [t, u, v] = out

    # assert t == x
    # assert u == y
    # assert v == z
  end

  test "entry_mult A" do
    almanac = Advent5.read_almanac("lib/Puzz5.example.input.txt")
    seed_entry   = Enum.at(almanac.maps.seed.entries, 1)
    soil_entries = Advent5.sorted_entries(almanac, :soil)

    IO.inspect(seed_entry)
    IO.inspect(soil_entries)

    out = Advent5.mk_entry_overlaps(seed_entry, soil_entries)

    IO.puts("")
    IO.inspect(out)
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
