defmodule Day2Part1 do
  defmodule Game do
    defstruct id: 0, draws: []
  end

  defmodule Draw do
    defstruct red: 0, green: 0, blue: 0
  end

  defimpl Collectable, for: Draw do
    def into(self) do
      inserter = fn
        self, {:cont, {"red", x}} -> %Draw{self | red: x}
        self, {:cont, {"green", x}} -> %Draw{self | green: x}
        self, {:cont, {"blue", x}} -> %Draw{self | blue: x}
        self, :done -> self
        self, :halt -> self
      end
      {self, inserter}
    end
  end

  def run do
    parse("input/day-2.txt")

    # Find games with only 12 red, 13 green, 14 blue
    |> Stream.filter(fn %Game{draws: draws} ->
      Enum.all?(draws, fn %Draw{red: red, green: green, blue: blue} ->
        red <= 12 && green <= 13 && blue <= 14
      end)
    end)

    # Generate the sum as requested
    |> Enum.reduce(0, fn game, sum -> game.id + sum end)
    |> IO.puts
  end

  def parse(path) do
    IO.stream(File.open!(path), :line)
    |> Stream.map(&parse_game/1)
  end

  def parse_game(game) do
    [_, id, draws] = Regex.run(~r/Game (\d+):\s+(.*)$/, game)

    {id, ""} = Integer.parse(id)

    draws = String.split(draws, ~r/\s*;\s*/)
    draws = Enum.map(draws, &parse_draw/1)

    %Game{id: id, draws: draws}
  end

  def parse_draw(draw) do
    colors = String.split(draw, ~r/\s*,\s*/)
    for c <- colors, into: %Draw{}, do: parse_color(c)
  end

  def parse_color(color) do
    [_, count, color] = Regex.run(~r/(\d+)\s+(red|green|blue)/, color)
    {count, ""} = Integer.parse(count)
    {color, count}
  end
end
