defmodule Advent3 do
  alias Advent3.CoordinateSymbol
  alias Advent3.LineProcessor

  @type schematic() :: [{ [%CoordinateSymbol{}], integer() }]

  @spec partNumberSum(String.t()) :: integer()
  def partNumberSum(inp) do
    schematic = processLines(inp)

    Enum.reduce(schematic, 0, fn ({ row, row_num }, row_acc) ->
      Enum.reduce(row, row_acc, fn
        (%CoordinateSymbol{ column: col_num, num: n }, acc) when n != nil ->
          case checkRect(schematic, row_num, col_num) do
            true  -> n + acc
            false -> acc
          end
        (_, acc) -> acc
        end)
    end)
  end

  @spec getGearRatioSum(schematic()) :: integer()
  def getGearRatioSum(sch) do
    getGears(sch)
    |> Map.values
    |> Enum.map( fn {%CoordinateSymbol{ num: a }, %CoordinateSymbol{ num: b }} -> a * b end)
    |> Enum.reduce(&(&1 + &2))
  end

  @spec getGears(schematic()) :: %{ %CoordinateSymbol{} => { %CoordinateSymbol{}, %CoordinateSymbol{} }}
  def getGears(sch) do
    Enum.reduce(sch, %{}, fn ({ row, _ }, row_acc) ->
      Enum.reduce(row, row_acc, fn (col_sym, acc) ->
        case getMaybeGear(sch, col_sym) do
          [a, b] -> Map.put(acc, col_sym, { a, b })
          _ -> acc
        end
      end)
    end)
  end

  @spec getMaybeGear(schematic(), %CoordinateSymbol{}) :: [%CoordinateSymbol{}]
  def getMaybeGear(sch, %CoordinateSymbol{ row: row, column: col, sym: ?* }) do
    check_cols = (col-1)..(col+1)
    check_rows = (row-1)..(row+1)

    # Not the best way to do this...
    Enum.reduce(check_rows, [], fn
     (row_num, row_acc) ->
      Enum.reduce(check_cols, row_acc, fn
        (col_num, acc) ->
          entry = getEntryAt(sch, row_num, col_num)
          case entry do
            %CoordinateSymbol{ num: n } when n != nil ->
              case Enum.member?(acc, entry) do
                true -> acc
                false -> [entry | acc]
              end

            _ -> acc
          end
        end)
    end)
  end

  def getMaybeGear(_, _), do: nil



  @spec processLines(String.t()) :: schematic()
  def processLines(inp) do
    String.split(inp, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn l -> String.length(l) > 1 end)
    |> Enum.with_index
    |> Enum.map(fn {l, idx} -> LineProcessor.processLine(idx, l) end)
    |> Enum.with_index
  end

  @spec numWidth(integer()) :: integer()
  def numWidth(num), do: length(Integer.digits(num))

  @spec checkRect(schematic(), integer(), integer()) :: boolean()
  def checkRect(schematic, row, col) do
    case getEntryAt(schematic, row, col) do
      nil -> false

      %CoordinateSymbol{ column: column, num: num, sym: _ } ->
        check_cols = (column - 1)..(column + numWidth(num))
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
  def getEntryAt(_, _, col) when col < 0, do: nil
  def getEntryAt(_, row, _) when row < 0, do: nil
  def getEntryAt(schematic, row, col) do
    case Enum.at(schematic, row) do
      nil -> nil
      { rowSyms, _ } -> Enum.find(rowSyms, fn x ->
        case x do
          %CoordinateSymbol{ column: c, num: nil } ->
            c == col

          %CoordinateSymbol{ column: c, num: num } ->
            c <= col and col < (c + numWidth(num))
        end
      end)
    end

  end

  def run do
    case File.read("./lib/Puzz3.input.txt") do
      {:error, reason} -> IO.puts("File read failed because: " <> to_string(reason))
      {:ok, input} ->
        # IO.puts(partNumberSum(input))
        IO.puts(getGearRatioSum(processLines(input)))
    end
  end
end
