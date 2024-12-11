struct Q 
  answer::Int64
  nums::Vector{Int64}
end

using Base.Iterators

all_ops::Dict{Int64, Matrix{String}} = Dict()

function (|)(i1::Int64, i2::Int64)::Int64 
  parse(Int, string(i1, i2))
end


function get_all_possible_operators_in_spaces(num_spaces)::Matrix{String}
  if !haskey(all_ops, num_spaces)
    println("Need to calculate ops possibilities for $num_spaces")
    e = ["*","+","|"]
    r = fill(e, num_spaces)
    p = Base.Iterators.product(r...)
    v = permutedims(vcat(p...))
    
    m::Vector{Vector{String}} = []
    for i in v
      push!(m, collect(i))
    end
    ans = hcat(m...)
    all_ops[num_spaces] = ans
    println("Done calculating ops possibilities for $num_spaces")
  end
  all_ops[num_spaces]
end

function get_potential_solutions(q::Q)
  num_spaces = length(q.nums) - 1
  ops = get_all_possible_operators_in_spaces(num_spaces)
  answers = mapslices(f -> begin
    pushfirst!(f, "+")
    zipped = zip(f,q.nums)
    foldl((acc, (op, next_num)) -> begin 
      if op === "*"
        acc * next_num
      elseif op === "|"
        acc | next_num
      else 
        acc + next_num
      end
    end, zipped; init=0)
  end, ops, dims=1)
  if any(map(f -> f === q.answer, answers))
    q.answer
  else
    0
  end
end

function  get_data()
  input = open(io->read(io, String), "inputs/7.txt")
  lines = split(input, "\n")
  qs = map(f -> begin
    parts = split(f, ": ")
    nums = map(c -> parse(Int, c), split(parts[2], " "))
    Q(parse(Int, parts[1]), nums)
  end, lines)
  d = 0
  mapreduce(f -> begin 
    d += 1
    println("...$d...")
    get_potential_solutions(f)
  end , +, qs)
end

display(get_data())
