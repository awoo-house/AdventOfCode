defmodule Wat do
  def run do
    x = ["40", "82", "91", "266"]
    x2 = Enum.map(x, &Integer.parse/1)
    IO.inspect(x2)
    x3 = for {n, _} <- x2, do: n
    IO.inspect(x3)
  end
end
