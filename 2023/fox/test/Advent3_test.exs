defmodule Advent3Test do
  use ExUnit.Case
  doctest Advent3

  alias Advent3.CoordinateSymbol, as: C

  def schematic() do
    Advent3.processLines("""
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
    """)
  end


  test "Processes Lines" do
    assert schematic() == [
      { [%C{ row: 0, column: 0, num: 467 }, %C{ row: 0, column: 5, num: 114 }] , 0 },
      { [%C{ row: 1, column: 3, sym: ?* }]                                     , 1 },
      { [%C{ row: 2, column: 2, num: 35 },  %C{ row: 2, column: 6, num: 633}]  , 2 },
      { [%C{ row: 3, column: 6, sym: ?# }]                                     , 3 },
      { [%C{ row: 4, column: 0, num: 617 }, %C{ row: 4, column: 3, sym: ?* }]  , 4 },
      { [%C{ row: 5, column: 5, sym: ?+ },  %C{ row: 5, column: 7, num: 58 }]  , 5 },
      { [%C{ row: 6, column: 2, num: 592 }]                                    , 6 },
      { [%C{ row: 7, column: 6, num: 755 }]                                    , 7 },
      { [%C{ row: 8, column: 3, sym: ?$ },  %C{ row: 8, column: 5, sym: ?* }]  , 8 },
      { [%C{ row: 9, column: 1, num: 664 }, %C{ row: 9, column: 5, num: 598}]  , 9 },
    ]
  end

  test "Get Coords 1" do
    assert Advent3.getEntryAt(schematic(), 0, 0) == %C{ row: 0, column: 0, num: 467 }
  end

  test "Get Coords OOB" do
    sch = schematic()
    assert Advent3.getEntryAt(sch, -1, 0) == nil
    assert Advent3.getEntryAt(sch, 0, -1) == nil
    assert Advent3.getEntryAt(sch, 11, 0) == nil
    assert Advent3.getEntryAt(sch, 0, 11) == nil
  end

  test "Check Rect 1" do
    sch = schematic()
    assert Advent3.checkRect(sch, 0, 0)
  end

  test "Check Rect 2" do
    sch = schematic()
    assert !Advent3.checkRect(sch, 0, 5)
    assert !Advent3.checkRect(sch, 5, 7)
  end

  test "PartNum Sum" do
    inp = """
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
    """

    assert Advent3.partNumberSum(inp) == 4361
  end

  test "getMaybeGear 1" do
    assert Advent3.getMaybeGear(schematic(), %C{ row: 1, column: 3, sym: ?* }) ==
      [%C{ row: 2, column: 2, num: 35 }, %C{ row: 0, column: 0, num: 467 }]
  end

  test "getMaybeGear 2" do
    assert Advent3.getMaybeGear(schematic(), %C{ row: 4, column: 3, sym: ?* }) ==
      [%C{ row: 4, column: 0, num: 617 }]
  end

  test "getGears" do
    expected = %{
      %C{ row: 1, column: 3, sym: ?* } => { %C{ row: 2, column: 2, num: 35 }, %C{ row: 0, column: 0, num: 467 } },
      %C{ row: 8, column: 5, sym: ?* } => { %C{ row: 9, column: 5, num: 598}, %C{ row: 7, column: 6, num: 755 } }
    }

    assert Advent3.getGears(schematic()) == expected
  end

  test "getGearRatioSum 1" do
    sch = Advent3.processLines("""
      ..4..
      ..*#3
      #/4..
    """)

    # IO.puts(inspect(sch, pretty: true))
    # IO.puts(inspect(Advent3.getMaybeGear(sch, %C{ row: 1, column: 2, sym: ?* }), pretty: true))

    assert Advent3.getGearRatioSum(sch) == 16
  end

  test "getGearRatioSum Example" do
    assert Advent3.getGearRatioSum(schematic()) == 467835
  end
end
