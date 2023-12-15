defmodule Advent10Test do
  use ExUnit.Case
  doctest Advent10


  test "Part 2 what on earth" do
    inp = """
    ...........
    .S-------7.
    .|F---7..|.
    .||...L-7|.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    """

    out = Advent10.parse(inp)
    out = Advent10.in_points(out)

    # Advent10.print_map(out, fn (_, _) -> "X" end)
    Advent10.print_map(out)

    # assert Advent10.scan_line(out, 0) == []
    # assert Advent10.scan_line(out, 3) == []
    # assert Advent10.scan_line(out, 6) == [{8,6}, {7,6}, {3,6}, {2,6}]
    # assert Advent10.scan_line(out, 7) == []

    # assert Advent10.in_points(out) == [{8,6}, {7,6}, {3,6}, {2,6}]
  end





  test "dir" do
    assert Advent10.Node.dir({1, 1}, {2, 1}) == :right
    assert Advent10.Node.dir({3, 1}, {2, 1}) == :left
    assert Advent10.Node.dir({1, 1}, {1, 2}) == :down
    assert Advent10.Node.dir({3, 3}, {3, 2}) == :up

    assert Advent10.Node.dir({2, 1}, {1, 1}) == :left
    assert Advent10.Node.dir({2, 1}, {3, 1}) == :right
  end

  #   01234
  # 0 ..F7.
  # 1 .FJ|.
  # 2 SJ.L7
  # 3 |F--J
  # 4 LJ...

  test "example A" do
    inp = """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """

    assert Advent10.find_max(inp) == 4
  end

  test "Example B.1" do
    inp = """
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """

    assert Advent10.find_max(inp) == 8
  end

  test "Example B.2" do
    inp = """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """

    inp = Advent10.parse(inp)
    Advent10.print_map(inp)

    IO.puts("===== OUT ==========")

    out = Advent10.bfs(inp)
    Advent10.print_map(out, fn (_, v) -> inspect(v) end)

    # assert Advent10.find_max(inp) == 8
  end

  test "parse test" do
    inp = Advent10.parse("""
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """)

    expected = %{
      :start => {1, 1},
      {1, 1} => { {1,2}, {2,1} },
      {1, 2} => { {1,1}, {1,3} },
      {1, 3} => { {1,2}, {2,3} },

      {2, 1} => { {1,1}, {3,1} },
      {2, 3} => { {1,3}, {3,3} },

      {3, 1} => { {2,1}, {3,2} },
      {3, 2} => { {3,1}, {3,3} },
      {3, 3} => { {2,3}, {3,2} },
    }

    assert inp == expected
  end

  #   01234
  # 0 .....
  # 1 .S-7.
  # 2 .|.|.
  # 3 .L-J.
  # 4 .....

  # @tag timeout: 1000
  # test "graph test" do
  #   grph = %{
  #     {1, 1} => { {2,1}, {1,2} },
  #     {2, 1} => { {1,1}, {3,1} },
  #     {1, 2} => { {1,1}, {1,3} },
  #     {3, 1} => { {2,1}, {3,2} },
  #     {1, 3} => { {1,2}, {2,3} },
  #     {2, 3} => { {1,3}, {3,3} },
  #     {3, 2} => { {3,1}, {3,3} },
  #     {3, 3} => { {3,2}, {2,3} },
  #   }

  #   Advent10.print_map(grph, &Advent10.Node.pretty/2)

  #   out = Advent10.bfs(grph, {1, 1})

  #   IO.puts("===== OUT ==========")

  #   Advent10.print_map(out, fn (_, v) -> inspect(v) end)

  # end
end
