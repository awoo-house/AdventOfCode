defmodule Advent6 do


  @doc """
    Absolute nonsense. See the latex doc in docs/notes.tx
  """
  @spec find_it(integer(), integer()) :: Range.t()
  def find_it(race_time, record) do
    nonsense = :math.sqrt(race_time ** 2.0 - 4.0*record) / 2.0

    top = ((race_time/2.0) + nonsense - 0.00001)
    bot = ((race_time/2.0) - nonsense + 0.00001)

    (trunc(bot)+1..trunc(top))
  end


  @spec part_one(list({ integer(), integer() })) :: integer()
  def part_one(inps) do
    inps |>
      Enum.map(fn { time, record } -> find_it(time, record) end) |>
      Enum.reduce(1, fn ((lo..hi), acc) -> (hi-lo+1) * acc end)
  end


  def process_labels(inp) do
    [_, nums] = String.split(inp, ":", parts: 2)

    String.split(nums, " ")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn x -> String.length(x) > 0 end)
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn
        {:error, e} -> raise e
        {n, _} -> n
      end)
  end

  # Time:      7  15   30
  # Distance:  9  40  200
  def process_inp(inp) do
    [time, distances] = String.split(inp, "\n", parts: 2) |> Enum.map(&String.trim/1)
    times = process_labels(time)
    distances = process_labels(distances)

    Enum.zip(times, distances)
  end

end
