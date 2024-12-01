defmodule Advent2Test do
  use ExUnit.Case
  doctest Advent2

  test "example" do
    games = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    Advent2.addPossible(games, red = 12, green = 13, blue = 14) == 8
  end

  test "Find Impossible" do
    conf1 = Advent2.parseGameConfig("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
    assert Advent2.isPossible(conf1, red = 12, green = 13, blue = 14)

    conf3 = Advent2.parseGameConfig("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red")
    assert !Advent2.isPossible(conf3, red = 12, green = 13, blue = 14)
  end

  test "Game Config 1" do
    out = Advent2.parseGameConfig("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")

    assert out[:id] == 1
    assert out[:configs] == [ [blue: 3, red: 4], [red: 1, green: 2, blue: 6], [green: 2] ]
  end

  test "Dice Config" do
    assert Advent2.parseDiceConfig("8 green, 6 blue, 20 red") == [green: 8, blue: 6, red: 20]
    assert Advent2.parseDiceConfig("5 blue, 4 red, 13 green") == [blue: 5, red: 4, green: 13]
    assert Advent2.parseDiceConfig("5 green, 1 red") == [green: 5, red: 1]
  end

end
