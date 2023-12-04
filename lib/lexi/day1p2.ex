defmodule LexiDay1p2 do
  @moduledoc """
  Documentation for `LexiDay1p2`.
  """

  def replaceFirstNumberInString(input) do

    replacements = %{
      "one" => "1ne",
      "two" => "2wo",
      "three" => "3hree",
      "four" => "4our",
      "five" => "5ive",
      "six" => "6ix",
      "seven" => "7even",
      "eight" => "8ight",
      "nine" => "9ine"
    }
    Enum.map(replacements, fn {strValue, _intValue} ->
      case :binary.match(input, strValue) do
        :nomatch -> nil
        {start, _len} -> {start, strValue}
      end
    end)
    |> Enum.filter(fn x -> x end)
    |> Enum.sort_by(fn { sortableValue, _strValue } -> sortableValue end)
    |> Enum.at(0)
    |> case do
      nil -> input
      {_start, key} -> String.replace(input, key, Map.get(replacements, key))
    end
  end

  def replaceNumberStrings(input) do
    case replaceFirstNumberInString(input) do
      output when output == input -> input
      output -> replaceNumberStrings(output)
    end
  end

  def processNumbers([singleNum]) do
    singleNum <> singleNum
  end
  def processNumbers([head|rest]) do
    head <> List.last(rest)
  end

  def processLine(line) do
    replaceNumberStrings(line)
      |> then(&(Regex.scan(~r/(\d)/, &1, capture: :all_but_first)))
      |> List.flatten
      |> processNumbers
      |> Integer.parse
      |> elem(0)
  end

  def run do
    case File.read("./lib/lexi/inputs/day1.txt") do
      {:ok, input} -> String.split(input)
        |> Enum.map(fn x -> processLine(x) end)
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.write
      {:error, reason} -> IO.write(reason)
    end
  end
end
