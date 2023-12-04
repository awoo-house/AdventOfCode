defmodule Advent1Puzz1 do

  @spec tokenize(String.t()) :: [integer()]
  def tokenize("")              do [] end
  def tokenize("one"   <> rest) do [1 | tokenize("ne"   <> rest)] end
  def tokenize("two"   <> rest) do [2 | tokenize("wo"   <> rest)] end
  def tokenize("three" <> rest) do [3 | tokenize("hree" <> rest)] end
  def tokenize("four"  <> rest) do [4 | tokenize("our"  <> rest)] end
  def tokenize("five"  <> rest) do [5 | tokenize("eiv"  <> rest)] end
  def tokenize("six"   <> rest) do [6 | tokenize("ix"   <> rest)] end
  def tokenize("seven" <> rest) do [7 | tokenize("even" <> rest)] end
  def tokenize("eight" <> rest) do [8 | tokenize("ight" <> rest)] end
  def tokenize("nine"  <> rest) do [9 | tokenize("ine"  <> rest)] end
  def tokenize(nums) do
    first = String.first(nums)
    rest = String.slice(nums, (1..(String.length(nums))))
    case Integer.parse(first) do
      {n, _} -> [n | tokenize(rest)]
      :error -> tokenize(rest)
    end
  end

  def processLine(line, ln_no \\ 0) do
    tokenize(line)
    |> then(
      fn
        ([n]) -> {n, n*10 + n}
        ([n | r]) -> {[n | r], n*10 + List.last(r)}
      end)
    |> then(fn {inp, out} ->
      IO.puts("#{ln_no}: " <> inspect(inp, charlists: :as_lists) <> " -> " <> inspect(out))
      out
    end)
  end


  def findNumbers(inp) do
    Enum.with_index(String.split(String.trim(inp), "\n"))
    |> Enum.map(fn
      {s, idx} -> processLine(String.trim(s), idx + 1)
    end)
    |> Enum.reduce(fn
      (a, b) -> a + b
    end)
  end


  def run do
    case File.read("./lib/Puzz1.input.txt") do
      {:error, reason} -> IO.puts("File read failed because: " <> reason)
      {:ok, input} ->
        IO.puts(findNumbers(input))
    end

  end
end
