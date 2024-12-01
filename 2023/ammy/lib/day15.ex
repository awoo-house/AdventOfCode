defmodule AmmyFifteen do
  def cool_hash_of_char(char, init_val) do
    # Determine the ASCII code for the current character of the string.
    # Increase the current value by the ASCII code you just determined.
    # Set the current value to itself multiplied by 17.
    # Set the current value to the remainder of dividing itself by 256.
    <<v::utf8>> = char
    rem((init_val + v) * 17, 256)
  end

  def run do
    case File.read("input/day15.in") do
      {:ok, gigantic_string} ->
        boxes =
          Enum.reduce(0..255, %{}, fn i, acc ->
            # don't be like Past Ammy and assume that maps are ordered
            Map.put(acc, i, [])
          end)

        filled_boxes =
          gigantic_string
          |> String.split(",")
          |> Enum.reduce(boxes, fn s, acc ->
            maybe_minus = s |> String.split("-")
            maybe_equals = s |> String.split("=")
            # minus; we're making the assumption that the input is well-formed
            if length(maybe_equals) == 2 do
              label = maybe_equals |> List.first()
              {val, _} = maybe_equals |> List.last() |> Integer.parse()

              score =
                label
                |> String.graphemes()
                |> Enum.reduce(0, fn c, acc2 ->
                  cool_hash_of_char(c, acc2)
                end)

              lenses = Map.get(acc, score)

              acc =
                case Enum.find_index(lenses, fn t -> elem(t, 0) == label end) do
                  nil ->
                    Map.update(acc, score, [{label, val}], &List.insert_at(&1, -1, {label, val}))

                  index ->
                    lenses = List.replace_at(lenses, index, {label, val})
                    Map.put(acc, score, lenses)
                end

              acc
            else
              label = maybe_minus |> List.first()

              score =
                label
                |> String.graphemes()
                |> Enum.reduce(0, fn c, acc2 ->
                  cool_hash_of_char(c, acc2)
                end)

              # the second element is the empty string, which we can ignore
              acc = Map.update(acc, score, nil, &Enum.reject(&1, fn {el, _} -> el == label end))
              acc
            end
          end)

        filled_boxes
        |> Enum.reduce(0, fn {box, lenses}, acc ->
          ans =
            lenses
            |> Enum.with_index()
            |> Enum.reduce(0, fn {{_, focal_length}, index}, acc2 ->
              acc2 + (box + 1) * (index + 1) * focal_length
            end)

          acc + ans
        end)
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
