defmodule AmmyNine do
  def all_zeroes?(l) do
    Enum.all?(l, fn x -> x == 0 end)
  end

  def prev(seq_chain) do
    Enum.map(seq_chain, fn all -> List.first(all) end)
    |> List.foldr(0, fn first_num, acc -> first_num - acc end)
  end

  def next(seq_chain) do
    Enum.map(seq_chain, fn all -> List.last(all) end)
    |> List.foldr(0, fn last_num, acc -> acc + last_num end)
  end

  def recursive_seq(line) do
    res = Enum.chunk_every(line, 2, 1)
    |> Enum.filter(fn x -> Enum.count(x) > 1 end)
    |> Enum.map(fn [a, b] -> b - a end)
    if all_zeroes?(res) do
      [line]
    else
      [line] ++ recursive_seq(res)
    end

  end

  def run do
    case File.read("input/day9.in") do
      {:ok, input} ->
        # just turn all of this into a big list of integers
        parsed =
          String.split(input, "\n", trim: true)
          |> Enum.map(fn line ->
            String.split(line)
            |> Enum.map(fn x ->
              {i, _} = Integer.parse(x)
              i
            end)
          end)

        # grind those sequences down until they end in all zeroes, guess their last value
        parsed
        |> Enum.map(fn x ->
          recursive_seq(x) |> next()
        end)
        |> Enum.reduce(0, fn x, acc -> x + acc end) # same as day one, cool
        |> IO.inspect()

        # do that again but for their first value, what's a double iteration between friends?
        parsed
        |> Enum.map(fn x ->
          recursive_seq(x) |> prev()
        end)
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
