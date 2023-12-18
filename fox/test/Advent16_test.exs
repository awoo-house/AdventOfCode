defmodule Advent16Test do
  use ExUnit.Case
  doctest Advent16

  alias Advent16.Beam
  alias Advent16.Coord

  @north Coord.new(0, 1)
  @south Coord.new(0, -1)
  @east  Coord.new(1, 0)
  @west  Coord.new(-1, 0)

  def mk_beams(start) do
    [@north, @south, @east, @west]
    |> Enum.map(&(Beam.new(start, &1)))
  end

  def step_beams(beams, chr) do
    beams
    |> Enum.map(&(Beam.step(&1, chr)))
  end

  test "Beam empty" do
    beams = mk_beams(Coord.new(0, 0))
    [n, s, e, w] = step_beams(beams, ?.)

    assert n.position == Coord.new(0, 1)
    assert s.position == Coord.new(0, -1)
    assert e.position == Coord.new(1, 0)
    assert w.position == Coord.new(-1, 0)
  end

  test "Beam mirror /" do
    beams = mk_beams(Coord.new(0, 0))
    [n, s, e, w] = step_beams(beams, ?/)

    assert n.position == @east
    assert s.position == @west
    assert e.position == @north
    assert w.position == @south
  end

  test "Beam mirror \\" do
    beams = mk_beams(Coord.new(0, 0))
    [n, s, e, w] = step_beams(beams, ?\\)

    assert n.position == @west
    assert s.position == @east
    assert e.position == @south
    assert w.position == @north
  end

  test "Beam splitter |" do
    beams = mk_beams(Coord.new(0, 0))
    [n, s, {e1, e2}, {w1, w2}] = step_beams(beams, ?|)

    IO.inspect(n)
    IO.inspect(s)


    assert n.position == @north
    assert s.position == @south

    assert e1.position == @north
    assert e2.position == @south

    assert w1.position == @south
    assert w2.position == @north
  end

  test "Beam splitter -" do
    beams = mk_beams(Coord.new(0, 0))
    [{n1, n2}, {s1, s2}, e, w] = IO.inspect(step_beams(beams, ?-))

    assert n1.position == @east
    assert n2.position == @west

    assert s1.position == @west
    assert s2.position == @east

    assert e.position == @east
    assert w.position == @west
  end
end
