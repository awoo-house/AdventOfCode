defmodule AmmyTwo do
  def process_game(line) do
    red_thresh = 12
    green_thresh = 13
    blue_thresh = 14

    l = String.replace(line, ~r/.*\: /, "")

    results =
      String.split(l, ";", trim: true)
      |> List.flatten()
      |> Enum.map(fn l -> String.trim(l) end)
      |> Enum.map(fn l -> String.split(l, ",") end)
      |> List.flatten()
      |> Enum.map(fn l -> String.trim(l) end)
      |> Enum.reduce(%{}, fn str, map ->
        [count_str, color] = String.split(str, " ")
        count = String.to_integer(count_str)

        Map.update(map, color, count, fn current_count ->
          if count > current_count, do: count, else: current_count
        end)
      end)

    if Map.get(results, "green") > green_thresh or
         Map.get(results, "red") > red_thresh or
         Map.get(results, "blue") > blue_thresh do
      false
    else
      true
    end
  end

  def process_games(g) do
    g
    |> Enum.map(&process_game/1)
    |> Enum.with_index()
    |> Enum.filter(fn {result, _index} -> result end)
    |> Enum.map(fn {_result, index} -> index + 1 end)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def run do
    case File.read("input/day2.in") do
      {:ok, input} ->
        input
        |> String.split("\n", trim: true)
        |> process_games()
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
