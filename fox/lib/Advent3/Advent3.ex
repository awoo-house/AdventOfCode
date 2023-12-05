defmodule Advent3 do
  alias Advent3.CoordinateSymbol
  alias Advent3.LineProcessor

  @type schematic() :: [{ [%CoordinateSymbol{}], integer() }]

  @spec processLines(String.t()) :: schematic()
  def processLines(inp) do
    String.split(inp, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn l -> String.length(l) > 1 end)
    |> Enum.map(&LineProcessor.processLine/1)
    |> Enum.with_index
  end

  @spec checkRect(schematic(), integer(), integer()) :: boolean()
  def checkRect(schematic, row, col) do
    case getEntryAt(schematic, row, col) do
      nil -> false

      %CoordinateSymbol{ column: column, num: num, sym: _ } ->
        numWidth = length(Integer.digits(num))
        check_cols = (column - 1)..(column + numWidth)
        check_rows = (row-1)..(row+1)

        Enum.any?(check_rows, fn row ->
          Enum.any?(check_cols, fn col ->
            case getEntryAt(schematic, row, col) do
              nil -> false
              %CoordinateSymbol{ column: _, num: _, sym: n } -> n != nil
            end
          end)
        end)
      end
  end

  @spec getEntryAt(schematic(), integer(), integer()) :: %CoordinateSymbol{} | nil
  def getEntryAt(_, row, _) when row < 0, do: nil
  def getEntryAt(schematic, row, col) do
    case Enum.at(schematic, row) do
      nil -> nil
      { rowSyms, _ } -> Enum.find(rowSyms, fn x ->
        case x do
          %CoordinateSymbol{ column: c } -> c == col
        end
      end)
    end

  end


  # def run do
  #   case File.read("./lib/Puzz3.input.txt") do
  #     {:error, reason} -> IO.puts("File read failed because: " <> reason)
  #     {:ok, input} ->
  #       IO.puts(findNumbers(input))
  #   end
  # end
end
