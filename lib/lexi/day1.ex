defmodule LexiDay1 do
  @moduledoc """
  Documentation for `Lexi Day1`.
  """


  def processNumbers([singleNum]) do
    singleNum <> singleNum
  end
  def processNumbers([head|rest]) do
    head <> List.last(rest)
  end

  def processLine(line) do
      Regex.scan(~r/(\d)/, line, capture: :all_but_first)
      |> List.flatten
      |> processNumbers
      |> Integer.parse
      |> elem(0)
  end

  def run do
    case File.read("./lib/lexi/inputs/day1.txt") do
      {:ok, input} -> String.split(input)
        |> Enum.map(fn x -> processLine(x) end)
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end
end
