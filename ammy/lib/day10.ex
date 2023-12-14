defmodule AmmyTen do
  defmodule Coord do
    defstruct [:col, :row]
  end

  def find_start(map) do
    # assume that we find it, and there's not like, no S or anything
    Enum.with_index(map)
    |> Enum.reduce(nil, fn {row, row_index}, acc ->
      case acc do
        nil ->
          case Enum.find_index(row, fn el -> el == "S" end) do
            nil -> nil
            col_index -> {row_index, col_index}
          end

        _ ->
          acc
      end
    end)
  end

  def process_queue(q, dists, map, connections) do
    if length(q) == 0 do
      dists
    else
      {dist, q} = List.pop_at(q, 0)
      {{col, row}, q} = List.pop_at(q, 0)
      coord = %Coord{col: col, row: row}
      val = Map.get(dists, coord)

      if val == nil do
        new_dists = Map.put(dists, coord, dist)
        connector_at_pos = Enum.at(map, row) |> Enum.at(col)
        connects_to = Map.get(connections, connector_at_pos)

        new_q =
          Enum.reduce(connects_to, q, fn {dy, dx}, queue ->
            queue ++ [dist + 1, {dy + col, dx + row}]
          end)

        process_queue(new_q, new_dists, map, connections)
      else
        process_queue(q, dists, map, connections)
      end
    end
  end

  def process(map) do
    connections = %{
      "|" => [{0, -1}, {0, 1}],
      "-" => [{-1, 0}, {1, 0}],
      "L" => [{0, -1}, {1, 0}],
      "J" => [{0, -1}, {-1, 0}],
      "7" => [{-1, 0}, {0, 1}],
      "F" => [{1, 0}, {0, 1}]
    }

    {row, col} = find_start(map)

    offsets = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

    shitty_queue =
      Enum.reduce(offsets, [], fn {dx, dy}, acc ->
        c =
          Enum.fetch(map, row + dy)
          |> case do
            {:ok, row_values} -> Enum.fetch(row_values, col + dx)
            _ -> {:error, nil}
          end

        case c do
          {:ok, cell} ->
            new_coords =
              Enum.filter(Map.get(connections, cell), fn {dx2, dy2} ->
                col == col + dx + dx2 && row == row + dy + dy2
              end)

            if length(new_coords) > 0 do
              [1, {col + dx, row + dy} | acc]
            else
              acc
            end

          _ ->
            acc
        end
      end)

    dists = %{%Coord{col: col, row: row} => 0}

    process_queue(shitty_queue, dists, map, connections)
  end

  # seven arguments is a reasonable number yes
  # owo
  def fill_insides(map, dists, row_idx, col_idx, max_width, max_height, crosses) do
    if row_idx >= max_height or col_idx >= max_width do
      crosses
    else
      connector = Enum.at(map, row_idx) |> String.at(col_idx)
      coord = %Coord{col: col_idx, row: row_idx}
      val = Map.get(dists, coord)

      if val != nil and connector != "7" and connector != "L" do
        fill_insides(map, dists, row_idx + 1, col_idx + 1, max_width, max_height, crosses + 1)
      else
        fill_insides(map, dists, row_idx + 1, col_idx + 1, max_width, max_height, crosses)
      end
    end
  end

  def run do
    case File.read("input/day10.in") do
      {:ok, input} ->
        lines = String.split(input)

        dists =
          lines
          |> Enum.map(&String.graphemes/1)
          |> process()

        # part one
        dists
        |> Map.values()
        |> Enum.max()
        |> IO.inspect()

        width = List.first(lines) |> String.length()
        height = length(lines)

        lines
        |> Enum.with_index()
        |> Enum.map(fn {line, row_idx} ->
          String.graphemes(line)
          |> Enum.with_index()
          |> Enum.reduce(0, fn {_, col_idx}, acc ->
            coord = %Coord{col: col_idx, row: row_idx}
            val = Map.get(dists, coord)

            if val == nil do
              crosses = fill_insides(lines, dists, row_idx, col_idx, width, height, 0)

              if rem(crosses, 2) == 1 do
                acc = acc + 1
              else
                acc
              end
            else
              acc
            end
          end)
        end)
        |> Enum.sum()
        |> IO.inspect()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
