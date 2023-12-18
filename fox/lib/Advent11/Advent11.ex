defmodule Advent11 do
  alias Advent11.Starmap

  @spec manhattan_dist(Starmap.t()) :: integer()
  def manhattan_dist(inp) do
    Starmap.expand(inp)
    |> Starmap.get_galaxy_pairs
    |> Enum.map(fn {{a, b}, {x, y}} ->
      dist = abs(a - x) + abs(b - y)
      # IO.puts("|(#{a}, #{b}) - (#{x}, #{y})| = #{dist}")
      dist
    end)
    |> Enum.sum
  end

  ##############################################################################

  def run do
    case File.read("./lib/Puzz11.input.txt") do
      {:ok, inp} ->
        inp = Starmap.new(inp)
        out = manhattan_dist(inp)
        IO.puts("Sum: #{out}")

      {:error, e} ->
        raise "Error opening file because #{inspect(e)}"
    end
  end
end
