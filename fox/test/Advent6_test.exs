defmodule Advent6Test do
  use ExUnit.Case
  doctest Advent6

  test "proc_it" do
    ans = Advent6.process_inp("""
      Time:      7  15   30
      Distance:  9  40  200
    """)

    assert ans == [{7,9}, {15,40}, {30,200}]
  end

  test "find_it" do
    (lo..hi) = Advent6.find_it(7, 9)

    assert lo == 2
    assert hi == 5
  end

  test "find_all" do
    inp = Advent6.process_inp("""
      Time:      7  15   30
      Distance:  9  40  200
    """)

    ranges = inp |> Enum.map(fn { time, record } -> Advent6.find_it(time, record) end)
    IO.inspect(ranges)

    dists = ranges |> Enum.map(fn (lo..hi) -> (hi-lo+1) end)
    IO.inspect(dists)
  end

  test "Part 1" do
    inp = Advent6.process_inp("""
      Time:        47     70     75     66
      Distance:   282   1079   1147   1062
    """)

    IO.inspect(Advent6.part_one(inp))
  end

  test "Part 2" do
    inp = Advent6.process_inp("""
      Time:        47707566
      Distance:   282107911471062
    """)

    IO.inspect(Advent6.part_one(inp))
  end
end
