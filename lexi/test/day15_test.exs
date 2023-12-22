defmodule Day15Test do
  use ExUnit.Case
  doctest Day15




  @tag timeout: 100
  test "parse" do
    ml_in = """
    rn=1,cm-,qp=3,
    cm=2,qp-,pc=4,ot=19,ab=5,pc-,pc=6,ot=7
    """

    Day15.tokenize(ml_in)
    |> Day15.parse
    |> IO.inspect
  end


  @tag timeout: 100
  test "tokenize" do
    ml_in = """
    urpn=1,cm-,qp=3,
    cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """
    Day15.tokenize(ml_in)
    |> IO.inspect
  end

  @tag timeout: 100
  test "run_instructions" do

    ml_in = """
    rn=1,cm-,qp=3,
    cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """

    Day15.tokenize(ml_in)
    |> Day15.parse
    |> IO.inspect
    |> Day15.run_instructions
    |> IO.inspect

  end

  @tag timeout: 100
  test "sum_state" do

    ml_in = """
    rn=1,cm-,qp=3,
    cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """

    Day15.tokenize(ml_in)
    |> Day15.parse
    |> Day15.run_instructions
    |> Day15.sum_state
    |> IO.inspect

  end

  test "hash" do
    Day15.hash("pc")
    |> IO.inspect
  end

  test "sum_instructions" do

    ml_in = """
    rn=1,cm-,qp=3,
    cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """
    Day15.parse(ml_in)
    |> Day15.sum_instructions
    |> IO.inspect
  end



end
