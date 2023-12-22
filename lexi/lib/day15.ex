defmodule Day15 do

  def tokenize(strs, ["="|rest]), do: [:eq_sym| [strs|tokenize(rest)]]

  def tokenize(strs, ["-"]), do: [:minus_sym,strs]
  def tokenize(strs, ["-"|rest]), do: [:minus_sym|[strs|tokenize(rest)]]
  def tokenize(strs, [","|rest]), do: [strs|tokenize(rest)]
  def tokenize(strs, [next_char|rest]), do: tokenize(strs <> next_char, rest)
  def tokenize(strs, []), do: [strs]

  def tokenize([]), do: []
  def tokenize([","|rest]), do: tokenize(rest)
  def tokenize([first_char|rest]), do: tokenize(first_char, rest)

  def tokenize(input) do
    String.replace(input, "\n", "")
    |> String.graphemes
    |> tokenize
  end


  def parse([:eq_sym, hashed_box, focal_length | rest]) do
    {v, _} = Integer.parse(focal_length)
    [{hash(hashed_box), :add, {hashed_box, v}} | parse(rest)]
  end

  def parse([:minus_sym, hashed_box | rest]) do
    [{hash(hashed_box), :remove, hashed_box} | parse(rest)]
  end
  def parse([]), do: []

  def hash(str) do
    String.to_charlist(str)
    |> Enum.reduce(0, fn c, acc ->
      a = acc + c
      b = a * 17
      c = rem(b, 256)
      c
    end)
  end

  def run_instructions(state, [{box_num, :add, box_to_add} | rest]) do
    Map.update(state, box_num, [box_to_add], fn existing ->
      {label, _lens} = box_to_add
      max_idx = Enum.count(existing) - 1
      case Enum.find_index(existing, fn {l, _} -> l == label end) do
        nil -> existing ++ [box_to_add]
        0 -> [box_to_add | Enum.slice(existing, (1..max_idx))]
        idx when idx == max_idx -> Enum.slice(existing, (0..max_idx - 1)) ++ [box_to_add]
        idx ->
          a = Enum.slice(existing, (0..idx-1))
          b = Enum.slice(existing, (idx+1..max_idx))
          a ++ [box_to_add] ++ b
      end
    end)
    |> run_instructions(rest)
  end

  def run_instructions(state, [{box_num, :remove, box_to_remove} | rest]) do
    Map.update(state, box_num, [], fn existing ->
      Enum.filter(existing, fn {box, _} -> box != box_to_remove end)
    end)
    |> run_instructions(rest)
  end

  def run_instructions(state, []), do: state
  def run_instructions(ins), do: run_instructions(Map.new(), ins)

  def sum_state(state) do
    Enum.reduce(state, 0, fn {box_num, lenses}, acc ->
      acc + Enum.reduce(Enum.with_index(lenses, 1), 0, fn {{lens_name, focal_length}, slot_num}, ac ->
        box_n = box_num + 1
        to_add = box_n * slot_num * focal_length
        IO.puts("#{lens_name}: #{box_n} (box #{box_num}) * #{slot_num}(xxx slot) * #{focal_length} (focal length) = #{to_add}")
        ac + to_add
      end)
    end)
  end

  # --- part 1
  # def sum_instructions(ins) do
  #   Enum.reduce(ins, 0, fn i, acc ->
  #     acc + hash(i)
  #   end)
  # end

  # def parseP1(input) do
  #   String.replace(input, "\n", "")
  #   |> String.split(",", trim: true)
  # end
  # ----------

  def run do
    case File.read("./lib/inputs/day15.txt") do
      {:ok, input} -> input
        |> tokenize
        |> parse
        |> run_instructions
        |> sum_state
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
