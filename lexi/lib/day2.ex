defmodule Day2 do
  @moduledoc """
  Documentation for `Lexi Day2`.
  """
  def handIsPossible(hand) do
    regexToSymbol = %{
      :green => ~r/(\d+) green/,
      :red => ~r/(\d+) red/,
      :blue => ~r/(\d+) blue/
    }
    maxSymbols = %{
      :green => 13,
      :red => 12,
      :blue => 14
    }

    Enum.all?(regexToSymbol, fn {sym, r} ->
      case Regex.run(r, hand, capture: :all_but_first) do
        nil -> true
        [a] ->
          { num, _ } = Integer.parse(a)
          num <= maxSymbols[sym]
      end
    end)
  end

  # Returns map of game id and if the hand is possible or not
  def processLine(line) do
    IO.puts(line)
    gameIdStr = Regex.run(~r/Game (\d+):/, line, capture: :all_but_first)
    |> List.flatten
    |> List.first

    {gameId, _} = Integer.parse(gameIdStr)

    String.replace(line, "Game #{gameIdStr}: ", "")
    |> String.split(";")
    |> Enum.all?(&(handIsPossible/1))
    |> then(fn isPossible -> {gameId, isPossible} end)

  end

  def run do
    case File.read("./lib/inputs/day2.txt") do
      {:ok, input} -> String.split(input, "\n")
        |> Enum.map(fn x -> processLine(x) end)
        |> Enum.filter(fn {_gameId, isPossible} -> isPossible end)
        |> Enum.reduce(0, fn {gameId, _}, acc -> gameId + acc end)
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end
end
