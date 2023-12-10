defmodule Advent7Test do
  use ExUnit.Case
  doctest Advent7

  alias Advent7.Card
  alias Advent7.Hand

  test "Hands" do
    assert Hand.new("AAAAA").kind == :five_of_a_kind
    assert Hand.new("AA8AA").kind == :four_of_a_kind
    assert Hand.new("23332").kind == :full_house
    assert Hand.new("TTT98").kind == :three_of_a_kind
    assert Hand.new("23432").kind == :two_pair
    assert Hand.new("A23A4").kind == :one_pair
    assert Hand.new("23456").kind == :high_card
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
