using DelimitedFiles

@enum direction up left down right upleft downright upright downleft

function move1up(x::Int64, y::Int64)
  (x, y - 1)
end
function move1right(x::Int64, y::Int64)
  (x + 1, y)
end
function move1left(x::Int64, y::Int64)
  (x - 1, y)
end
function move1down(x::Int64, y::Int64)
  (x, y + 1)
end
function move1upright(x::Int64, y::Int64)
  (x + 1, y - 1)
end
function move1downleft(x::Int64, y::Int64)
  (x - 1, y + 1)
end
function move1upleft(x::Int64, y::Int64)
  (x - 1, y - 1)
end
function move1downright(x::Int64, y::Int64)
  (x + 1, y + 1)
end

# part 2
function check_for_x_mas(m::Matrix, Ax, Ay)
  max_x, max_y = size(m)
  if Ax === max_x || Ay === max_y || Ax === 1 || Ay === 1
    []
  else
    show("($Ax, $Ay) -> ")
    bsX1, bsY1 = move1upright(Ax, Ay)
    bsX2, bsY2 = move1downleft(Ax, Ay)


    fsX1, fsY1 = move1upleft(Ax, Ay)
    fsX2, fsY2 = move1downright(Ax, Ay)

    backslash_chars = (m[bsX1, bsY1], m[bsX2, bsY2])
    frontslash_chars = (m[fsX1, fsY1], m[fsX2, fsY2])

    println([backslash_chars;frontslash_chars])
    if 'M' in backslash_chars && 'S' in backslash_chars &&
      'M' in frontslash_chars && 'S' in frontslash_chars
      [(Ax, Ay), (bsX1, bsY1), (bsX2, bsY2), (fsX1, fsY1), (fsX2, fsY2)]
    else 
      []
    end
  end
end

# part 1
function check_for_xmas(m::Matrix, Xx, Xy, dir_fn)
  max_x, max_y = size(m)
  # println("Starting at ($Xx, $Xy), and calling $dir_fn...")
  Mx, My = dir_fn(Xx, Xy)
  Ax, Ay = dir_fn(Mx, My)
  Sx, Sy = dir_fn(Ax, Ay)

  # Are we still within the bounds of the matrix?
  if Sx > max_x || Sx < 1 || Sy > max_y || Sy < 1
    # println("We're outside the bounds!")
    []
  elseif m[Mx, My] === 'M' && m[Ax, Ay] === 'A' && m[Sx, Sy] === 'S'
    # println("We found a match!")
    [(Xx, Xy), (Mx, My), (Ax, Ay), (Sx, Sy)]
  else
    # println("No match!")
    []
  end
end

using Base.Iterators

function flat(a)
  collect(flatten([arr for arr in a if !isempty(arr)]))
end

function part2(mat)
  as = findall(==('A'), mat)
  ass = map(f -> check_for_x_mas(mat, f[1], f[2]), as)
  flat(ass)
end

function part1(mat)  
  xs = findall(==('X'), mat)
  dirs = [move1up move1left move1down move1right move1upleft move1downright move1upright move1downleft]


  function try_direction(point::CartesianIndex, d)
    Xx = point[1]
    Xy = point[2]
    check_for_xmas(mat, Xx, Xy, d)
  end

  function try_point(point::CartesianIndex)
    map(f -> try_direction(point, f), dirs)
  end

  xss = map(try_point, xs)

  function flat(a)
    collect(flatten([arr for arr in a if !isempty(arr)]))
  end

  flat(flat(xss))
  

end

function runme()
  data = readdlm("./inputs/4.txt", String)
  mat = map(collect, data)
  mat = hcat(mat...)
  answer = part2(mat)
  visualized = copy(mat)

  rows, cols = size(visualized)
  for i in 1:rows
      for j in 1:cols
          if !((i, j) in answer)
              visualized[i, j] = '.'
          end
      end
  end

  display(visualized)
  show("Answer:")
  println(length(answer) / 5)
  
end
runme()