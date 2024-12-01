defmodule Advent16.Beam do
  defstruct [:position, :velocity]

  alias Advent16.Coord
  import Advent16.Coord, only: [+++: 2]

  @north Coord.new(0, 1)
  @south Coord.new(0, -1)
  @east  Coord.new(1, 0)
  @west  Coord.new(-1, 0)

  @type t() :: %Advent16.Beam{ position: Coord.t(), velocity: Coord.t() }

  @type tile() :: ?. | ?\\ | ?/ | ?- | ?|

  @spec new(Coord.t(), Coord.t()) :: t()
  def new(position \\ Coord.new(0, 0), velocity \\ Coord.new(0, 1)) do
    %Advent16.Beam{ position: position, velocity: velocity }
  end

  @spec step(t(), tile()) :: t() | {t(), t()}
  def step(%Advent16.Beam{ position: pos, velocity: vel }, tile) do
    new_vels =
      case tile do
        ?. -> vel
        ?/ ->
          Coord.mult(vel, [[0, 1],
                           [1, 0]])

        ?\\ ->
          Coord.mult(vel, [[0, -1],
                           [-1, 0]])

        ?| ->
          vela = Coord.mult(vel, [[0, 1],
                                  [1, 0]])
          velb = Coord.mult(vel, [[0,  1],
                                  [-1, 0]])

          {vela, velb}

        ?- ->
          vela = Coord.mult(vel, [[0, 1],
                                  [1, 0]])
          velb = Coord.mult(vel, [[0, -1],
                                  [1, 0]])

          {vela, velb}
      end

    case new_vels do
      {vela, velb} when vela == velb -> new(pos +++ vel, vel)
      {vela, velb} -> {new(pos +++ vela, vela), new(pos +++ velb, velb)}
      vel -> new(pos +++ vel, vel)
    end
  end

end
