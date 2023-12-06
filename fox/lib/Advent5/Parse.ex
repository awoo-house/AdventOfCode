defmodule Advent5.Parse do
  alias Advent5.Token
  @type toks() :: list(Token.t())

  @type almanac() :: %{ atom() => list(integer()) }
  @type parseState() :: %{ writing_to: atom(), current: almanac() }

  @type parseResult() :: parseState()


  @spec parseAlmanac(toks()) :: almanac()
  def parseAlmanac(toks), do: parse(toks).current



  @spec parse(toks(), parseState()) :: parseResult()
  def parse(tokens, state \\ %{ writing_to: nil, current: %{} })
  def parse([], state), do: state
  def parse([%Token{type: :seedWord} | toks], state) do
    parseSeeds(toks, %{state | writing_to: :seeds })
  end
  def parse([%Token{type: :ident, val: id}, %Token{type: :mapWord} | toks], state) do
    parseMapEntries(toks, %{state | writing_to: String.to_atom(id)})
  end

  @spec parseSeeds(toks(), parseState()) :: parseResult()
  def parseSeeds(toks, state) do
    { nums, rest } = Enum.split_while(toks, fn
      %Token{type: :num} -> true
      _ -> false
     end)

     nums = Enum.map(nums, fn n -> n.val end)

     parse(rest, updateMap(state, nums))
  end

  @spec parseMapEntries(toks(), parseState()) :: parseResult()
  def parseMapEntries([], state), do: state
  def parseMapEntries(toks, state) do
    { three_toks, rest } = Enum.split(toks, 3)

    triple? = Enum.all?(three_toks, fn x -> x.type == :num end)

    if triple? do
      [a, b, c] = three_toks
      parseMapEntries(rest, updateMap(state, [{a.val, b.val, c.val}]))
    else
      parse(three_toks ++ rest, state)
    end
  end



  @spec parse(list(any()), parseState()) :: parseState()
  def updateMap(state, val) do
    %{ state | current:
        Map.update(state.current, state.writing_to, val,
          fn xs -> xs ++ val end)
    }
  end
end
