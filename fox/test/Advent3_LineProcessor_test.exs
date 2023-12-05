defmodule LineProcessorTest do
  alias Advent3.CoordinateSymbol
  alias Advent3.LineProcessor

  use ExUnit.Case
  doctest Advent3.LineProcessor


  test "Parse Line 1" do
    out = LineProcessor.processLine("123")
    assert out == [%CoordinateSymbol{column: 0, num: 123}]
  end

  test "Parse Line 2" do
    out = LineProcessor.processLine("467..114..")
    assert out == [
      %CoordinateSymbol{column: 0, num: 467},
      %CoordinateSymbol{column: 5, num: 114}
    ]
  end

  test "Parse Line 3" do
    out = LineProcessor.processLine("...*......")
    assert out == [
      %CoordinateSymbol{column: 3, sym: ?*},
    ]
  end

  test "Parse Line 4" do
    out = LineProcessor.processLine("617%......")
    assert out == [
      %CoordinateSymbol{column: 0, num: 617},
      %CoordinateSymbol{column: 3, sym: ?%},
    ]
  end

  test "IntoToks" do
    inp = LineProcessor.intoToks("123")
    assert inp == [{?1, 0}, {?2, 1}, {?3, 2}]
  end

  test "Parse Number 3" do
    inp = LineProcessor.intoToks("123..")
    out = LineProcessor.parseNumber(inp)

    assert out == { %CoordinateSymbol{column: 0, num: 123}, [{?., 3}, {?., 4}] }
  end

  test "Parse Number 2" do
    inp = LineProcessor.intoToks("12...")
    out = LineProcessor.parseNumber(inp)

    assert out == { %CoordinateSymbol{column: 0, num: 12}, [{?., 2}, {?., 3}, {?., 4}] }
  end

  test "Parse Number 1" do
    inp = LineProcessor.intoToks("1....")
    out = LineProcessor.parseNumber(inp)

    assert out == { %CoordinateSymbol{column: 0, num: 1}, [{?., 1}, {?., 2}, {?., 3}, {?., 4}] }
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
