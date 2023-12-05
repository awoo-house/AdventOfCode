defmodule Day1Part2 do
  @moduledoc """
  Documentation for `AdventOfCode`.

  ```
  ❯ pwd
  /Users/des/src/awoo-house/AdventOfCode2023/des
  ❯ mix run -e Day1Part2.run
  ```
  """

  def run do
    find_first = make_finder(digit_map())
    find_last = make_finder(digit_map_rev())

    IO.stream(File.open!("input/day-1.txt"), :line)
    |> Stream.map(fn line -> {find_first.(line), find_last.(String.reverse(line))} end)
    # |> Stream.each(&dbg/1)
    |> Stream.map(fn {first, last} -> Integer.parse(first <> last) end)
    |> Enum.reduce(0, fn {num, ""}, acc -> acc + num end)
    |> IO.puts
  end

  def make_finder(map) do
    re = Regex.compile!("[0-9]|#{Map.keys(map) |> Enum.join("|")}")
    fn str ->
      digit = hd(Regex.run(re, str))
      Map.get(map, digit, digit)
    end
  end

  def digit_map, do: %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9",
  }
  def digit_map_rev do
   Enum.map(digit_map(), fn {k, v} -> {String.reverse(k), v} end)
   |> Map.new()
  end
end
