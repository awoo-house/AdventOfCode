

struct Q 
  answer::Int64
  nums::Vector{Int64}
end

import Pkg
Pkg.add("Combinatorics")
using Combinatorics
using Base.Iterators

function get_all_possible_operators_in_spaces(num_spaces)::Matrix{Function}
  e = [(*),(+)]
  r = fill(e, num_spaces)
  p = collect(Base.Iterators.product(r...))
  display(p)
  v = permutedims(vcat(p...))
  
  m::Vector{Vector{Function}} = []
  for i in v
    push!(m, collect(i))
  end
  hcat(m...)
  # reshape(v, num_spaces, num_spaces)
end

(function get_potential_solutions(q::Q)
  num_spaces = length(q.nums) - 1
  ops = get_all_possible_operators_in_spaces(num_spaces)

  expressions = collect(zip(
    q.nums[1:num_spaces],
    q.nums[2:(num_spaces + 1)]
  ))
  display(expressions)
  display(ops)

  mapreduce(poss -> begin
    display(poss)
    display(expressions...)
    broadcast(poss, expressions...)
  end, ops)
  
  # Now we have expressions, a [num_spaces]x2 matrix, and
  # ops, a [num_spaces]x[num_possibilites] matrix
  # And for each j in num_possibilites, we want to apply
  # (expressions[i][1],expressions[i][2]) to the function at ops[i][j]

  # [f.(a) for (f, a) in ]

end)(Q(190, [10;19]))

function  get_data()
  input = open(io->read(io, String), "inputs/7.txt")
  lines = split(input, "\n")
  qs = map(f -> begin
    parts = split(f, ": ")
    nums = map(c -> parse(Int, c), split(parts[2], " "))
    Q(parse(Int, parts[1]), nums)
  end, lines)
  qs
  
  
end
get_data()


n::Tuple{Int64, Int64} = (75, 13)
*(n...)