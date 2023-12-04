defmodule Advent2 do

  # 8 green, 6 blue, 20 red -> [green: 8, blue: 6, red: 20]
  def parseDiceConfig(inp) do
    inp
    |> String.split(", ")
    |> Enum.map(fn s -> String.split(s, " ") end)
    |> Enum.map(fn
      [n, "red"] -> [red: elem(Integer.parse(n), 0)]
      [n, "green"] -> [green: elem(Integer.parse(n), 0)]
      [n, "blue"] -> [blue: elem(Integer.parse(n), 0)]
    end)
    |> List.flatten
  end

  def findMaxDiceConfig(l, r) do
    [:red, :green, :blue]
    |> Enum.map(fn
      key -> [{key, max(l[key] || 0, r[key] || 0)}]
    end)
    |> List.flatten
  end

  def parseGameConfig(inp) do
    inp
    |> String.split(": ")
    |> then(fn
      ["Game " <> id, conf] ->
        [
          id: elem(Integer.parse(id), 0),
          configs: conf |> String.split("; ") |> Enum.map(&parseDiceConfig/1)
        ]
    end)
  end

  def isPossible(gameConfig, red, green, blue) do
    gameConfig[:configs]
    |> Enum.all?(
      fn config ->
        Keyword.keys(config)
        |> Enum.all?(
          fn
            :red   -> config[:red]   <= red
            :green -> config[:green] <= green
            :blue  -> config[:blue]  <= blue
          end)
    end)
  end

  def parseGameConfigs(inp) do
    inp
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn line -> String.length(line) > 0 end)
    |> Enum.map(&parseGameConfig/1)
  end

  def addPossible(inp, red, green, blue) do
    parseGameConfigs(inp)
    |> Enum.filter(fn conf -> isPossible(conf, red, green, blue) end)
    |> Enum.reduce(0, fn (conf, acc) -> conf[:id] + acc end)
  end

  def findPowers(inp) do
    parseGameConfigs(inp)
    |> Enum.map(fn gc -> gc[:configs] |> Enum.reduce(&findMaxDiceConfig/2) end)
    |> Enum.map(fn m -> m[:red] * m[:green] * m[:blue] end)
    |> Enum.reduce(&(&1 + &2))
  end

  def run do
    case File.read("./lib/Puzz2.input.txt") do
      {:error, reason} -> IO.puts("File read failed because: " <> reason)
      {:ok, input} ->
        # IO.puts(addPossible(input, 12, 13, 14))
        IO.puts(findPowers(input))
    end
  end

end
