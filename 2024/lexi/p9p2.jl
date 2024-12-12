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
  files = reverse(filter(f -> typeof(f) === File, disk))
  # println(files)
  for file_to_try_to_move in files
    empty_spaces_needed = file_to_try_to_move.num_blocks
    idx = findfirst(f -> typeof(f) === File && f.id === file_to_try_to_move.id, disk)
    first_empty_space_available_to_fit = findfirst(f -> typeof(f) === EmptySpace && f.num_blocks >= empty_spaces_needed, disk)
    if first_empty_space_available_to_fit !== nothing && first_empty_space_available_to_fit < idx
      # println("Swap $file_to_try_to_move and $first_empty_space_available_to_fit")

      empty_to_swap = EmptySpace(file_to_try_to_move.num_blocks)
      og_empty = disk[first_empty_space_available_to_fit]
      disk[idx] = empty_to_swap
      disk[first_empty_space_available_to_fit] = file_to_try_to_move
      if og_empty.num_blocks > file_to_try_to_move.num_blocks
        num_extra_spaces = og_empty.num_blocks - file_to_try_to_move.num_blocks
        # println("Need to add an extra space of $num_extra_spaces")
        new_empty_slots = EmptySpace(num_extra_spaces)
        # print_disk(disk)
        insert!(disk, first_empty_space_available_to_fit + 1, new_empty_slots)
        # print_disk(disk)
        # println("=========")
      end
      # print_disk(disk)
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

  # print_disk(disk)
  # display(disk)
  println(checksum(disk))
end

function print_disk(disk)
  for i in disk
    if typeof(i) === EmptySpace
      for j in 1:i.num_blocks
        print(".")
      end 
    else
      for j in 1:i.num_blocks
        print(i.id)
      end 
    end
  end
  println()
end
run_me()

# 00...111...2...333.44.5555.6666.777.888899
# 0099.111...2...333.44.5555.6666.777.8888..
# 0099.1117772...333.44.5555.6666.....8888..
# 0099.111777244.333....5555.6666.....8888..
# 00992111777.44.333....5555.6666.....8888..

