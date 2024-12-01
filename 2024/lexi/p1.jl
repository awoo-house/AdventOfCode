using DelimitedFiles
using Pkg
Pkg.add("StatsBase")
using StatsBase

dlm = readdlm("./inputs/2.txt", Int)

col1 = dlm[:, 1] 
col2 = dlm[:, 2] 

sorted_col1 = sort(col1)
sorted_col2 = sort(col2)

pt1_answer = sum(abs.(sorted_col1 .- sorted_col2))

dupe_counts = countmap(sorted_col2)

multi_col = get.([dupe_counts], sorted_col1, 0)

pt2_answer = sum(sorted_col1 .* multi_col)

