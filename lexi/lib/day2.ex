defmodule Day2 do
  @moduledoc """
  Documentation for `Day2`.
  """

@regexToSymbol %{
    :green => ~r/(\d+) green/,
    :red => ~r/(\d+) red/,
    :blue => ~r/(\d+) blue/
  }

  def handIsPossible(hand) do
    maxSymbols = %{
      :green => 13,
      :red => 12,
      :blue => 14
    }

    Enum.all?(@regexToSymbol, fn {sym, r} ->
      case Regex.run(r, hand, capture: :all_but_first) do
        nil -> true
        [a] ->
          { num, _ } = Integer.parse(a)
          num <= maxSymbols[sym]
      end
    end)
  end

  def minimumRequired(hand) do
    Enum.reduce(@regexToSymbol, %{}, fn {sym, r}, acc ->
      max = case Regex.run(r, hand, capture: :all_but_first) do
        nil -> 1
        [a] ->
          { num, _ } = Integer.parse(a)
          num
      end
      Map.put(acc, sym, max)
    end)
  end


  def getGameId(line) do
    gameIdStr = Regex.run(~r/Game (\d+):/, line, capture: :all_but_first)
    |> List.flatten
    |> List.first
    {gameId, _} = Integer.parse(gameIdStr)
    {gameIdStr, gameId}
  end

  def getHands(line, gameIdStr) do
    String.replace(line, "Game #{gameIdStr}: ", "")
    |> String.split(";")
  end

  def processLineP1(line) do
    {gameIdStr, gameId} = getGameId(line)
    getHands(line, gameIdStr)
    |> Enum.all?(fn x -> handIsPossible(x) end)
    |> then(fn isPossible -> {gameId, isPossible} end)

  end

  def processLineP2(line) do
    {gameIdStr, _gameId} = getGameId(line)
    getHands(line, gameIdStr)
    |> Enum.map(fn x -> minimumRequired(x) end)
    |> Enum.reduce(%{}, fn handMap, acc ->
      Map.merge(acc, handMap, fn _key, maxSoFar, thisMapVal ->
        max(maxSoFar, thisMapVal)
      end)
    end)
    |> Enum.reduce(1, fn {_sym, req}, acc -> acc * req end)
  end

  def runP1 do
    case File.read("./lib/inputs/day2.txt") do
      {:ok, input} -> String.split(input, "\n")
        |> Enum.map(fn x -> processLineP1(x) end)
        |> Enum.filter(fn {_gameId, isPossible} -> isPossible end)
        |> Enum.reduce(0, fn {gameId, _}, acc -> gameId + acc end)
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end


  def runP2 do
    case File.read("./lib/inputs/day2.txt") do
      {:ok, input} -> String.split(input, "\n")
        |> Enum.map(fn x -> processLineP2(x) end)
        |> Enum.reduce(0, fn power, acc -> power + acc end)
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end
end
