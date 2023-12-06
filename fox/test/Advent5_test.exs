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
end
