defmodule Day8 do

  def parse(input) do
    init = %{
      :rights => Map.new,
      :lefts => Map.new
    }
    [ins | nodes] = String.split(input, "\n", trim: true)
    IO.inspect(nodes)
    tree = Enum.reduce(nodes, init, fn node, acc ->
      [name, left, right] = Regex.run(~r/(...) = \((...), (...)\)/, String.trim(node), capture: :all_but_first)
      rights = Map.put(acc[:rights], name, right)
      lefts = Map.put(acc[:lefts], name, left)

      %{:rights => rights, :lefts => lefts}
    end)
    {String.trim(ins), tree}
  end

  def run_until_zzz({instructions, map}) do
    init_nodes = Enum.filter(Map.keys(map[:lefts]), fn node ->
      String.ends_with?(node, "A")
    end)

    init = %{:current_nodes => init_nodes, :steps => 0}

    inf = Stream.cycle(String.graphemes(instructions))
    answer = Enum.reduce_while(inf, init, fn instruction, acc ->
      new_nodes = Enum.map(acc[:current_nodes], fn cur_node ->
        go(map, cur_node, instruction)
      end)
      steps = acc[:steps] + 1
      next_acc =  %{:current_nodes => new_nodes, :steps => steps}
      if rem(steps, 1000000) == 0 do
        IO.inspect(steps)
      end
      if Enum.all?(new_nodes, fn newest_nodes ->
        String.ends_with?(newest_nodes, "Z")
      end) do
        {:halt, next_acc}
      else
        {:cont, next_acc}
      end
    end)
    answer[:steps]

  end

  def go(map, current_node, instruction) when instruction == "R", do: Map.get(map[:rights], current_node)
  def go(map, current_node, instruction) when instruction == "L", do: Map.get(map[:lefts], current_node)

  def run do
    case File.read("./lib/inputs/day8.txt") do
      {:ok, input} -> parse(input)
        |> run_until_zzz()
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
