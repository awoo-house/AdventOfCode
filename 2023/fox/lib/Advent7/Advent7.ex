defmodule Advent7 do
  alias Advent7.Hand

  @type hands_and_bids() :: [%{ hand: Hand.t(), bid: integer() }]


  def run() do
    case File.read("./lib/Puzz7.input.txt") do
      { :error, e } -> IO.puts{"Error reading file: #{e}"}
      { :ok, dat } ->
        IO.inspect(day1(process_inp(dat)))
    end
  end

  @spec day1(hands_and_bids()) :: integer()
  def day1(habs) do
      habs
      |> Enum.with_index
      |> Enum.map(fn
        { %{ bid: bid }, i } -> bid * (i+1)
      end)
      |> Enum.reduce(&(&1 + &2))
  end


  @spec process_inp(String.t) :: hands_and_bids()
  def process_inp(inp) do
    String.split(inp, "\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn l -> String.length(l) > 0 end)
      |> Enum.map(fn l -> String.split(l, " ", parts: 2) end)
      |> Enum.map(&process_line/1)
      |> Enum.sort_by(fn hab -> hab.hand end, fn (a, b) -> Hand.compare(a, b) != :gt end)
  end

  @spec process_line(list()) :: %{ hand: Hand.t(), bid: integer() }
  defp process_line([h, b]) do
    case Integer.parse(b) do
      :error -> raise "Could not parse bid: #{b}"
      {bid, _} -> %{ hand: Hand.new(h), bid: bid }
    end
  end

end
