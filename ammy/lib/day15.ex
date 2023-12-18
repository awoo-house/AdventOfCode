defmodule AmmyFifteen do
  def run do
    case File.read("input/day15.in") do
      {:ok, gigantic_string} ->
        gigantic_string
        |> String.split(",")
        |> Enum.reduce(0, fn s, acc ->
          chars = s |> String.graphemes()

          ret =
            chars
            |> Enum.reduce(0, fn c, acc2 ->
              # Determine the ASCII code for the current character of the string.
              # Increase the current value by the ASCII code you just determined.
              # Set the current value to itself multiplied by 17.
              # Set the current value to the remainder of dividing itself by 256.
              <<v::utf8>> = c
              rem((acc2 + v) * 17, 256)
            end)

          acc + ret
        end)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
