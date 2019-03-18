module MCDA

export Criterion, Concept, addcriterion!, globalweight, criterionvalue, criterionconvertedvalue, criterionconvertedifneededvalue, promdiff

struct Criterion
    name::String
    localweight::Float64
    globalweight::Float64
    valueconverter::Function

    #Criterion(name, localweight, globalweight) = new(name, localweight, globalweight, identity)
end

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
# Promethee
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

"""
Calculate preference for Promethee
    diff: differences matrix
    pfunctions: Preference function for each criterion, e.g. for three criteria:
    [usual, d -> vshape(d,1.5), d -> vshape(d,2.0)]
    minmax: for rach criterion 1 for maximization, -1 for minimization, e.g.
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

end# module
