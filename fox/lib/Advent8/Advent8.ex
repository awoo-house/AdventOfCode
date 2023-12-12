defmodule Advent8 do
  @type nodes() :: %{ atom() => { atom(), atom() } }
  @type steps() :: list(:l | :r)
  @type desert_map() :: %{ steps: steps(), nodes: nodes() }

  @spec count_steps(desert_map(), atom()) :: integer()
  def count_steps(desert_map, start_symbol \\ :AAA)
  def count_steps(_, :ZZZ), do: 0
  def count_steps(%{ nodes: nodes, steps: [step | steps] }, sym) do
    1 + count_steps(%{ nodes: nodes, steps: steps ++ [step] }, next_direction(nodes, sym, step))
  end

  defp next_direction(desert_map, where, :l), do: elem(desert_map[where], 0)
  defp next_direction(desert_map, where, :r), do: elem(desert_map[where], 1)

  @spec parse_input(String.t()) :: desert_map()
  def parse_input(inp) do
    [dirs | nodes] =
      String.split(inp, "\n") |>
      Enum.map(&String.trim/1) |>
      Enum.filter(&(String.length(&1) > 0))

    nodes =
      nodes |>
      Enum.reduce(%{}, fn (x, acc) -> parse_graph_line(acc, x) end)

    %{ steps: parse_direction_line(dirs), nodes: nodes }
  end


  @spec parse_graph_line(nodes(), String.t()) :: nodes()
  def parse_graph_line(ns, line) do
    reg = ~r/([A-Z]+) *= *\(([A-Z]+), *([A-Z]+)\)/

    case Regex.run(reg, line, capture: :all_but_first) do
      [id, l, r] -> Map.put(ns, String.to_atom(id), { String.to_atom(l), String.to_atom(r) })
      o -> raise "Unparsable! (got #{o})"
    end
  end

  @spec parse_direction_line(charlist() | String.t()) :: steps()
  def parse_direction_line(s) when is_binary(s), do: parse_direction_line(String.to_charlist(s))
  def parse_direction_line([]), do: []
  def parse_direction_line([ ?L | rest ]), do: [:l | parse_direction_line(rest)]
  def parse_direction_line([ ?R | rest ]), do: [:r | parse_direction_line(rest)]

end
