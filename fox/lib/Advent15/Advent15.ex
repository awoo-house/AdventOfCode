defmodule Advent15 do

  alias Advent15.Lens

  #### ENTRYPOINT ##############################################################

  def run do
    case File.read("./lib/Puzz15.input.txt") do
      {:error, e} -> raise "Could not open file because: #{e}."
      {:ok, inp} ->
        # Part I
        # IO.puts("Hash Sum = #{hash_all(inp)}")

        # Part II
        instrs = parse_instrs(inp)
        map = run_hm_steps(instrs)
        IO.puts("Lens Scores = #{get_lens_scores(map)}")
    end
  end

  #### TYPES ###################################################################

  @type holiday_hashmap() :: %{ integer() => Lens.t() }
  @type hm_step() :: { :add, Lens.t() } | { :remove, charlist() }

  #### INPUT ###################################################################


  @spec parse_instrs(String.t()) :: list(hm_step())
  def parse_instrs(inp) do
    inp
    |> String.trim
    |> String.split(",")
    |> Enum.map(&parse_instr/1)
  end

  @spec parse_instr(String.t()) :: hm_step()
  def parse_instr(inp) do
    strs = inp
      |> String.split("=", parts: 2)
      |> Enum.map(&to_charlist/1)

    case strs do
      [c]    -> {:remove, Enum.drop(c, -1)}
      [k, [v]] -> {:add, Lens.new(k, v - ?0)}
      o      -> raise "Parse instruction error on #{inp}"
    end
  end

  #### API #####################################################################

  @spec get_lens_scores(holiday_hashmap()) :: integer()
  def get_lens_scores(map) do
    map
    |> Enum.map(fn
      {box_num, lenses} ->
        lenses
        |> Enum.with_index
        |> Enum.reduce(0, fn
          ({%Lens{ focal_length: focal_length }, idx}, acc) ->
            ((1 + box_num) * (1 + idx) * focal_length) + acc
          end
        )
    end)
    |> Enum.sum
  end

  @spec run_hm_steps(holiday_hashmap(), list(hm_step())) :: holiday_hashmap()
  def run_hm_steps(map \\ %{}, steps)
  def run_hm_steps(map, []), do: map
  def run_hm_steps(map, [s | steps]) do
    run_hm_steps(do_hm_step(map, s), steps)
  end

  @spec do_hm_step(holiday_hashmap(), hm_step()) :: holiday_hashmap()
  def do_hm_step(map, {:add, lens}) do
    Map.update(map, hash(lens.label), [lens],
      fn vals -> upsert_lens(lens, vals) end
    )
  end
  def do_hm_step(map, {:remove, key}) do
    Map.update(map, hash(key), [],
      fn vals -> Enum.filter(vals, fn %Lens{ label: k } -> k !== key end) end
    )
  end

  @spec upsert_lens(Lens.t(), list(Lens.t())) :: list(Lens.t())
  def upsert_lens(l, []), do: [l]
  def upsert_lens(l, [h | t]) when l.label == h.label, do: [l | t]
  def upsert_lens(l, [h | t]), do: [h | upsert_lens(l, t)]

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
