defmodule Day3Part1 do

  defmodule Element do
    defstruct text: "", col: 0, row: 0, type: :empty
  end

  defmodule Schematic do
    # map -> [Element]
    defstruct map: [], columns: 0, rows: 0

    def parse(path) do
      contents = File.read!(path)
      lines = String.split(contents, "\n")

      {map, _} = lines
      |> Enum.map_reduce(0, fn line, row ->
        # Tokenize the line (regexes can be a poor cat's lexer, sure, why not)
        {tokens, _} = Regex.scan(~r/[0-9]+|\.+|./, line)
        |> Enum.map_reduce(0, fn [match], col ->
          # Tag each token with its position
          {%{row: row, col: col, text: match}, col + String.length(match)}
        end)

        elements = tokens
        |> Enum.map(fn %{text: text, col: col, row: row} ->
          # Then tag each token with its type (turning it into an Element)
          %Element{
            text: text, col: col, row: row,
            type: case String.at(text, 0) do
              "." -> :empty
              m when m >= "0" and m <= "9" -> :number
              _ -> :part
            end
          }
        end)
        |> Enum.filter(fn el -> el.type != :empty end)

        {elements, row + 1}
      end)

      map = List.flatten(map)

      %Schematic{map: map, columns: String.length(hd(lines)), rows: length(lines)}
    end

    def is_part_number(self, el) do
      if el.type != :number do false else
        x1 = el.col - 1
        y1 = el.row - 1
        x2 = x1 + String.length(el.text) + 1
        y2 = y1 + 2

        # This is stupidly inefficient but I don't care :D
        Enum.filter(self.map, fn el ->
          el.col >= x1 && el.col <= x2 && el.row >= y1 && el.row <= y2
        end)
        |> Enum.find(fn el -> el.type == :part end)
      end
    end
  end

  def run do
    schematic = Schematic.parse("input/day-3.txt")

    ret = schematic.map
    |> Enum.filter(fn el -> Schematic.is_part_number(schematic, el) end)
    |> Enum.map(fn el -> elem(Integer.parse(el.text), 0) end)
    |> Enum.reduce(0, fn n, sum -> n + sum end)

    IO.puts(ret)
  end

end
