defmodule Day4 do

  def get_card_id(line) do
    # IO.inspect(line)
    cardIdStr = Regex.run(~r/Card *(\d+):/, line, capture: :all_but_first)
    |> List.flatten
    |> List.first
    {cardId, _} = Integer.parse(cardIdStr)
    cardId
  end
  def parse_card(line) do
    card_id = get_card_id(line)
    [_, all_nums] = String.split(line, ":")
    [winning, my_nums] = String.split(all_nums, "|")
    |> Enum.map(fn nums -> String.split(nums) end)

    Enum.reject(my_nums, fn n -> !Enum.find(winning, fn x -> n == x end) end)
    |> length()
    |> then(fn ln -> {card_id, ln} end)
  end

  def get_points(ln) when ln == 0 do
    0
  end
  def get_points(ln) when ln > 0 do
    2**(ln-1)
  end

  def get_total_number_of_cards(cards) do
    lns = Map.new(cards)
    starting = cards
    |> Enum.map(fn {id, _ln} -> {id, 1} end)
    |> Map.new

    e = Enum.reduce(cards, starting, fn {id, ln}, acc ->
      case ln do
        0 -> acc
        n ->
          Enum.reduce((1..n), acc,
            fn x, acc_prime ->
              Map.update(acc_prime, id + x, 1, fn cur -> cur + Map.get(acc_prime, id, 1) end)
            end)
      end
    end)
    IO.inspect(e)
    e
    |> Enum.reduce(0, fn {id, num}, acc -> acc + (num*Map.get(lns, id)) end)
  end


  def runP1 do
    case File.read("./lib/inputs/day4.txt") do
      {:ok, input} -> String.split(input, "\r\n", trim: true)
        |> Enum.map(fn x ->
          parse_card(x)
          |> then(fn {_id, ln} -> get_points(ln) end)
        end)
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end

  def runP2 do
    case File.read("./lib/inputs/day4.txt") do
      {:ok, input} -> String.split(input, "\r\n", trim: true)
        |> Enum.map(fn x -> parse_card(x) end)
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
