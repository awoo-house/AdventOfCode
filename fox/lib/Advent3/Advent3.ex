defmodule Advent3 do
  alias Advent3.CoordinateSymbol
  alias Advent3.LineProcessor

  @spec processLines(String.t()) :: [{ [CoordinateSymbol], integer() }]
  def processLines(inp) do
    String.split(inp, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn l -> String.length(l) > 0 end)
    |> Enum.map(&LineProcessor.processLine/1)
    |> Enum.with_index
  end


  # def run do
  #   case File.read("./lib/Puzz3.input.txt") do
  #     {:error, reason} -> IO.puts("File read failed because: " <> reason)
  #     {:ok, input} ->
  #       IO.puts(findNumbers(input))
  #   end
  # end
end
