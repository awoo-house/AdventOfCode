defmodule AmmyFive do
  def contains_colon?(str) do
    Regex.match?(~r/:/, str)
  end

  def build_almanac(input) do
    almanac = String.split(input, "\n", trim: true)
      |> Enum.reduce({%{}, ""}, fn str, {map, last_from} ->
        cond do
          String.starts_with?(str, "seeds") ->
            # build the seed list
            s = String.replace(str, ~r/.*\: /, "")
            l = String.split(s, " ")
            {Map.put_new(map, "seeds", l), last_from}

          contains_colon?(str) ->
            s = String.split(str, " ")
            from_to = List.first(s)
            s = String.split(from_to, "-")
            from = List.first(s)
            to = List.last(s)
            {Map.put_new(map, from, %{to: to}), from}

          str != "" ->
            # not a new map, not seeds, not a blank line
            map
            |> Map.update(last_from, [], fn existing ->
              new = String.split(str, " ")
              existing ++ new
            end)

          true ->
            {map, last_from}
        end
      end)

    IO.inspect(almanac)
  end

  def run do
    case File.read("input/day5.in") do
      {:ok, input} -> build_almanac(input)
      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
