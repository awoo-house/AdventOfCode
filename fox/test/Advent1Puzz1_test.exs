defmodule Advent1Puzz1Test do
  use ExUnit.Case
  doctest Advent1Puzz1

  test "parses a line with two internal numbers" do
    assert Advent1Puzz1.processLine("pqr3stu8vwx") == 38
  end

  test "parses a line with two terminal numbers" do
    assert Advent1Puzz1.processLine("1abc2") == 12
  end

  test "parses a line with many numbers" do
    assert Advent1Puzz1.processLine("a1b2c3d4e5f") == 15
  end

  test "parses a line with just one number" do
    assert Advent1Puzz1.processLine("treb7uchet") == 77
  end

  test "tokenizer" do
    assert Advent1Puzz1.tokenize("")      == []
    assert Advent1Puzz1.tokenize("1")     == [1]
    assert Advent1Puzz1.tokenize("eight") == [8]
  end

  test "reads \"word-numbers\" correctly" do
    inp = """
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
    """

    assert Advent1Puzz1.findNumbers(inp) == 281
  end

  test "[Regression] xvtfhkm8c9" do
    assert Advent1Puzz1.findNumbers("xvtfhkm8c9\n") == 89
  end

  test "tmoneightzstdjqjncnkpkknzoneonethreefive7" do
    assert Advent1Puzz1.processLine("tmoneightzstdjqjncnkpkknzoneonethreefive7") == 17
  end

  test "eighthree" do
    assert Advent1Puzz1.processLine("eighthree") == 83
  end
end
