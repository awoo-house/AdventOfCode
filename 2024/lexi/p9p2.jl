function create_disk(input)
  is_file = true
  cur_file_id = 0
  disk = []
  for c in input
    val = parse(Int, c)
    cur_marker = EmptySpace(val)
    if (is_file)
      cur_marker = File(val, cur_file_id)
      cur_file_id += 1
    end
    push!(disk, cur_marker)
    is_file = !is_file
  end
  disk
end

struct File
  num_blocks::Int
  id::Int
end

struct EmptySpace
  num_blocks::Int
end

function defrag!(disk)
  l = length(disk)
  for i in eachindex(disk)
    idx_to_check = l - i + 1
    if typeof(disk[idx_to_check]) === EmptySpace
      continue
    else
      file_to_try_to_move::File = disk[idx_to_check]
      empty_spaces_needed = file_to_try_to_move.num_blocks
      first_empty_space_available_to_fit = findfirst(f -> typeof(f) === EmptySpace && f.num_blocks >= empty_spaces_needed, disk)
      if first_empty_space_available_to_fit !== nothing
        # println("Swap $file_to_try_to_move and $first_empty_space_available_to_fit")
        disk[idx_to_check] = disk[first_empty_space_available_to_fit]
        disk[first_empty_space_available_to_fit] = file_to_try_to_move
      end
    end

  end
end

function checksum(disk)
  acc = 0
  logical_idx = 0
  for i in disk
    if typeof(i) === EmptySpace
      logical_idx += i.num_blocks
      continue
    end 
    for _ in 1:i.num_blocks
      acc += i.id * logical_idx
      logical_idx += 1
    end
  end
  acc
end
function run_me() 
  input = open(io->read(io, String), "inputs/9.txt")
  disk = create_disk(input)
  # display(disk)
  # print_disk(disk)
  defrag!(disk)
  # display(disk)
  println(checksum(disk))
end

run_me()
