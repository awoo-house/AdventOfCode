defmodule Advent4Test do
  use ExUnit.Case
  doctest Advent4

  test "number list parser should work" do
    out = Advent4.parseNumbers("41 48 83 86 17  1")
    assert out == [41, 48, 83, 86, 17, 1]
  end

  test "parse line" do
    out = Advent4.parseLine("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
    assert out == [ card_num: 1, winners: [17, 41, 48, 83, 86], mine: [6, 9, 17, 31, 48, 53, 83, 86] ]
  end

  test "Card Score 1" do
    parse = Advent4.parseLine("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
    assert Advent4.cardScore(parse) == 8
  end

  test "Card Score 2" do
    parse = Advent4.parseLine("Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19")
    assert Advent4.cardScore(parse) == 2
  end

  test "Card Score 3" do
    parse = Advent4.parseLine("Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1")
    assert Advent4.cardScore(parse) == 2
  end

  test "Card Score 4" do
    parse = Advent4.parseLine("Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83")
    assert Advent4.cardScore(parse) == 1
  end

  test "Card Score 5" do
    parse = Advent4.parseLine("Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36")
    assert Advent4.cardScore(parse) == 0
  end

  test "Card Score 6" do
    parse = Advent4.parseLine("Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11")
    assert Advent4.cardScore(parse) == 0
  end

  test "incCardMap" do
    counts = %{ 1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 6 => 1 }
    out = Advent4.incCardCount(counts, 2, 4)
    assert out == %{ 1 => 1, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 1 }
  end

  test "runCards" do
    cards = String.split("""
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """, "\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(&Advent4.parseLine/1)

    card_counts = Advent4.runCards(cards)

    card_total = card_counts
      |> Map.values
      |> Enum.reduce(&(&1 + &2))

    assert card_total == 30
  end
end
