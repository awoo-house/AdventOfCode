defmodule Day6 do

  def increasing_possibilies(time) when rem(time, 2) == 0 do
    round((time / 2) + 1)
  end

  def increasing_possibilies(time) do
    round(((time - 1) / 2) + 1)
  end

  # def winning_possibilities(time, first_winning_held_time) when rem(time, 2) == 0 do
  #   IO.inspect("99p9pp9p9p9p9p")
  #   IO.inspect(time)
  #   IO.inspect(first_winning_held_time)

  #   failing_times = first_winning_held_time * 2
  #   all_times = time + 1
  #   all_times - failing_times
  # end

  def winning_possibilities(time, first_winning_held_time) do
    failing_times = first_winning_held_time * 2
    all_times = time + 1
    all_times - failing_times
  end

  def get_index_of_ways_to_win_that_first_wins({time, distance}) do
    num_increasing = increasing_possibilies(time)
    possible_times = 0..num_increasing
    first_winning = Stream.take_while(possible_times, fn time_held_down ->
      get_race_possibility(time, time_held_down) <= distance
    end)
    winning_possibilities(time, Enum.count(first_winning))

  end

  def get_race_possibility(time, time_held_down) do
    time_to_race = time - time_held_down
    mmps = time_held_down
    mm = mmps * time_to_race
    mm
  end


  def get_race_possibilities(time) do

    IO.inspect(increasing_possibilies(time))
    Enum.map(0..time, fn time_held_down ->
      time_to_race = time - time_held_down
      mmps = time_held_down
      mm = mmps * time_to_race
      mm
    end)
  end

  def ways_to_win({time, distance}) do
    index = get_index_of_ways_to_win_that_first_wins({time, distance})
    total_increasing = increasing_possibilies(time)
    (total_increasing - index) * 2
  end

  def parse_part2(input) do
    ret =
      String.split(input, "\n")
      |> Enum.map(fn x ->
        no_ws = Regex.replace(~r/ /, x, "")
        IO.inspect(no_ws)

        Regex.scan(~r/(\d+)/, no_ws, capture: :all_but_first)
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
        |> Enum.reduce(1, fn {t, r}, acc -> acc * get_index_of_ways_to_win_that_first_wins({t, r}) end)
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end

  def runP2 do
    case File.read("./lib/inputs/day6.txt") do
      {:ok, input} ->
        inp = parse_part2(input)
        IO.inspect(get_index_of_ways_to_win_that_first_wins(List.first(inp)))
      {:error, reason} -> IO.write(reason)
    end
  end
end
