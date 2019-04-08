module MCDA

using LinearAlgebra

export Criterion, Concept, addcriterion!, globalweight, criterionvalue, criterionconvertedvalue, criterionconvertedifneededvalue, promdiff, ConsRatio

struct Criterion
    name::String
    localweight::Float64
    globalweight::Float64
    valueconverter::Function

    #Criterion(name, localweight, globalweight) = new(name, localweight, globalweight, identity)
end

name(con) = con.name

globalweight(criterion) = criterion.globalweight

struct Concept
    name::String
    criteria::Vector{Criterion}
    values::Vector

    Concept(name, criteria) = new(name, criteria, Vector{Any}(undef, length(criteria)))
end

function convertedvalues(con)
    numcrits = length(con.criteria)
    output = zeros(numcrits)
    for (i, (crit, val)) in enumerate(zip(con.criteria, con.values))
        output[i] = crit.valueconverter(val)
    end
    return output
end

function criterionvalue(concept, i)
    return concept.values[i]
end

function criterionconvertedvalue(concept, i)
    return concept.criteria[i].valueconverter(criterionvalue(concept,i))
end

function criterionconvertedifneededvalue(concept, i)
    val = criterionvalue(concept,i)
    if typeof(val) <: Number
        return val
    end
    return concept.criteria[i].valueconverter(val)
end

function addcriterion!(con::Concept, cr::Criterion, value)
    push!(con.criteria, cr)
    push!(con.values, value)
end

function convertSymbolicScale(val)
    conversiondict = Dict([
        ("ref", 5.0),
        ("---", 10/14),
        ("--", 30/14),
        ("-", 50/14),
        ("0", 70/14),
        ("+", 90/14),
        ("++", 110/14),
        ("+++", 130/14)
    ])
    return conversiondict[val]
end

function convertMinMaxDecr(x, mini, maxi)
    return 10*(1-(x-mini)/(maxi-mini))
end

function convertMinMaxIncr(x, mini, maxi)
    return 10*((x-mini)/(maxi-mini))
end

struct EvaluationMethods
    criteria::Vector{Criterion}
    evaluationmethod::String
    range::String
end
"""Promethee"""
#vshape
function vshape(d,p)
    if d <= 0
        return 0.0
    end
    if d > p
        return 1.0
    end
    return d/p
end

function usual(d)
    if d > 0
        return 1.0
    end
    return 0.0
end

function diff(M)
    (nconcepts, ncriteria) = size(M)
    D = zeros(nconcepts, nconcepts, ncriteria)
    for z = 1:ncriteria
        for i = 1:nconcepts
            for j = 1:nconcepts
                D[i,j,z] = M[i,z]-M[j,z];
            end
        end
    end
    return D
end


"""
Calculate preference for Promethee
    diff: differences matrix
    pfunctions: Preference function for each criterion, e.g. for three criteria:
    [usual, d -> vshape(d,1.5), d -> vshape(d,2.0)]
    minmax: for each criterion 1 for maximization, -1 for minimization, e.g.
    [-1, 1, 1]
"""
function promdiff(diff, pfunctions, minmax)
    # Check that the input is correct:
    (ni, nj, nz) = size(diff)
    @assert nz == length(pfunctions)
    @assert nz == length(minmax)
    @assert all(abs.(minmax) .== 1)

    # Create output matrix
    P = zeros(size(diff))

    # Loop over all dimensions
    for I in CartesianIndices(diff)
        (i,j,z) = Tuple(I) # I is equivalent to (i,j,z)
        P[I] = pfunctions[z](minmax[z]*diff[I])
    end

    return P
end

function phip(pimat)
    nconcepts = size(pimat,1)
    return reshape(sum(pimat,dims=2)/(nconcepts-1), nconcepts)
end
function phim(pimat)
    nconcepts = size(pimat,1)
    return reshape(sum(pimat,dims=1)/(nconcepts-1),nconcepts)
end
"""AHP"""
function ConvertRI(val)
    conversiondict = Dict([
        (1, 0),
        (2, 0),
        (3, 0.58),
        (4, 0.9),
        (5, 1.12),
        (6, 1.24),
        (7, 1.32),
        (8, 1.41),
        (9, 1.45),
        (10, 1.49),
        (11, 1.52),
        (12, 1.54),
        (13, 1.56),
        (14, 1.58),
        (15, 1.59)
    ])
    return conversiondict[val]
end

function ConsRatio(CM)
    b=eigvals(CM)
    n = size(CM,1)
    lambdamax = maximum(abs.(b))
    CI = (lambdamax-n)/(n-1)
    RI = ConvertRI(n)
    CR = CI/RI*100
end
function CMcrit(criteria)
    ncriteria =length(criteria)
    CM = zeros(ncriteria,ncriteria)
    wmaxdiff = maximum(globalweight.(criteria))-minimum(globalweight.(criteria))
    for i = 1:ncriteria
        for j = 1:ncriteria
            diff = globalweight.(criteria)[i]-globalweight.(criteria)[j]
            if diff == 0
                CM[i,j] = 1
            elseif diff>0
                for k=0:8
                    if diff>k*wmaxdiff/9 && diff<=(k+1)*wmaxdiff/9
                        CM[i,j] = k+1
                    end
                end
            elseif diff<0
                for k= 0:8
                    if diff<-k*wmaxdiff/9 && diff>=-(k+1)*wmaxdiff/9
                        CM[i,j] = 1/(k+1)
                    end
                end
            end
        end
    end
    return CM
end

function CMScale0_3(diff,maxdiff)
    if diff == 0
        return 1
    elseif diff == 1
        return 3
    elseif diff == 2
        return 6
    elseif diff == 3
        return 9
    elseif diff == -1
        return 1/3
    elseif diff == -2
        return 1/6
    elseif diff == -3
        return 1/9
    end
    error("Value $diff passed to CMScale0_3 is not allowed")
end
function CMScale0_maxdiff(diff, maxdiff)
    if diff == 0
        return 1
    elseif diff>0
        for k=0:8
            if diff>k*maxdiff/9 && diff<=(k+1)*maxdiff/9
                return k+1
            end
        end
    elseif diff<0
        for k=0:8
            if diff<-k*maxdiff/9 && diff>=-(k+1)*maxdiff/9
                return 1/(k+1)
            end
        end
    end
end
function CMScale0_4(diff, maxdiff)
    if diff == 0
        return 1
    elseif diff == 1
        return 3
    elseif diff == 2
        return 5
    elseif diff == 3
        return 7
    elseif diff == 4
        return 9
    elseif diff == -1
        return 1/3
    elseif diff == -2
        return 1/5
    elseif diff == -3
        return 1/7
    elseif diff == -4
        return 1/9
    end
end
function CMscale0(diff, maxdiff)
    if diff==0
        return 1
    elseif diff>0
        return 1/3
    elseif diff<0
        return 3
    end
end

#if smaller is better:
#Min: maximum(criterionvalue.(concepts,concept_idx))*ones(1,nconcepts)-criterionvalue.(concepts,concept_idx)
#if bigger is better: max
function buildCM(concepts, concept_idx, diff_function; smaller_is_better=false)
    nconcepts= length(concepts)
    CM =zeros(nconcepts,nconcepts)
    critvals = criterionvalue.(concepts,concept_idx) # Cache the criterion values
    if smaller_is_better
        critvals .= fill(maximum(critvals), nconcepts) .- critvals
    end
    maxdiff = maximum(critvals)-minimum(critvals)
    for i= 1:nconcepts
        for j= 1:nconcepts
            diff = critvals[i]-critvals[j]
            CM[i,j] = diff_function(diff,maxdiff)
        end
    end
    return CM
end

end# module
