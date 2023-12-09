defmodule Advent5Test do
  use ExUnit.Case
  doctest Advent5

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

  test "get_output_id" do
    entry = %{ source_start: 98, dest_start: 50, length: 2 }
    assert Advent5.get_output_id(entry, 20) == 20
    assert Advent5.get_output_id(entry, 97) == 97

    assert Advent5.get_output_id(entry, 98) == 50
    assert Advent5.get_output_id(entry, 99) == 51

    assert Advent5.get_output_id(entry, 100) == 100
  end
end
