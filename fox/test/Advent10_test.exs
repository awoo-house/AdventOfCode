defmodule Advent10Test do
  use ExUnit.Case
  doctest Advent10

  def sigil_l(inp, _) do
    # Advent9.process_line(inp)
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

  @tag timeout: 1000
  test "graph test" do
    grph = %{
      {1, 1} => { {2,1}, {1,2} },
      {2, 1} => { {1,1}, {3,1} },
      {1, 2} => { {1,1}, {1,3} },
      {3, 1} => { {2,1}, {3,2} },
      {1, 3} => { {1,2}, {2,3} },
      {2, 3} => { {1,3}, {3,3} },
      {3, 2} => { {3,1}, {3,3} },
      {3, 3} => { {3,2}, {2,3} },
    }

    for y <- 0..4 do
      for x <- 0..4 do
        case Map.get(grph, {x, y}) do
          { l, r } -> IO.write(Advent10.Node.pretty({x,y}, { l, r }))
          nil -> IO.write(".")
        end
      end
      IO.puts("")
    end

    out = Advent10.bfs(grph, {1, 1})

    IO.puts("===== OUT ==========")

    for y <- 0..4 do
      for x <- 0..4 do
        case Map.get(out, {x, y}) do
          { l, r } -> IO.write(Advent10.Node.pretty({x,y}, { l, r }))
          nil -> IO.write(".")
          n -> IO.write(n)
        end
      end
      IO.puts("")
    end

  end
end
