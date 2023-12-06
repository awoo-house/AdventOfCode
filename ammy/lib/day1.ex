defmodule AmmyOne do
  def numberize(string) do
    # this seems dubious
    out = String.replace(string, "oneight", "18")
    out = String.replace(out, "twone", "21")
    out = String.replace(out, "threeight", "38")
    out = String.replace(out, "fiveight", "58")
    out = String.replace(out, "sevenine", "79")
    out = String.replace(out, "eightwo", "82")
    out = String.replace(out, "eighthree", "83")
    out = String.replace(out, "nineight", "98")
    out = String.replace(out, "nine", "9")
    out = String.replace(out, "eight", "8")
    out = String.replace(out, "seven", "7")
    out = String.replace(out, "six", "6")
    out = String.replace(out, "five", "5")
    out = String.replace(out, "four", "4")
    out = String.replace(out, "three", "3")
    out = String.replace(out, "two", "2")
    out = String.replace(out, "one", "1")
    out
  end

  def extract_digits(string) do
    numberized = numberize(string)
    IO.puts(numberized)
    digits = String.replace(numberized, ~r/\D+/, "")
    first = digits |> String.at(0)
    last = digits |> String.at(-1)
    String.to_integer(first <> last)
  end

  def run do
    case File.read("input/day1.in") do
      {:ok, input} ->
        ans =
          String.split(input)
          |> Enum.map(fn l -> extract_digits(l) end)
          |> Enum.reduce(0, fn x, acc -> x + acc end)

        IO.write(ans)

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
