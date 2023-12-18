defmodule Advent15Test do
  use ExUnit.Case
  doctest Advent15

  import Advent15
  alias Advent15.Lens

  test "hash it" do
    assert hash(~c"rn=1") == 30
    assert hash(~c"cm-")  == 253
    assert hash(~c"qp=3") == 97
    assert hash(~c"cm=2") == 47
    assert hash(~c"qp-")  == 14
    assert hash(~c"pc=4") == 180
    assert hash(~c"ot=9") == 9
    assert hash(~c"ab=5") == 197
    assert hash(~c"pc-")  == 48
    assert hash(~c"pc=6") == 214
    assert hash(~c"ot=7") == 231
  end

  test "hash all" do
    assert hash_all("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7") == 1320
  end

  test "hash map" do
    m = %{}
    m = do_hm_step(m, {:add, Lens.new(~c"rn", 1)})
    m = do_hm_step(m, {:remove, ~c"cm"})
    m = do_hm_step(m, {:add, Lens.new(~c"qp", 3)})
    m = do_hm_step(m, {:add, Lens.new(~c"cm", 2)})
    m = do_hm_step(m, {:remove, ~c"qp"})

    IO.inspect(m)
  end

end
