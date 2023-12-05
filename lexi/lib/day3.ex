defmodule Day3 do
  def parse_map(input) do
    # grid = %{}
      String.split(input)
      |> Enum.flat_map(fn { line, y_index } ->
        String.split(line)
        |> Enum.map(fn { character, x_index } ->
          {{ x_index, y_index }, character }
        end)
      end)
      |> Map.new()
    end




  # def parse_map(input) do
  #   grid = %{}
  #   case File.read("./lib/inputs/day3.txt") do
  #     {:ok, input} ->
  #      parse_map(input)
  #     {:error, reason} ->
  #       IO.write(reason)
  #       grid
  #   end
  # end
end
