defmodule AmmySix do
  def read_times_and_distances(content) do
    lines = String.split(content, "\n", trim: true)
    times_line = String.replace(Enum.at(lines, 0), ~r/[^\s\d]+/, "")
    times_line = String.split(times_line, ~r/\s+/, trim: true)

    distances_line = String.replace(Enum.at(lines, 1), ~r/[^\s\d]+/, "")
    distances_line = String.split(distances_line, ~r/\s+/, trim: true)

    times = Enum.map(times_line, &Integer.parse/1)
    times_only = for {n, _} <- times, do: n
    distances = Enum.map(distances_line, &Integer.parse/1)
    distances_only = for {n, _} <- distances, do: n

    {times_only, distances_only}
  end

  def possible_speeds(n) when is_integer(n) and n > 0 do
    Enum.map(1..n, fn i -> i * (n - i) end)
  end

  def run do
    case File.read("input/day6.in") do
      {:ok, input} ->
        {times, distances} = read_times_and_distances(input)

        ans =
          Enum.reduce(0..length(times)-1, 1, fn _, acc ->
            Enum.zip(times, distances)
            |> Enum.map(fn {t, d} ->
              speeds = possible_speeds(t)
              winnable_speeds = Enum.filter(speeds, &(&1 >= d))
              length(winnable_speeds)
            end)
          end)
          |> Enum.reduce(1, &(&1 * &2))
        IO.inspect(ans)

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
