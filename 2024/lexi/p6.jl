
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

using DelimitedFiles


function turn(current_fun)
  if current_fun === move1left
    move1up
  elseif current_fun === move1up
    move1right
  elseif current_fun === move1right
    move1down
  else
    move1left
  end
end


function has_left_map(curX, curY, map)
  maxX, maxY = size(map)
  curX > maxX || curY > maxY || curX < 1 || curY < 1 
end


function move_until_out_of_map(start_pos, map)
  
  steps = 0
  visited_tiles = Set()
  curX = start_pos[1] 
  curY = start_pos[2]
  current_move_fn = move1up



  while !has_left_map(curX, curY, map)
    push!(visited_tiles, (curX, curY))
    nextX = copy(curX)
    nextY = copy(curY)
    steps = 0
    while (nextX, nextY) == (curX, curY)
      steps += 1
      if steps > 5
        "ERROR: Too many steps..."
        return
      end
      
      nextX, nextY = current_move_fn(curX, curY)
      
      if !has_left_map(nextX, nextY, map) && map[nextX, nextY] === '#'
        # println("Hit a wall! Turning...")
        current_move_fn = turn(current_move_fn)
        # println("New forward function = $current_move_fn")
        nextX = curX
        nextY = curY
      end
      # println("Now at ($nextX, $nextY)")
    end
    curX = nextX
    curY = nextY

  end
  visited_tiles

end
function run_me()
  data = readdlm("./inputs/6.txt", String)
  mat = map(collect, data)
  mat = hcat(mat...)
  display(mat)

  start_pos = findfirst(==('^'), mat)
  visited = move_until_out_of_map(start_pos, mat)
  println("# Tiles visited: $(length(visited))")
end

run_me()