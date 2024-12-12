using DelimitedFiles

function run_me()
  input = open(io->read(io, String), "inputs/10.txt")
  lines = split(input, "\n")
  ints = map(f -> map(p -> parse(Int, p), split(f, "")), lines)
  
end

run_me()