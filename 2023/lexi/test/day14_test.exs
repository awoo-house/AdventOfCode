defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "parse" do
    ml_in = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """
    Day14.parse(ml_in)
    |> Day14.calc_total_force_after_north_tilt
    |> IO.inspect
  end


  def sigil_v(inp, _) do
    Enum.map(String.graphemes(inp), fn x ->
      case x do
        "O" -> :rock
        "." -> :space
        "#" -> :cube
      end
    end)
  end

  test "calc_row_move" do
    # IO.inspect(e)
    cache = Map.new()
    {_, cache} = Day14.thrash_row(cache, ~v".#O.#O....")
    {_, cache} = Day14.thrash_row(cache, ~v".#O.#O....")
    {_, cache} = Day14.thrash_row(cache, ~v".#O.#O....")
    {_, _cache} = Day14.thrash_row(cache, ~v".#O.#O....")


  end

  test "cycle_north" do

    cache = Map.new()
    ml_in = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """
    {nm, _} = Day14.parse(ml_in)
    |> Day14.cycle_north(cache)

    Day14.print(nm)
  end

  test "cycle_east" do

    cache = Map.new()
    ml_in = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """
    {nm, _} = Day14.parse(ml_in)
    |> Day14.cycle_east(cache)

    Day14.print(nm)
  end

  test "cycle_west" do

    cache = Map.new()
    ml_in = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """
    {nm, _} = Day14.parse(ml_in)
    |> Day14.cycle_west(cache)

    Day14.print(nm)
  end

  test "cycle_south" do

    cache = Map.new()
    ml_in = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """
    {nm, _} = Day14.parse(ml_in)
    |> Day14.cycle_south(cache)

    Day14.print(nm)
  end


  test "cycle" do

    cache = Map.new()
    ml_in = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """


    a = Day14.parse(ml_in)
    x = Day14.run_cycles(a, 1000000000)
    Day14.print(x)
    Day14.calc_force(x, a[:max_y])
    |> IO.inspect
  end


end
