using MCDA
using Test

criteria = [
    Criterion("Manpower", 1, 0.116279, identity),
    Criterion("Power", 1.6, 0.186, identity),
    Criterion("Construction", 1.2, 0.13953, identity),
    Criterion("Maintenance", 1, 0.116279, identity),
    Criterion("Villages", 1.8, 0.2093, identity),
    Criterion("Safety", 2, 0.232672, identity),
]

concepts = []

@show con = Concept("Italy", criteria)
con.values[1] = 1
con.values[2] = 90
con.values[3] = 600
con.values[4] = 5.4
con.values[5] = 8
con.values[6] = 3
push!(concepts, con)
@show con = Concept("Belgium", criteria)
con.values[1] = 3
con.values[2] = 58
con.values[3] = 200
con.values[4] = 9.7
con.values[5] = 1
con.values[6] = 1
push!(concepts, con)
@show con = Concept("Germany", criteria)
con.values[1] = 2
con.values[2] = 60
con.values[3] = 400
con.values[4] = 7.2
con.values[5] = 4
con.values[6] = 4
push!(concepts, con)
@show con = Concept("Sweden", criteria)
con.values[1] = 4
con.values[2] = 80
con.values[3] = 1000
con.values[4] = 7.5
con.values[5] = 7
con.values[6] = 5
push!(concepts, con)
@show con = Concept("Austria", criteria)
con.values[1] = 4
con.values[2] = 72
con.values[3] = 600
con.values[4] = 2.0
con.values[5] = 3
con.values[6] = 5
push!(concepts, con)
@show con = Concept("France", criteria)
con.values[1] = 1
con.values[2] = 96
con.values[3] = 700
con.values[4] = 3.6
con.values[5] = 5
con.values[6] = 3
push!(concepts, con)
@show con = Concept("Spain", criteria)
con.values[1] = 2
con.values[2] = 69
con.values[3] = 800
con.values[4] = 2.6
con.values[5] = 2
con.values[6] = 4
push!(concepts, con)
@show con = Concept("Greece", criteria)
con.values[1] = 3
con.values[2] = 62
con.values[3] = 350
con.values[4] = 3.3
con.values[5] = 3
con.values[6] = 3
push!(concepts, con)
@show con = Concept("Poland", criteria)
con.values[1] = 1
con.values[2] = 55
con.values[3] = 450
con.values[4] = 2.7
con.values[5] = 4
con.values[6] = 2
push!(concepts, con)
@show con = Concept("Denmark", criteria)
con.values[1] = 2
con.values[2] = 77
con.values[3] = 550
con.values[4] = 8.1
con.values[5] = 1
con.values[6] = 4
push!(concepts, con)

nconcepts = length(concepts)

M = criterionvalue.(concepts,(1:length(criteria))')

diff  = MCDA.diff(M)

critmaxdiff = reshape(maximum(diff, dims=(1,2)), size(diff,3))

preffuncs = fill(MCDA.usual, 6)
preffuncs = convert(Vector{Function}, preffuncs)
preffuncs[1] = (d -> MCDA.vshape(d,critmaxdiff[1]))
preffuncs[2] = (d -> MCDA.vshape(d,critmaxdiff[2]))
preffuncs[3] = (d -> MCDA.vshape(d,critmaxdiff[3]))
preffuncs[4] = (d -> MCDA.vshape(d,critmaxdiff[4]))
preffuncs[5] = MCDA.usual
preffuncs[6] = (d -> MCDA.vshape(d,critmaxdiff[6]))

minmax = ones(6)
minmax[1] = 1
minmax[2] = 1
minmax[3] = -1
minmax[4] = -1
minmax[5] = -1
minmax[6] = 1

P = promdiff(diff, preffuncs, minmax)

w = reshape(globalweight.(criteria), 1, 1, length(criteria))
display(w)

pimat = reshape(sum(P .* w, dims=3), nconcepts, nconcepts)
display(pimat)
phip=MCDA.phip(pimat)
println()
display(phip)
phim=MCDA.phim(pimat)
println()
display(phim)
phi = phip-phim
println()
display(phi)
