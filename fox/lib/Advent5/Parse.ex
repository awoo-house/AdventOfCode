defmodule Advent5.Parse do
  alias Advent5.Token
  alias Advent5.MapEntry

  @type toks() :: list(Token.t())

  @type mapEntry() :: MapEntry.t()
  @type almanacMaps() :: %{ atom() => %{ to_map: atom(), entries: list(mapEntry()) } }
  @type almanac() :: %{ seeds: list(integer()), maps: almanacMaps() }
  @type parseState() :: %{ from_map: atom(), dest_map: atom(), current: almanac() }

  @type parseResult() :: parseState()


  @spec parseAlmanac(toks()) :: almanac()
  def parseAlmanac(toks), do: parse(toks).current


  @spec parse(toks(), parseState()) :: parseResult()
  def parse(tokens, state \\ %{ from_map: nil, dest_map: nil, current: %{ seeds: [], maps: %{} } })
  def parse([], state), do: state
  def parse([%Token{type: :seedWord} | toks], state) do
    parseSeeds(toks, state)
  end
  def parse([%Token{type: :ident, val: from},
             %Token{type: :toWord},
             %Token{type: :ident, val: dest},
             %Token{type: :mapWord} | toks], state) do
    parseMapEntries(toks,
      %{state | from_map: String.to_atom(from), dest_map: String.to_atom(dest) })
  end

  @spec parseSeeds(toks(), parseState()) :: parseResult()
  def parseSeeds(toks, state) do
    { nums, rest } = Enum.split_while(toks, fn
      %Token{type: :num} -> true
      _ -> false
     end)

     nums = Enum.map(nums, fn n -> n.val end)

     parse(rest, %{ state | current: %{ state.current | seeds: nums }})
  end

  @spec parseMapEntries(toks(), parseState()) :: parseResult()
  def parseMapEntries([], state), do: state
  def parseMapEntries(toks, state) do
    { three_toks, rest } = Enum.split(toks, 3)

    triple? = Enum.all?(three_toks, fn x -> x.type == :num end)

    if triple? do
      [a, b, c] = three_toks
      entry = %MapEntry{
        :source_start => b.val,
        :dest_start => a.val,
        :length => c.val
      }
      parseMapEntries(rest, addEntryToMap(state, entry))
    else
      parse(three_toks ++ rest, state)
    end
  end



  @spec addEntryToMap(parseState(), mapEntry()) :: parseState()
  def addEntryToMap(state, entry) do
    %{ state | current: %{ state.current |
        maps: Map.update(state.current.maps,
          state.from_map,
          %{:to_map => state.dest_map, :entries => [entry]},
          fn cur_map -> %{ cur_map | :entries => [entry | cur_map.entries] } end)
    }}
  end
end
