defmodule Advent10.Graph do

  @type coord() :: { integer(), integer() }

  @doc """
  This maps from x-y pairs to a pair of x-y pairs, representing the node position
  and the two nodes to which it attaches.
  """
  @type graph() :: %{ coord() => { coord(), coord() } }

  # @spec distance_from(graph(), coord()) :: %{ coord() => integer() }
  # def distance_from(g, start, current_d \\ 0, out \\ %{}) do
  #   { l, _ } = g[start]

  #   ll = Map.get(out, l, 0)


  #   if !Map.has_key?(l) do
  #     out = Map.put(out, l, current_d)
  #   end
  # end


end
