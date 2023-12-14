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

    out = Advent8.count_it(inp)
    IO.inspect(out)
    assert out == 6
  end

  @tag timeout: 1000
  test "Forever Stream" do
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

    out = Advent8.forever_stream(inp, "11A")
          |> Stream.take(10)
          |> Enum.to_list

    IO.inspect(out)
  end

  test "Pair Concat" do
    assert Advent8.pair_concat({ 5, 0 }, { 3, 0 }) == { 15, 5*0 }
    assert Advent8.pair_concat({ 5, 0 }, { 3, 1 }) == { 15, 5*2 }
    assert Advent8.pair_concat({ 5, 0 }, { 3, 2 }) == { 15, 5*1 }

    assert Advent8.pair_concat({ 7, 0 }, { 4, 0 }) == { 28, 7*0 }
    assert Advent8.pair_concat({ 7, 0 }, { 4, 1 }) == { 28, 7*3 }
    assert Advent8.pair_concat({ 7, 0 }, { 4, 2 }) == { 28, 7*2 }
    assert Advent8.pair_concat({ 7, 0 }, { 4, 3 }) == { 28, 7*1 }

    assert Advent8.pair_concat({ 7, 0 }, { 3, 0 }) == { 21, 7*0 }
    assert Advent8.pair_concat({ 7, 0 }, { 3, 1 }) == { 21, 7*1 }
    assert Advent8.pair_concat({ 7, 0 }, { 3, 2 }) == { 21, 7*2 }
  end

  @tag timeout: 1000
  test "Find Loop for Start" do
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

    {a, b} = Advent8.path_to_pair(Advent8.get_path(inp, inp.steps, "11A"))
    {c, d} = Advent8.path_to_pair(Advent8.get_path(inp, inp.steps, "22A"))

    {x, y} = Advent8.pair_concat({a, b}, {c, d})

    IO.puts("Test Outputs:")
    IO.inspect("<#{a}, #{b}> + <#{c}, #{d}> = <#{x}, #{y}>")
  end

end
