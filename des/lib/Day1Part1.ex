defmodule Day1Part1 do
  @moduledoc """
  Documentation for `AdventOfCode`.

  ```
  ❯ pwd
  /Users/des/src/awoo-house/AdventOfCode2023/des
  ❯ mix run -e Day1Part1.run
  ```
  """

  @doc """
  Hello world.

  ## Examples

      iex> AdventOfCode.hello()
      :world

  """
  def run do
    IO.stream(File.open!("input/day-1.txt"), :line)
    |> Stream.map(fn line -> String.codepoints(line) end)
    |> Stream.map(fn line -> Enum.filter(line, fn c -> is_digit(c) end) end)
    |> Stream.map(fn digits -> {List.first(digits), List.last(digits)} end)
    |> Stream.map(fn {first, last} -> Integer.parse(first <> last) end)
    # |> Stream.each(fn line -> IO.puts(inspect(line)) end)
    |> Enum.reduce(0, fn {num, ""}, acc -> acc + num end)
    |> IO.puts
  end

  def is_digit(c) do
    c >= "0" && c <= "9"
  end
end
