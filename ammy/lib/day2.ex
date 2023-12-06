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

        map |> Map.update(color, count, fn val -> max(val, count) end)
      end)

    valid_game =
      Map.get(results, "green") <= green_thresh and
        Map.get(results, "red") <= red_thresh and
        Map.get(results, "blue") <= blue_thresh

    min_products =
      results
      |> Enum.map(fn {_, prod} -> prod end)
      |> Enum.reduce(1, fn n, acc -> n * acc end)

    {valid_game, min_products}
  end

  def find_valid_games(g) do
    g
    |> Enum.map(&process_game/1)
    |> Enum.with_index()
    |> Enum.filter(fn {result, _index} -> elem(result, 0) end)
    |> Enum.map(fn {_result, index} -> index + 1 end)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def find_sum_of_powers(g) do
    g
    |> Enum.map(&process_game/1)
    |> Enum.filter(fn result -> elem(result, 1) end)
    |> Enum.map(fn {_, index} -> index end)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def run do
    case File.read("input/day2.in") do
      {:ok, input} ->
        input
        |> String.split("\n", trim: true)
        |> find_valid_games()
        |> IO.inspect()

        input
        |> String.split("\n", trim: true)
        |> find_sum_of_powers()
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
