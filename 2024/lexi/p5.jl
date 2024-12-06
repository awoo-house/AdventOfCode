before_rules::Dict{Int, Set{Int}} = Dict()
after_rules::Dict{Int, Set{Int}} = Dict()

function add_ordering(p1::Int, p2::Int, dict::Dict) 
  if haskey(dict, p1)
    push!(dict[p1], p2)  # Append to existing set
  else
      dict[p1] = Set(p2)  # Create a set vector for the key
  end
end


function check_row(r::Vector{Int})
  # println("Checking $r")
  max_index = length(r)
  had_to_fix = false
  for checking_index in 1:max_index
    come_before::Set{Int} = Set()
    this_val = r[checking_index]
    for against_index in 1:checking_index-1
      push!(come_before, r[against_index])
    end
    
    must_come_before = intersect(get!(after_rules, this_val, Set()), r)
    if must_come_before != come_before
      # println("$this_val requires that $must_come_before be before it... but only $come_before were. ")
      # part 1
      # return 0
      # end part 1
      # part 2
      # TODO: Figure out the correct order
      r = fix_row(r)
      had_to_fix = true
      break

      # end part 2
    else
      # part 1
      # end part 1
      # part 2
      # end part 2
    end
    
  end

  if !had_to_fix
    0
  else
    middle_index = (max_index + 1)//2

    ret = r[numerator(middle_index)]
    ret
  end

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
      # println("Need to check now for $r")
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

import Pkg
# Pkg.add("JuMP")
# Pkg.add("HiGHS")
using JuMP
using HiGHS

function fix_row(r::Vector{Int})
  # println("Fixing $r")
  model = Model(HiGHS.Optimizer)
  set_silent(model)
  num_indexes = length(r)
  indices = Dict()
  vars = Dict()
  @variable(model, vars[1:num_indexes])
  
  for i in 1:num_indexes
    this_val = r[i]
    indices[this_val] = i
    @constraint(model, 1 <= vars[i] <= num_indexes)
  end
  # Minimize total diffs in indices
  @objective(model, Min, sum((vars[i] - i)^2 for i in 1:num_indexes))
  for i in 1:num_indexes
    this_val = r[i]
    
    must_come_before = intersect(get!(before_rules, this_val, Set()), r)
    for b in must_come_before
      var_index_of_b = indices[b]
      @constraint(model,vars[var_index_of_b] -  vars[i]  >= 1.0)
    end

  end 

  # println(model)

  optimize!(model)
  moves = map(f -> round(Int,value(f)), vars)
  # Initialize a new array to hold the reordered elements
  result = similar(r)

  for i in 1:num_indexes
      result[moves[i]] = r[i]
  end
  # result = map(f -> result[f], indices_of_result)
  # println(map(f -> value(f), vars))
  # new_result = map
  println("from $r --to-> $result")
  result
end
run_me()

# [v1, v2, v3, v4, v5]
# vX = 