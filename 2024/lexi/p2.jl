using DelimitedFiles

@enum Direction up down

struct RowState
  direction::Direction
  last_value::Int
end

function is_valid_row(row)
  
end

function run() 
  data = readdlm("./inputs/3.txt", Int)
  validity_mat = mapslices(is_valid_row, data; dims=2)
end

run()