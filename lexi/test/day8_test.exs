defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  @input  """
    RL
    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
  """

  test "parse" do
    {instructions, tree} = Day8.parse(@input)
  end

  @tag timeout: 1000
  test "run_until_zzz" do
    {instructions, tree} = Day8.parse(@input)
    IO.inspect(instructions)
    IO.inspect(tree)
    ans = Day8.run_until_zzz({instructions, tree})
    assert ans == 2
  end


  @tag timeout: 1000
  test "run_until_zzz 2" do
    input = """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """
    {instructions, tree} = Day8.parse(input)
    IO.inspect(instructions)
    IO.inspect(tree)
    ans = Day8.run_until_zzz({instructions, tree})
    assert ans == 6
  end
end
