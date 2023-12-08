defmodule Day6 do

  def get_race_possibilities(time) do
    Enum.map(0..time, fn time_held_down ->
      time_to_race = time - time_held_down
      mmps = time_held_down
      mm = mmps * time_to_race
      mm
    end)
  end

  def ways_to_win({time, distance}) do
    possible_endings = get_race_possibilities(time)
    Enum.filter(possible_endings, fn x -> x > distance end)
    |> Enum.count
  end

  def parse(input) do
    ret =
      String.split(input, "\n")
      |> Enum.map(fn x ->
        Regex.scan(~r/(\d+)/, x, capture: :all_but_first)
        |> List.flatten
        |> Enum.map(fn y ->
          {n, _} = Integer.parse(y)
          n
        end)
      end)
      |> Enum.filter(fn x -> Enum.count(x) > 0 end)
      [t, d] = ret
      Enum.zip(t, d)

  end

  def runP1 do
    case File.read("./lib/inputs/day6.txt") do
      {:ok, input} -> parse(input)
        |> Enum.reduce(1, fn {t, r}, acc -> acc * ways_to_win({t, r}) end)
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end

  def runP2 do
    case File.read("./lib/inputs/day6.txt") do
      {:ok, input} -> String.split(input, "\n", trim: true)
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
