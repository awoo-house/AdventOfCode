before_rules::Dict{Int, Set{Int}} = Dict()
after_rules::Dict{Int, Set{Int}} = Dict()

function add_ordering(p1::Int, p2::Int, dict::Dict) 
  if haskey(dict, p1)
    push!(dict[p1], p2)  # Append to existing set
  else
      dict[p1] = Set(p2)  # Create a set vector for the key
  end
end

function fix_row(r::Vector{Int})
  fixed_row = []
  try_again = Set()
  function add_next(s) 
    must_come_before = intersect(get!(after_rules, s, Set()), r)
    if !isempty(must_come_before)

    else 
      push!(try_again, s)
    end
  end
end

function check_row(r::Vector{Int})
  max_index = length(r)
  for checking_index in 1:max_index
    come_before::Set{Int} = Set()
    this_val = r[checking_index]
    for against_index in 1:checking_index-1
      push!(come_before, r[against_index])
    end
    
    must_come_before = intersect(get!(after_rules, this_val, Set()), r)
    if must_come_before != come_before
      println("$this_val requires that $must_come_before be before it... but only $come_before were. ")
      # part 1
      return 0
      # end part 1
      # part 2
      # TODO: Figure out the correct order

      

      # end part 2
    else
      # part 1
      # end part 1
      # part 2
      # return 0
      # end part 2
    end
    
  end

  middle_index = (max_index + 1)//2

  ret = r[numerator(middle_index)]
  println("Row $r is valid!! Returning $ret")
  ret

end

function run_me() 
  input = open(io->read(io, String), "inputs/5.txt")
  s = split(input, "\n")
  
  total_middle_index_sums = 0
  for r in s
    did_split = split(r, "|")
    if length(did_split) === 2
      before = parse(Int, did_split[1])
      after = parse(Int, did_split[2])
      add_ordering(before, after, before_rules)
      add_ordering(after, before, after_rules)
    elseif contains(r, ",")
      println("Need to check now for $r")
      v = map(f -> parse(Int, f), split(r, ","))
      total_middle_index_sums += check_row(v)
    else
      println("Starting to check with before rules:")
      display(before_rules)
      println("And after rules:")
      display(after_rules)
    end
  end

  println("Answer: $total_middle_index_sums")
  

end

run_me()
