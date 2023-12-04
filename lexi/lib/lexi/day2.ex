defmodule LexiDay2 do
  @moduledoc """
  Documentation for `Lexi Day2`.
  """

  # Returns map of game id and if the hand is possible or not
  def processLine(line) do
    String
  end

  def handIsPossible(hand) do
    regexToSymbol = %{
      :green => ~r/(\d) green/,
      :red => ~r/(\d) red/,
      :blue => ~r/(\d) blue/
    }
    maxSymbols = %{
      :green => 13,
      :red => 12,
      :blue => 14
    }
    Enum.all?(regexToSymbol, fn {sym, r} ->
      pulledCubes = Regex.run(r, hand)
      |> List.first
      pulledCubes <= maxSymbols[sym]
    end)
  end

  def run do
    case File.read("./lib/lexi/inputs/day2.txt") do
      {:ok, input} -> String.split(input)
        |> Enum.map(fn x -> processLine(x) end)
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end
end
