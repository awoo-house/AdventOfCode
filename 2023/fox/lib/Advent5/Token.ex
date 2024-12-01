defmodule Advent5.Token do
  # Hm... https://stackoverflow.com/a/47501059
  alias __MODULE__

  @enforce_keys :type
  defstruct [:type, :val]

  @type t() :: %Advent5.Token{}

  @spec tokenize(String.t()) :: list(t())
  def tokenize(""), do: []
  def tokenize(" " <> rest), do: tokenize(rest)
  def tokenize("\r\n" <> rest), do: tokenize(rest)
  def tokenize("\n" <> rest), do: tokenize(rest)
  def tokenize("to-" <> rest), do: [%Token{type: :toWord} | tokenize(rest)]
  def tokenize("seeds:" <> rest), do: [%Token{type: :seedWord} | tokenize(rest)]
  def tokenize("map:" <> rest), do: [%Token{type: :mapWord} | tokenize(rest)]
  def tokenize(inp) do
    case Integer.parse(inp) do
      :error ->
        [id, rest] = String.split(inp, ~r/[ -]/, parts: 2)
        [%Token{type: :ident, val: id} | tokenize(rest)]

      { num, rest } ->
        [%Token{type: :num, val: num } | tokenize(rest)]
    end
  end
end
