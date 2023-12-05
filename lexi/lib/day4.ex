defmodule Day4 do

  def parse_card(line) do
    [_, all_nums] = String.split(line, ":")
    [winning, my_nums] = String.split(all_nums, "|")
    |> Enum.map(fn nums -> String.split(nums) end)

    IO.inspect(winning)
    IO.inspect(my_nums)

  end

  def runP1 do
    case File.read("./lib/inputs/day3.txt") do
      {:ok, input} -> input
        # parse_map(input)
        # |> process
        # # |> Enum.each(fn x -> IO.inspect(x) end)
        # |> Enum.reduce(0, fn x, acc -> x + acc end)
        # |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end

  def runP2 do
    case File.read("./lib/inputs/day3.txt") do
      {:ok, input} -> input
        # parse_map(input)
        # |> process
        # |> get_gear_ratios
        # |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
