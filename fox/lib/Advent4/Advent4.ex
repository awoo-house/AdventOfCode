defmodule Advent4 do
  import Bitwise

  @type card() :: [card_num: integer(), winners: list(integer()), yours: list(integer())]
  @type cardcounts() :: %{integer() => integer()}

  # Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  #         --------------   -----------------------
  #            WINNERS               YOURS

  @doc """
    inputs to parseNumbers may be separated by any number of spaces,
    but MUST NOT BEGIN with any whitespace.
  """
  @spec parseNumbers(String.t()) :: list(integer())
  def parseNumbers(""), do: []
  def parseNumbers(numbers) do
    case Integer.parse(numbers) do
      { n, r } -> [n | parseNumbers(String.trim_leading(r))]
    end
  end

  @spec parseLine(String.t()) :: card()
  def parseLine(inp) do
    [_, card_num, winners, mine] = Regex.run(~r/^.*?([\d+]): +(.*?) +\| +(.*)$/, inp)
    card_num = elem(Integer.parse(card_num), 0)
    [ card_num: card_num, winners: Enum.sort(parseNumbers(winners)), mine: Enum.sort(parseNumbers(mine)) ]
  end

  @spec cardMatchLength(card()) :: integer()
  def cardMatchLength([card_num: _, winners: winners, mine: mine]) do
    Enum.filter(winners, fn w -> Enum.member?(mine, w) end)
    |> length
  end

  @spec cardScore(card()) :: integer()
  def cardScore(card) do
    cardMatchLength(card)
    |> then(fn
        0 -> 0
        l -> 1 <<< (l-1)
    end)
  end


  @spec incCardCount(cardcounts(), integer(), integer(), integer()) :: cardcounts()
  def incCardCount(counts, n, l, by \\ 1) do
    Enum.reduce((n..(n+l-1)), counts, fn
      (n, acc) -> Map.update(acc, n, 1, &(&1 + by))
    end)
  end

  @spec runCardMap(list(card()), cardcounts(), integer(), integer()) :: cardcounts()
  def runCardMap(_cards, counts, n, m) when n == m, do: counts
  def runCardMap(cards, counts, n, m) do
    cardDuplCount = cardMatchLength(Enum.at(cards, n))
    incBy = counts[n]
    newCount = incCardCount(counts, n, cardDuplCount, incBy)
    runCardMap(cards, newCount, n + 1, m)
  end

  @spec runCards(list(card())) :: cardcounts()
  def runCards(cards) do
    initialCounts = Enum.map(0..(length(cards)-1), fn x -> { x, 1 } end) |> Map.new
    runCardMap(cards, initialCounts, 0, length(cards)-1)
  end

  def run do
    case File.open("./lib/Puzz4.input.txt") do
      {:error, reason} -> IO.puts("File read failed because: " <> to_string(reason))
      {:ok, input} ->
        cards = IO.stream(input, :line)
                |> Enum.map(&String.trim/1)
                |> Enum.filter(&(String.length(&1) > 0))
                |> Enum.map(&Advent4.parseLine/1)

        card_counts = runCards(cards)

        card_total = card_counts
          |> Map.values
          |> Enum.reduce(&(&1 + &2))

        IO.inspect(card_total)
    end
  end

end
