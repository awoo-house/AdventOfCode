defmodule Advent10.Node do
  @type pipe() :: { integer(), integer() }
  @type direction() :: :up | :down | :left | :right | :zero

  @spec pretty(pipe(), { pipe(), pipe() }) :: String.t()
  def pretty(node, children) do
    {a, b} = node_dirs(node, children)
    dirs_string(a, b)
  end

  @spec node_dirs(pipe(), { pipe(), pipe() }) :: { direction(), direction() }
  def node_dirs(node, {l, r}) do
    { dir(node, l), dir(node, r) }
  end

  @spec dirs_string(direction(), direction()) :: String.t()
  def dirs_string(:up,    :down ), do: "║"
  def dirs_string(:down,  :up   ), do: "║"
  def dirs_string(:left,  :right), do: "═"
  def dirs_string(:right, :left ), do: "═"
  def dirs_string(:up,    :right), do: "╚"
  def dirs_string(:right, :up   ), do: "╚"
  def dirs_string(:up,    :left ), do: "╝"
  def dirs_string(:left,  :up   ), do: "╝"
  def dirs_string(:down,  :left ), do: "╗"
  def dirs_string(:left,  :down ), do: "╗"
  def dirs_string(:down,  :right), do: "╔"
  def dirs_string(:right, :down ), do: "╔"
  def dirs_string(a, b), do: raise "No combo for #{inspect(a)} and #{inspect(b)}!"

  @spec dir(pipe(), pipe()) :: direction()
  def dir({a, b}, {c, d}) when a < c and b == d, do: :right
  def dir({a, b}, {c, d}) when a > c and b == d, do: :left
  def dir({a, b}, {c, d}) when a == c and b < d, do: :down
  def dir({a, b}, {c, d}) when a == c and b > d, do: :up
  def dir(a, b), do: raise "Cannot find direction between #{inspect(a)} and #{inspect(b)}!!"

end
