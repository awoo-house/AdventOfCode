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
    assert Day7.get_sorting_value("32T3K") == (20000+(3*40)+(2*30)+(10*20)+(3*10)+13)
    assert Day7.get_sorting_value("T55J5") == (40000+(10*40)+(5*30)+(5*20)+(11*10)+5)
    assert Day7.get_sorting_value("KK677") == (30000+(13*40)+(13*30)+(6*20)+(7*10)+7)
    assert Day7.get_sorting_value("KTJJT") == (30000+(13*40)+(10*30)+(11*20)+(11*10)+10)
    assert Day7.get_sorting_value("QQQJA") == (40000+(12*40)+(12*30)+(12*20)+(11*10)+14)


    assert Day7.get_sorting_value("A2222") == (60000+(14*40)+(2*30)+(2*20)+(2*10)+2)
    assert Day7.get_sorting_value("KAAAA") == (60000+(13*40)+(14*30)+(14*20)+(14*10)+14)
    assert Day7.get_sorting_value("2AAAA") == (60000+(2*40)+(14*30)+(14*20)+(14*10)+14)
    assert Day7.get_sorting_value("77777") == (70000+(7*40)+(7*30)+(7*20)+(7*10)+7)
    assert Day7.get_sorting_value("AKQJT") == (10000+(14*40)+(13*30)+(12*20)+(11*10)+10)
    assert Day7.get_sorting_value("J8J8J") == (50000+(11*40)+(8*30)+(11*20)+(8*10)+11)
  end

  test "sort_hands" do
    hands = [{"32T3K", 765},{"T55J5", 684},{"KK677", 28},{"KTJJT", 220}, {"QQQJA", 483}]
    s = Day7.sort_hands(hands)
    IO.inspect(s)
  end

end
