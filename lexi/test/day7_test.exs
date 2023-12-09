defmodule Day7Test do
  use ExUnit.Case
  doctest Day7


  test "parse" do
    input = """
    32T3K 765\n
    T55J5 684\n
    KK677 28\n
    KTJJT 220\n
    QQQJA 483\n
    """

    assert Day7.parse(input) == [
      {"32T3K", 765},{"T55J5", 684},{"KK677", 28},{"KTJJT", 220}, {"QQQJA", 483}
    ]
  end

  test "get_sorting_value" do
    # assert Day7.get_sorting_value("32T3K") == (2000000+(3*20000)+(2*4000)+(10*300)+(3*18)+13)
    # assert Day7.get_sorting_value("T55J5") == (4000000+(10*20000)+(5*4000)+(5*300)+(11*18)+5)
    # assert Day7.get_sorting_value("KK677") == (3000000+(13*20000)+(13*4000)+(6*300)+(7*18)+7)
    # assert Day7.get_sorting_value("KTJJT") == (3000000+(13*20000)+(10*4000)+(11*300)+(11*18)+10)
    # assert Day7.get_sorting_value("QQQJA") == (4000000+(12*20000)+(12*4000)+(12*300)+(11*18)+14)


    # assert Day7.get_sorting_value("A2222") == (6000000+(14*20000)+(2*4000)+(2*300)+(2*18)+2)
    # assert Day7.get_sorting_value("KAAAA") == (6000000+(13*20000)+(14*4000)+(14*300)+(14*18)+14)
    # assert Day7.get_sorting_value("2AAAA") == (6000000+(2*20000)+(14*4000)+(14*300)+(14*18)+14)
    # assert Day7.get_sorting_value("77777") == (7000000+(7*20000)+(7*4000)+(7*300)+(7*18)+7)
    # assert Day7.get_sorting_value("AKQJT") == (1000000+(14*20000)+(13*4000)+(12*300)+(11*18)+10)
    # assert Day7.get_sorting_value("J8J8J") == (5000000+(11*20000)+(8*4000)+(11*300)+(8*18)+11)

    assert Day7.get_sorting_value("KTJJT") < Day7.get_sorting_value("KKJJT")
    assert Day7.get_sorting_value("KTJJT") < Day7.get_sorting_value("KK677")
  end

  test "sort_hands" do
    hands = [{"32T3K", 765},{"T55J5", 684},{"KK677", 28},{"KTJJT", 220}, {"QQQJA", 483}]
    s = Day7.sort_hands(hands)
      |> Enum.with_index(1)
      |> Enum.reduce(0, fn x, acc ->
        {{_, {h, bid}}, idx} = x
        acc + (bid * idx)
      end)

    IO.inspect(s)
  end

  test "sort_hands_2" do
    hands = ["32T3K","T55J5","KK677","KTJJT", "QQQJA", "TTTT4", "J4444"]
    |> Enum.map(fn x -> {x, 0} end)
    n = Day7.sort_hands(hands)
    IO.inspect(n)
    assert Enum.map(n, fn {_o, {h, _t}} -> h end) == ["32T3K", "KTJJT", "KK677", "T55J5", "QQQJA", "TTTT4", "J4444"]
  end

end
