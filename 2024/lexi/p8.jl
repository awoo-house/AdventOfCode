using DelimitedFiles

struct Freq
  label::Char
  x::Int
  y::Int
  max_x::Int
  max_y::Int
end

using Base.Iterators
function calculate_anti_pole(point::Freq, points::Vector{Freq}) 
  # println("Checking for $point")
  relevant_sats = filter(f -> begin 
    f != point && f.label == point.label
  end, points)
  potentials = flatmap(f -> begin
    moved_x = point.x - f.x
    moved_y = point.y - f.y
    new_x = point.x + moved_x
    new_y = point.y + moved_y
    aps = [point]

    while (new_x >= 1 && new_x <= f.max_x && new_y >= 1 && new_y <= f.max_y)
      push!(aps, Freq(point.label, new_x, new_y, point.max_x, point.max_y))
      new_x = new_x + moved_x
      new_y = new_y + moved_y
    end

    # opposite direction
    
    new_x = point.x - (2*moved_x)
    new_y = point.y - (2*moved_y)
    while (new_x >= 1 && new_x <= f.max_x && new_y >= 1 && new_y <= f.max_y)
      push!(aps, Freq(point.label, new_x, new_y, point.max_x, point.max_y))
      new_x = new_x - moved_x
      new_y = new_y - moved_y
    end
    aps
  end, relevant_sats)
  # display(potentials)
  collect(potentials)
end

function run_me()
  data = readdlm("./inputs/8.txt", String)
  mat = map(collect, data)
  mat = hcat(mat...)
  display(mat)
  maxX, maxY = size(mat)

  freq_locations = findall(!=('.'), mat)
  fs = map(f -> Freq(mat[f[1], f[2]], f[1], f[2], maxX, maxY), freq_locations)

  all_anti_poles = collect(flatten(map(f -> calculate_anti_pole(f, fs), fs)))
  display(all_anti_poles)
  ansp1 = Set(map(f -> (f.x, f.y), all_anti_poles))
  println(length(ansp1))
end

run_me()