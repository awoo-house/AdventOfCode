defmodule Advent7Test do
  use ExUnit.Case
  doctest Advent7

  alias Advent7.Card
  alias Advent7.Hand
  import Advent7.Hand, only: [sigil_h: 2]

  test "Day 2 Example" do
    inp = Advent7.process_inp("""
      KTJJT 220
      32T3K 765
      KK677 28
      QQQJA 483
      T55J5 684
    """)

    assert Advent7.day1(inp) == 5905
  end

  test "Day 1 file input" do
    case File.read("./lib/Puzz7.input.txt") do
      { :error, e } -> IO.puts{"Error reading file: #{e}"}
      { :ok, dat } ->
        sorted = Advent7.process_inp(dat)
        assert length(sorted) == 1000
    end
  end

  test "Day 1 Random Samples" do
    inp = Advent7.process_inp("""
      78487 902
      6J626 941
      6J666 550
      K8A88 142
      89QA6 6
    """)

    IO.inspect(inp)

    out = Advent7.day1(inp)
    IO.inspect(out)
  end


  test "Hand Comparisons" do
    assert Hand.compare(~h"AAAAA", ~h"AA8AA") == :gt
    assert Hand.compare(~h"AA8AA", ~h"AAAAA") == :lt
    assert Hand.compare(~h"AA8AA", ~h"AA8AA") == :eq

    assert Hand.compare(~h"33332", ~h"2AAAA") == :gt
  end

  test "Hands" do
    assert ~h"AAAAA".kind == :five_of_a_kind
    assert ~h"AA8AA".kind == :four_of_a_kind
    assert ~h"23332".kind == :full_house
    assert ~h"TTT98".kind == :three_of_a_kind
    assert ~h"23432".kind == :two_pair
    assert ~h"A23A4".kind == :one_pair
    assert ~h"23456".kind == :high_card
  end

  test "Cards" do
    assert inspect(Card.new(?A)) == "A"
    assert inspect(Card.new(?K)) == "K"
    assert inspect(Card.new(?Q)) == "Q"
    assert inspect(Card.new(?J)) == "J"
    assert inspect(Card.new(?T)) == "T"

    assert inspect(Card.new(?9)) == "9"
    assert inspect(Card.new(?8)) == "8"
    assert inspect(Card.new(?7)) == "7"
    assert inspect(Card.new(?6)) == "6"
    assert inspect(Card.new(?5)) == "5"
    assert inspect(Card.new(?4)) == "4"
    assert inspect(Card.new(?3)) == "3"
    assert inspect(Card.new(?2)) == "2"
  end

end
