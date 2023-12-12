defmodule Advent8 do
  ##### TYPES ##################################################################

  @type nodes() :: %{ String.t() => { String.t(), String.t() } }
  @type steps() :: list(:l | :r)
  @type desert_map() :: %{ steps: steps(), nodes: nodes() }

  ##### SIMULATION #############################################################


  @spec count_steps(desert_map()) :: integer()
  def count_steps(desert_map) do
    starts = find_all_starts(desert_map)

    pids =
      starts |>
      Enum.map(fn start_symbol -> GenServer.start_link(Advent8.Ghost, { desert_map, start_symbol }) end) |>
      Enum.map(fn { :ok, pid } -> pid end)

    IO.puts("Starting #{length(pids)} servers...")

    lengths = Enum.map(pids, &(GenServer.call(&1, :find_path_length)))
    IO.inspect(lengths)

    Enum.reduce(lengths, 1, &(&1 * &2))
    # step_servers(pids)
  end

  @spec step_servers(list(pid()), integer()) :: integer()
  defp step_servers(pids, current_count \\ 1)
  defp step_servers(pids, current_count) do
    outs = Enum.map(pids, &(GenServer.call(&1, :step)))
    end_state? = Enum.all?(outs, fn s -> String.ends_with?(s, "Z") end)

    # [outs, _] = GenServer.multi_call(Advent8.Ghost, :tep)
    # end_state? = Enum.all?(outs, fn { _, s } -> String.ends_with?(s, "Z") end)

    if end_state?
      do current_count
      else step_servers(pids, current_count+1)
    end
  end
  # def count_steps(%{ nodes: nodes, steps: [step | steps] }, sym) do
  #   if String.ends_with?(sym, "Z")
  #     do 0
  #     else 1 + count_steps(%{ nodes: nodes, steps: steps ++ [step] }, next_direction(nodes, sym, step))
  #   end
  # end

  @spec find_all_starts(desert_map()) :: list(String.t())
  def find_all_starts(%{ nodes: nodes }) do
    Map.keys(nodes)
      |> Enum.filter(fn k -> String.last(k) == "A" end)
      |> Enum.to_list
  end


  ##### INPUT PROCESSING #######################################################

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
    reg = ~r/([A-Z0-9]+) *= *\(([A-Z0-9]+), *([A-Z0-9]+)\)/

    case Regex.run(reg, line, capture: :all_but_first) do
      [id, l, r] -> Map.put(ns, id, { l, r })
      o -> raise "Unparsable! (got #{o})"
    end
  end

  @spec parse_direction_line(charlist() | String.t()) :: steps()
  def parse_direction_line(s) when is_binary(s), do: parse_direction_line(String.to_charlist(s))
  def parse_direction_line([]), do: []
  def parse_direction_line([ ?L | rest ]), do: [:l | parse_direction_line(rest)]
  def parse_direction_line([ ?R | rest ]), do: [:r | parse_direction_line(rest)]

  ##### MAIN ENTRY POINT #######################################################

  def run do
    case File.read("./lib/Puzz8.input.txt") do
      {:ok, inp} ->
        inp = parse_input(inp)
        count = count_steps(inp)
        IO.puts("Number of steps: #{count}.")
    end
  end
end
