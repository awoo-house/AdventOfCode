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

  def lcm(a, b), do: trunc((a * b) / Integer.gcd(a, b))

  def run_until_zzz({instructions, map}) do
    init_nodes = Enum.filter(Map.keys(map[:lefts]), fn node ->
      String.ends_with?(node, "A")
    end)
    |> Enum.map(fn n ->
      {n, 0, 0, 0}
    end)

    inf = Stream.cycle(String.graphemes(instructions))
    answer = Enum.reduce_while(inf, init_nodes, fn instruction, acc ->
      new_nodes = Enum.map(acc, fn {cur_node, steps, reset_step, resets} ->
        next = go(map, cur_node, instruction)
        ns = steps + 1
        if String.ends_with?(next, "Z") do
          if resets > 0 and ns != reset_step do
            IO.inspect("!!!!! This is different than last time!")
            IO.inspect({cur_node, ns, reset_step, resets})
          end
          { next, 0, ns, resets + 1}
        else
          { next, ns, reset_step, resets}
        end
      end)

      if Enum.all?(new_nodes, fn {_cur_node, _steps, _reset_step, resets}  ->
        resets > 8
      end) do
        {:halt, new_nodes}
      else
        {:cont, new_nodes}
      end
    end)
    IO.inspect(answer)

    Enum.reduce(answer, 1, fn {_, _a, d, _r}, acc ->
      lcm(acc, d)
    end)
    |> IO.inspect

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
