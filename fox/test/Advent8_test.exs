defmodule Advent8Test do
  use ExUnit.Case
  doctest Advent8


  test "parse_graph_line" do
    out = Advent8.parse_graph_line(%{}, "AAA = (BBB, CCC)")
    assert out == %{ "AAA" => { "BBB", "CCC" }}
  end

  test "parse_direction_line" do
    out = Advent8.parse_direction_line("LLR")
    assert out == [ :l, :l, :r ]
  end

  test "parse_input" do
    out = Advent8.parse_input("""
      LLR

      AAA = (BBB, BBB)
      BBB = (AAA, ZZZ)
      ZZZ = (ZZZ, ZZZ)
    """)

    assert out.steps == [ :l, :l, :r ]
    assert out.nodes == %{
      "AAA" => { "BBB", "BBB" },
      "BBB" => { "AAA", "ZZZ" },
      "ZZZ" => { "ZZZ", "ZZZ" }
    }
  end

  test "Part 1 Example" do
    inp = Advent8.parse_input("""
      LLR

      AAA = (BBB, BBB)
      BBB = (AAA, ZZZ)
      ZZZ = (ZZZ, ZZZ)
    """)

    assert Advent8.count_steps(inp) == 6
  end

  test "Find all starts" do
    inp = Advent8.parse_input("""
      LR

      11A = (11B, XXX)
      11B = (XXX, 11Z)
      11Z = (11B, XXX)
      22A = (22B, XXX)
      22B = (22C, 22C)
      22C = (22Z, 22Z)
      22Z = (22B, 22B)
      XXX = (XXX, XXX)
    """)

    assert Advent8.find_all_starts(inp) == ["11A", "22A"]
  end

  test "Count from all starts" do
    inp = Advent8.parse_input("""
      LR

      11A = (11B, XXX)
      11B = (XXX, 11Z)
      11Z = (11B, XXX)
      22A = (22B, XXX)
      22B = (22C, 22C)
      22C = (22Z, 22Z)
      22Z = (22B, 22B)
      XXX = (XXX, XXX)
    """)

    out = Advent8.count_steps(inp)
    IO.inspect(out)
    assert out == 6
  end

end
