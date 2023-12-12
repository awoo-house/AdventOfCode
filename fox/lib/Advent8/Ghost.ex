defmodule Advent8.Ghost do
  # import Advent8, only: [:desert_map]
  use GenServer

  # @spec init({ Advent8.desert_map(), String.t() })
  @impl true
  def init({ inp, start }) do
    map   = inp.nodes
    steps = inp.steps


    initial_state = %{ map: map, steps: steps, sym: start }
    { :ok, initial_state }
  end

  @impl true
  def handle_call(:step, _from, state) do
    %{ map: map, steps: [step | rest], sym: sym } = state

    next = next_direction(map, sym, step)
    new_state = %{ state | steps: rest ++ [step], sym: next }
    { :reply, next, new_state }
  end

  def handle_call(:find_path_length, _from, state) do
    %{ map: map, steps: steps, sym: sym } = state
    path_len = get_path_len(map, steps, sym)
    { :reply, path_len, state }
  end

  defp get_path_len(map, [step | steps], sym) do
    stop_condition? = String.ends_with?(sym, "Z")
    if stop_condition?
      do 0
      else 1 + get_path_len(map, steps ++ [step], next_direction(map, sym, step))
    end
  end

  defp next_direction(desert_map, where, :l), do: elem(desert_map[where], 0)
  defp next_direction(desert_map, where, :r), do: elem(desert_map[where], 1)
end
