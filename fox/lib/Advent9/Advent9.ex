defmodule Advent9 do

  def diff(a) do
    Enum.drop(a, 1)
    |> Enum.zip(a)
    |> Enum.map(fn {a, b} -> a - b end)
  end

  def diff_pyr(a) do
    diffs = Stream.unfold(a,
      fn ls ->
        out = diff(ls)
        if Enum.all?(out, &(&1==0))
          do nil
          else { out, out }
        end
      end)
      |> Enum.to_list()

    [a | diffs]
  end

  @doc """
  The diffs need to be REVERSE SORTED!!!
  """
  def linear_guess(diffs, last \\ 0)
  def linear_guess([], _), do: []
  def linear_guess([diff | diffs], last) do
    next_diff = List.last(diff) + last
    [next_diff | linear_guess(diffs, next_diff)]
  end

  def linear_guess_b(diffs, last \\ 0)
  def linear_guess_b([], _), do: []
  def linear_guess_b([[diff | _] | diffs], last) do
    next_diff = diff - last
    # IO.puts("#{next_diff} | #{inspect [diff | ds]}")
    [next_diff | linear_guess_b(diffs, next_diff)]
  end

  @spec calculate_diff(list(integer()), (list(integer()) -> integer())) :: integer()
  def calculate_diff(inp, guesser \\ &linear_guess/1) do
    diff_pyr(inp)
    |> Enum.reverse
    |> then(fn x -> guesser.(x) end)
    |> List.last
    # |> Enum.sum
  end

  @spec process_line(String.t()) :: list(integer())
  def process_line(inp) do
    Regex.scan(~r/(-?[0-9]+) */, inp, capture: :all_but_first)
    |> List.flatten()
    |> Enum.map(fn num ->
      case Integer.parse(num) do
        { n, _ } -> n
        :error -> throw "Could not parse '#{num}'!!!"
      end
    end)
  end

  @spec process_input(String.t()) :: list(list(integer()))
  def process_input(inp) do
    String.split(inp, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn l -> String.length(l) > 0 end)
    |> Enum.map(&process_line/1)
  end

  def run do
    case File.read("./lib/Puzz9.input.txt") do
      { :ok, inp } ->
        out = process_input(inp)
              # |> Enum.map(&calculate_diff/1)
              |> Enum.map(fn x -> calculate_diff(x, &linear_guess_b/1) end)
              |> Enum.sum

        IO.puts(out)

      { :error, err } -> raise "Could not read file because: #{err}."
    end
  end
end
