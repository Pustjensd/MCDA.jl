# include(joinpath(@__DIR__,"testpromethee.jl"))
# exit()
# include(joinpath(@__DIR__,"testAHP.jl"))
# exit()
# include(joinpath(@__DIR__,"testAHP_idealised.jl"))
# exit()
# include(joinpath(@__DIR__,"runtestAHP.jl"))
# exit()
using MCDA
using Test

criteria = [
    Criterion("Maneuverability", 8, 0.115, MCDA.convertSymbolicScale),
    Criterion("Signature profile", 9, 0.129, MCDA.convertSymbolicScale),
    Criterion("Redundancy", 7, 0.101, x -> MCDA.convertMinMaxIncr(x, 1, 4)),
    Criterion("Nr. of components", 2, 0.023, x -> MCDA.convertMinMaxDecr(x, 14, 18)),
    Criterion("Space consumption", 5, 0.058, x -> MCDA.convertMinMaxDecr(x, 274, 715)),
    Criterion("Weight", 7, 0.081, x -> MCDA.convertMinMaxDecr(x, 255, 550)),
    Criterion("Fuel capacity", 7, 0.081, x -> MCDA.convertMinMaxDecr(x, 301, 328)),
    Criterion("Reliability", 4, 0.042, MCDA.convertSymbolicScale),
    Criterion("Maintainability", 6, 0.064, MCDA.convertSymbolicScale),
    Criterion("Shock-proofness", 3, 0.032, MCDA.convertSymbolicScale),
    Criterion("Purchase costs", 7, 0.107, x -> MCDA.convertMinMaxDecr(x, 21, 74)),
    Criterion("Fuel costs", 9, 0.138,  x -> MCDA.convertMinMaxDecr(x, 3, 3.6)),
    Criterion("Maintenance costs", 2, 0.031,  x -> MCDA.convertMinMaxDecr(x, 0.09, 0.23))
]


#con1 = Concept(Criterion)
# @test c1.name == "Maneuverability"
# @test c2.localweight == 9

concepts = []

@show con = Concept("concept 1", criteria)
con.values[1] = "ref"
con.values[2] = "ref"
con.values[3] = 2
con.values[4] = 14
con.values[5] = 286.3
con.values[6] = 255.9
con.values[7] = 302.4
con.values[8] = "ref"
con.values[9] = "ref"
con.values[10] = "ref"
con.values[11] = 26.14
con.values[12] = 3.42
con.values[13] = 0.168
push!(concepts, con)
@show con = Concept("concept 2", criteria)
con.values[1] = "0"
con.values[2] = "0"
con.values[3] = 2
con.values[4] = 14
con.values[5] = 280.6
con.values[6] = 256.1
con.values[7] = 306.5
con.values[8] = "-"
con.values[9] = "+"
con.values[10] = "0"
con.values[11] = 26.37
con.values[12] = 3.55
con.values[13] = 0.225
push!(concepts, con)
@show con = Concept("concept 3", criteria)
con.values[1] = "--"
con.values[2] = "-"
con.values[3] = 2
con.values[4] = 14
con.values[5] = 715
con.values[6] = 549.4
con.values[7] = 301.7
con.values[8] = "++"
con.values[9] = "--"
con.values[10] = "--"
con.values[11] = 21.93
con.values[12] = 3.03
con.values[13] = 0.119
push!(concepts, con)
@show con = Concept("concept 4", criteria)
con.values[1] = "+++"
con.values[2] = "++"
con.values[3] = 3
con.values[4] = 18
con.values[5] = 450.3
con.values[6] = 334.1
con.values[7] = 312.4
con.values[8] = "+"
con.values[9] = "++"
con.values[10] = "-"
con.values[11] = 32.04
con.values[12] = 3.44
con.values[13] = 0.140
push!(concepts, con)
@show con = Concept("concept 5", criteria)
con.values[1] = "+++"
con.values[2] = "++"
con.values[3] = 3
con.values[4] = 16
con.values[5] = 459.3
con.values[6] = 368.4
con.values[7] = 312.4
con.values[8] = "+"
con.values[9] = "+++"
con.values[10] = "-"
con.values[11] = 33.17
con.values[12] = 3.48
con.values[13] = 0.176
push!(concepts, con)
@show con = Concept("concept 6", criteria)
con.values[1] = "+"
con.values[2] = "+"
con.values[3] = 3
con.values[4] = 17
con.values[5] = 677.2
con.values[6] = 487.7
con.values[7] = 309.6
con.values[8] = "+"
con.values[9] = "--"
con.values[10] = "--"
con.values[11] = 23.93
con.values[12] = 3.03
con.values[13] = 0.097
push!(concepts, con)
@show con = Concept("concept 7", criteria)
con.values[1] = "++"
con.values[2] = "+"
con.values[3] = 3
con.values[4] = 18
con.values[5] = 274.8
con.values[6] = 299.6
con.values[7] = 309.1
con.values[8] = "-"
con.values[9] = "-"
con.values[10] = "-"
con.values[11] = 28.29
con.values[12] = 3.41
con.values[13] = 0.158
push!(concepts, con)
@show con = Concept("concept 8", criteria)
con.values[1] = "+++"
con.values[2] = "+++"
con.values[3] = 2
con.values[4] = 15
con.values[5] = 690.2
con.values[6] = 550
con.values[7] = 327.4
con.values[8] = "+++"
con.values[9] = "+++"
con.values[10] = "+"
con.values[11] = 73.24
con.values[12] = 3.34
con.values[13] = 0.137
push!(concepts, con)

for con in concepts
    cvals = MCDA.convertedvalues(con)
    @show sum(cvals .* globalweight.(con.criteria))
end
nconcepts = length(concepts)
M = criterionconvertedifneededvalue.(concepts,(1:length(criteria))')
println()
println(criterionconvertedifneededvalue.(concepts,4))

diff  = MCDA.diff(M)
critmaxdiff = reshape(maximum(diff, dims=(1,2)), size(diff,3))
preffuncs = fill(MCDA.usual, 13)
preffuncs = convert(Vector{Function}, preffuncs)
preffuncs[1] = MCDA.usual
preffuncs[2] = MCDA.usual
preffuncs[3] = MCDA.usual
preffuncs[4] = MCDA.usual
preffuncs[5] = (d -> MCDA.vshape(d,critmaxdiff[5]))
preffuncs[6] = (d -> MCDA.vshape(d,critmaxdiff[6]))
preffuncs[7] = (d -> MCDA.vshape(d,critmaxdiff[7]))
preffuncs[8] = MCDA.usual
preffuncs[9] = MCDA.usual
preffuncs[10] = MCDA.usual
preffuncs[11] = (d -> MCDA.vshape(d,critmaxdiff[11]))
preffuncs[12] = (d -> MCDA.vshape(d,critmaxdiff[12]))
preffuncs[13] = (d -> MCDA.vshape(d,critmaxdiff[13]))

minmax = ones(13)
minmax[1] = 1
minmax[2] = 1
minmax[3] = 1
minmax[4] = -1
minmax[5] = -1
minmax[6] = -1
minmax[7] = -1
minmax[8] = 1
minmax[9] = 1
minmax[10] = 1
minmax[11] = -1
minmax[12] = -1
minmax[13] = -1
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

perms = reverse(sortperm(phi))

println()
display(phi[perms])
println()

display(MCDA.name.(concepts[perms]))
println()
