defmodule Day4Part2 do
  def run do
    parse("input/day-4.txt")
  end

  def parse(path) do
    # Example from the problem:
#     String.split(
#       "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
# Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
# Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
# Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
# Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
# Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11", "\n"
#     )

    IO.stream(File.open!(path), :line)
    |> Stream.map(&parse_card/1)

    # Count the number of copies of each card
    |> Enum.reduce(%{}, fn card, copies ->
      copies = Map.put_new(copies, card.id, 1)
      copies_of_this_card = copies[card.id]
      matching_count = count_matches(card)

      # dbg({copies, card, copies_of_this_card, matching_count})

      if matching_count >= 1 do
        1..matching_count
        |> Enum.reduce(copies, fn n, copies ->
          Map.update(copies, card.id + n,
            1 + copies_of_this_card,
            fn old -> old + copies_of_this_card end)
        end)
      else
        copies
      end
    end)

    # Count the total number of cards
    |> Enum.reduce(0, fn {_, v}, sum -> v + sum end)
    |> IO.puts
  end

  def parse_card(line) do
    [_, id, winning, has] = Regex.run(~r/Card\s+(\d+):\s+([\d\s]+\d)\s+\|\s+([\d\s]+\d)/, line)

    id = elem(Integer.parse(id), 0)

    winning = String.split(winning, ~r/\s+/)
    |> Enum.map(fn n -> elem(Integer.parse(n), 0) end)

    has = String.split(has, ~r/\s+/)
    |> Enum.map(fn n -> elem(Integer.parse(n), 0) end)

    %{id: id, winning: winning, has: has}
  end

  def count_matches(%{winning: winning, has: has}) do
    has
    |> Enum.filter(fn n -> Enum.find(winning, fn e -> e == n end) != nil end)
    |> length
  end
end
