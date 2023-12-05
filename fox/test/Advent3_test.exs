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
      { [%C{ column: 0, num: 467 }, %C{ column: 5, num: 114 }] , 0 },
      { [%C{ column: 3, sym: ?* }]                             , 1 },
      { [%C{ column: 2, num: 35 },  %C{ column: 6, num: 633}]  , 2 },
      { [%C{ column: 6, sym: ?# }]                             , 3 },
      { [%C{ column: 0, num: 617 }, %C{ column: 3, sym: ?* }]  , 4 },
      { [%C{ column: 5, sym: ?+ },  %C{ column: 7, num: 58 }]  , 5 },
      { [%C{ column: 2, num: 592 }]                            , 6 },
      { [%C{ column: 6, num: 755 }]                            , 7 },
      { [%C{ column: 3, sym: ?$ },  %C{ column: 5, sym: ?* }]  , 8 },
      { [%C{ column: 1, num: 664 }, %C{ column: 5, num: 598}]  , 9 },
    ]
  end

  test "Get Coords 1" do
    assert Advent3.getEntryAt(schematic(), 0, 0) == %C{ column: 0, num: 467 }
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

end
