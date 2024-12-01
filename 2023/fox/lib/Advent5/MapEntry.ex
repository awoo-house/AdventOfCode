defmodule Advent5.MapEntry do
  @enforce_keys [:source_start, :dest_start, :length]
  defstruct [:source_start, :dest_start, :length]

  @type t() :: %Advent5.MapEntry{}
end

defimpl Inspect, for: Advent5.MapEntry do
  def inspect(entry, _opts) do
    "Entry(#{entry.source_start} -> #{entry.dest_start} len: #{entry.length})"
  end
end
