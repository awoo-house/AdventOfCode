defmodule AmmyTwo do
  def run do
    case File.read("input/day2.in") do
      {:ok, input} ->
        IO.write(input)
      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
