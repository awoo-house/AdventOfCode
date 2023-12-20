defmodule AmmyFifteen do
  def cool_hash_of_char(char, init_val) do
    # Determine the ASCII code for the current character of the string.
    # Increase the current value by the ASCII code you just determined.
    # Set the current value to itself multiplied by 17.
    # Set the current value to the remainder of dividing itself by 256.
    <<v::utf8>> = char
    rem((init_val + v) * 17, 256)
  end

  def run do
    case File.read("input/day15.in") do
      {:ok, gigantic_string} ->
        gigantic_string
        |> String.split(",")
        |> Enum.reduce(0, fn s, acc ->
          chars = s |> String.graphemes()

          maybe_minus = String.split("-")
          maybe_equals = String.split("=")
          {label, op} = {"", ""}
          if length(maybe_minus == 2) do
            label = Enum.at(maybe_minus, 0)
            op = Enum.at(maybe_minus, 1)
          else if length(maybe_equals == 2) do
            label = Enum.at(maybe_equals, 0)
            op = Enum.at(maybe_equals, 1)
          else
            raise "malformed label"
          end
          ret =
            chars
            |> Enum.reduce(0, fn c, acc2 ->
              cool_hash_of_char(c, acc2)
            end)

          acc + ret
        end)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
