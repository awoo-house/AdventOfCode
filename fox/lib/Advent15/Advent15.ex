defmodule Advent15 do

  alias Advent15.Lens

  #### ENTRYPOINT ##############################################################

  def run do
    case File.read("./lib/Puzz15.input.txt") do
      {:error, e} -> raise "Could not open file because: #{e}."
      {:ok, inp} -> IO.puts("Hash Sum = #{hash_all(inp)}")
    end
  end

  #### API #####################################################################

  @type holiday_hashmap() :: %{ integer() => Lens.t() }
  @type hm_step() :: { :add, Lens.t() } | { :remove, charlist() }

  @spec do_hm_step(holiday_hashmap(), hm_step()) :: holiday_hashmap()
  def do_hm_step(map, {:add, lens}) do
    Map.update(map, hash(lens.label), [lens],
      fn vals -> vals ++ [lens] end
    )
  end
  def do_hm_step(map, {:remove, key}) do
    Map.update(map, hash(key), [],
      fn vals -> Enum.filter(vals, fn %Lens{ label: k } -> k !== key end) end
    )
  end

  @spec hash_all(String.t()) :: integer()
  def hash_all(str) do
    str
    |> String.trim
    |> String.split(",")
    |> Enum.map(&to_charlist/1)
    |> Enum.map(&hash/1)
    |> Enum.sum
  end


  @spec hash(charlist()) :: integer()
  def hash(chrs) do
    Enum.reduce(chrs, 0, fn
      (chr, acc) ->
        Integer.mod((acc + chr) * 17, 256)
    end)
  end
end
