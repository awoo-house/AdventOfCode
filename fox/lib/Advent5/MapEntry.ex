defmodule Advent5.MapEntry do
  # Hm... https://stackoverflow.com/a/47501059
  alias __MODULE__

  @enforce_keys [:source_start, :dest_start, :length]
  defstruct [:source_start, :dest_start, :length]

  @type t() :: %Advent5.MapEntry{}
end

defimpl Inspect, for: Advent5.MapEntry do
  def inspect(entry, opts) do
    "Entry(#{entry.source_start} -> #{entry.dest_start} len: #{entry.length})"
  end
end
