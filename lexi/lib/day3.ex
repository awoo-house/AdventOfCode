defmodule Day3 do

  def parse_map(input) do
    String.split(input)
    |> Enum.with_index()
    |> Enum.flat_map(fn { line, y_index } ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn { char, x_index } ->
        { {x_index, y_index}, { char, char } }
      end)
    end)
    |> Map.new()

  end

  def gear_indices_in_map(map) do
    Enum.filter(map, fn { {_x, _y}, { char, _id }} ->
      case char do
        "*" -> true
        _ -> false
      end
    end)
  end

  def process(map) do
    initial = [
      {:digits_surrounded_by_symbols, []},
      {:digits_so_far, ""},
      {:last_x, -1},
      {:last_y, -1},
      {:map, map}
    ]
    map
    |> Enum.sort_by(fn {{x, y}, {_char, _id}} -> {y, x} end)
    |> Enum.reduce(initial, fn {{x, y}, {char, _id}}, acc ->

      is_digit? = case char do
        "1" -> true
        "2" -> true
        "3" -> true
        "4" -> true
        "5" -> true
        "6" -> true
        "7" -> true
        "8" -> true
        "9" -> true
        "0" -> true
        _ -> false
      end

      { dap, up_map } = if not is_digit? and acc[:digits_so_far] != "" do
        len_if_this_number = String.length(acc[:digits_so_far])

        { number_of_this_number, _} = Integer.parse(acc[:digits_so_far])

        updated_map = Enum.to_list(0..(len_if_this_number - 1))
        |> Enum.map(fn x -> { acc[:last_x]-x, acc[:last_y] } end)
        |> Enum.reduce(acc[:map], fn idx, acc_map -> Map.put(acc_map, idx, { number_of_this_number, "#{acc[:last_x]} - #{acc[:last_y]}"}) end)

        p = get_perimeter_indices(map, acc[:digits_so_far], {acc[:last_x], acc[:last_y]})
        {number, {_, _}, _} = List.first(p)
        is_any_symbol = Enum.any?(p, fn {_number, {_x, _y}, {char, _id}} ->
          case char do
            nil -> false
            "1" -> false
            "2" -> false
            "3" -> false
            "4" -> false
            "5" -> false
            "6" -> false
            "7" -> false
            "8" -> false
            "9" -> false
            "0" -> false
            "." -> false
            _ -> true
          end
        end)

        if is_any_symbol do
          { acc[:digits_surrounded_by_symbols] ++ [number], updated_map }
        else
          { acc[:digits_surrounded_by_symbols], updated_map }
        end
      else
        { acc[:digits_surrounded_by_symbols], acc[:map] }
      end


      digits = if is_digit? do
        if acc[:last_y] == y and acc[:last_x] == x - 1 do
          acc[:digits_so_far] <> char
        else
          char
        end
      else
        ""
      end
      [
        {:digits_surrounded_by_symbols, dap},
        {:digits_so_far, digits},
        {:last_x, x},
        {:last_y, y},
        {:map, up_map}
      ]
    end)
    # |> Enum.find(fn {key, _val} -> key == :digits_surrounded_by_symbols end)
    # |> elem(1)

  end

  def get_perimeter_indices(map, number, index_of_final_digit) do
    # IO.inspect(number)
    len = String.length(number)

    {num, _} = Integer.parse(number)

    {fdx, fdy} = index_of_final_digit
    Enum.to_list(0..(len - 1))
    |> Enum.map(fn x -> { fdx-x, fdy } end) # A list of all the indices of the digits in this number
    |> Enum.flat_map(fn {x, y} -> [
      { x-1, y+1 },
      { x-1, y },
      { x-1, y-1 },
      { x, y+1 },
      { x, y-1 },
      { x+1, y+1 },
      { x+1, y },
      { x+1, y-1 },
    ] end)
    |> Enum.filter(fn idx -> Map.get(map, idx) end)
    |> Enum.map(fn idx -> {num, idx, Map.get(map, idx)} end)
  end


  def get_gear_ratios(proc) do
    gear_indices_in_map(proc[:map])
    |> Enum.map(fn {idx, _} -> get_perimeter_indices(proc[:map], "0", idx) end)
    |> Enum.map(fn gears ->
      Enum.uniq_by(gears, fn {_, {_, _}, {_number, id}} -> id end)
      |> Enum.filter( fn {_, {_, _}, {number, _id}} -> is_number(number) end)
      |> Enum.map(fn {_, {_x, _y}, {number, _id}} -> number end)
    end)
    |> Enum.filter(fn gears -> length(gears) == 2 end)
    |> Enum.map(fn gears ->
      Enum.reduce(gears, 1, fn x, acc -> x * acc end)
    end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  def runP1 do
    case File.read("./lib/inputs/day3.txt") do
      {:ok, input} -> parse_map(input)
        |> process
        # |> Enum.each(fn x -> IO.inspect(x) end)
        |> Enum.reduce(0, fn x, acc -> x + acc end)
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end

  def runP2 do
    case File.read("./lib/inputs/day3.txt") do
      {:ok, input} -> parse_map(input)
        |> process
        |> get_gear_ratios
        |> IO.inspect
      {:error, reason} -> IO.write(reason)
    end
  end
end
