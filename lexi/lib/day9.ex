defmodule Day9 do

  def guess_next(processed) do
    Enum.map(processed, fn arrs ->
      List.last(arrs)
    end)
    |> List.foldr(0, fn last_num, acc -> acc + last_num end)
  end
  def guess_prev(processed) do
    Enum.map(processed, fn arrs ->
      List.first(arrs)
    end)
    |> List.foldr(0, fn first_num, acc -> first_num - acc end)
  end

  def process(nums) do
    res = Enum.chunk_every(nums, 2, 1)
    |> Enum.filter(fn x ->
      Enum.count(x) > 1
    end)
    |> Enum.map(fn [a, b] ->
      b - a
    end)
    if Enum.all?(res, fn x -> x == 0 end) do
      [nums]
    else
      [nums] ++ process(res)
    end

  end

  def parse(input) do
    lines = String.split(input, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line)
      |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)
    end)
    lines
  end

  def run do
    case File.read("./lib/inputs/day9.txt") do
      {:ok, input} -> parse(input)
        |> Enum.map(fn x -> Day9.process(x) |> Day9.guess_prev end)
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
