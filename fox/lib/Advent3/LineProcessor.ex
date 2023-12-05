defmodule Advent3.LineProcessor do
  alias Advent3.CoordinateSymbol

  @type toks() :: [{char(), integer()}]

  # input is e.g.:
  #
  # 467..114..
  # ...*......
  # ..35..633.
  # ......#...

  @spec processLine(integer(), String.t()) :: [%CoordinateSymbol{}]
  def processLine(row, line) do
    parse(row, intoToks(line))
  end

  @spec intoToks(String.t()) :: toks()
  def intoToks(inp) do
    String.to_charlist(inp) |> Enum.with_index
  end

  @spec parse(integer(), toks()) :: [%CoordinateSymbol{}]
  def parse(_, []) do [] end
  def parse(row, ts) do
    case parseBlank(ts) do
      :error ->
        case parseNumber(row, ts) do
          { num, rest } -> [num | parse(row, rest)]
          :error ->
            case parseSymbol(row, ts) do
              { sym, rest } -> [sym | parse(row, rest)]
            end
        end
      cs -> parse(row, cs)
    end
  end

  @spec parseNumber(integer(), toks()) :: { %CoordinateSymbol{}, charlist() } | :error
  def parseNumber(row, toks) do

    case Enum.split_while(toks, &tokIsDig/1) do
      { [], _ } -> :error # Not a number
      { digToks, rest } ->
        str = String.Chars.to_string(Enum.map(digToks, &(elem(&1, 0))))
        case Integer.parse(str) do
          # :error -> :error # Should never get here...
          { num, _ } ->
            { _, column } = List.first(digToks)
            { %CoordinateSymbol{ row: row, column: column, num: num }, rest }
        end
    end
  end

  @spec parseBlank(toks()) :: charlist() | :error
  def parseBlank([{?., _} | rest]) do rest end
  def parseBlank(_)                do :error end

  @spec parseSymbol(integer(), toks()) :: { %CoordinateSymbol{}, charlist() } | :error
  def parseSymbol(row, [{chr, idx} | rest]) do
    { %CoordinateSymbol{row: row, column: idx, sym: chr}, rest }
  end

  def parseSymbol(_) do
    :error
  end

  @spec tokIsDig({char(), integer()}) :: boolean()
  def tokIsDig({ chr, _ }) do
    str = String.Chars.to_string([chr])
    String.match?(str, ~r/\d/)
  end

end
