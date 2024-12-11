function create_disk(input)
  is_file = true
  cur_file_id = 0
  disk = []
  for c in input
    val = parse(Int, c)
    cur_marker = -1
    if (is_file)
      cur_marker = cur_file_id
      cur_file_id += 1
    end
    for i in 1:val
      push!(disk, cur_marker)
    end
    is_file = !is_file
  end
  disk
end

function print_disk(disk)
  for i in disk
    print(i)
  end
  println()
end

function defrag!(disk)
  forwards_idx = 1
  backwards_idx = length(disk)
  ids_moved = Set()
  currently_moving_id = ""
  while (backwards_idx >= 1 && forwards_idx <= length(disk) && backwards_idx > forwards_idx)
    # is the backwards_idx a number we need to move?
    bk = disk[backwards_idx]
    if bk === -1
      # Empty space, move backwards!
      backwards_idx -= 1
      continue
    else
      if bk ∈ ids_moved && bk !== currently_moving_id
        break
      end
    end
    
    # Okay, we need to move bk to the first available flee slot
    fn = disk[forwards_idx]
    if fn !== -1
      forwards_idx += 1
    else
      # Okay! Time to swap!
      disk[backwards_idx] = fn
      disk[forwards_idx] = bk
      push!(ids_moved, bk)
      currently_moving_id = bk
      # print_disk(disk)
    end
  end 

end

function checksum(disk)
  acc = 0
  for i in eachindex(disk)
    if disk[i] === -1
      continue
    end 
    acc += disk[i] * (i-1)
  end
  acc
end
function run_me() 
  input = open(io->read(io, String), "inputs/9.txt")
  disk = create_disk(input)
  # print_disk(disk)
  defrag!(disk)
  println(checksum(disk))
end

run_me()
