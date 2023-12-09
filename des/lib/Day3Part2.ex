defmodule Day3Part2 do

  defmodule Element do
    defstruct text: "", col: 0, row: 0, type: :empty

    def num(el), do: elem(Integer.parse(el.text), 0)
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

    def adjacent_elements(self, el) do
      # There's probably a faster way to do this but it's 22:30 and I'm tired
      interval_contains_point = fn {l, r}, p -> p >= l and p <= r end
      intervals_intersect = fn {l1, r1}, {l2, r2} ->
        interval_contains_point.({l1, r1}, l2) or
        interval_contains_point.({l1, r1}, r2) or
        interval_contains_point.({l2, r2}, l1) or
        interval_contains_point.({l2, r2}, r1)
      end

      x1 = el.col - 1
      y1 = el.row - 1
      x2 = x1 + String.length(el.text) + 1
      y2 = y1 + 2

      # This is stupidly inefficient but I don't care :D
      Enum.filter(self.map, fn el ->
        interval_contains_point.({y1, y2}, el.row) and
        intervals_intersect.({x1, x2}, {el.col, el.col + String.length(el.text) - 1})
      end)
    end

    def gear_ratio(self, el) do
      if el.text == "*" do
        part_nums = adjacent_elements(self, el)
        |> Enum.filter(fn el -> el.type == :number end)

        if length(part_nums) == 2 do
          # dbg(el)
          # dbg(part_nums)
          Element.num(hd(part_nums)) * Element.num(hd(tl(part_nums)))
        else nil end
      else nil end
    end
  end

  def run do
    schematic = Schematic.parse("input/day-3.txt")

    ret = schematic.map
    |> Enum.map(fn el -> Schematic.gear_ratio(schematic, el) end)
    |> Enum.filter(fn el -> el != nil end)
    |> Enum.reduce(0, fn n, sum -> n + sum end)

    IO.puts(ret)
  end

end
