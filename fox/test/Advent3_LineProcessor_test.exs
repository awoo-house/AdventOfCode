defmodule LineProcessorTest do
  alias Advent3.CoordinateSymbol
  alias Advent3.LineProcessor

  use ExUnit.Case
  doctest Advent3.LineProcessor

  test "IntoToks" do
    inp = LineProcessor.intoToks("123")
    assert inp == [{?1, 0}, {?2, 1}, {?3, 2}]
  end

  test "Parse Number 3" do
    inp = LineProcessor.intoToks("123..")
    out = LineProcessor.parseNumber(inp)

    assert out == { %CoordinateSymbol{column: 0, what: 123}, [{?., 3}, {?., 4}] }
  end

  test "Parse Number 2" do
    inp = LineProcessor.intoToks("12...")
    out = LineProcessor.parseNumber(inp)

    assert out == { %CoordinateSymbol{column: 0, what: 12}, [{?., 2}, {?., 3}, {?., 4}] }
  end

  test "Parse Number 1" do
    inp = LineProcessor.intoToks("1....")
    out = LineProcessor.parseNumber(inp)

    assert out == { %CoordinateSymbol{column: 0, what: 1}, [{?., 1}, {?., 2}, {?., 3}, {?., 4}] }
  end

  test "Parse Number FAIL 1" do
    inp = LineProcessor.intoToks(".")
    out = LineProcessor.parseNumber(inp)

    assert out == :error
  end

  test "Parse Number FAIL 2" do
    inp = LineProcessor.intoToks("/")
    out = LineProcessor.parseNumber(inp)

    assert out == :error
  end

end
