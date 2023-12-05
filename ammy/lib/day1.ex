defmodule AmmyOneOne do
  def extract_digits(string) do
    digits = String.replace(string, ~r/\D+/, "")
    first = digits |> String.at(0)
    last = digits |> String.at(-1)
    String.to_integer(first <> last)
  end

  def run do
    case File.read("input/day1.in") do
      {:ok, input} ->
        ans = String.split(input)
          |> Enum.map(fn l -> extract_digits(l) end)
          |> Enum.reduce(0, fn x, acc -> x + acc end)
        IO.write(ans)
      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
