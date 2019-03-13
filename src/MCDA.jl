module MCDA

export Criterion, Concept, addcriterion!

struct Criterion
    name::String
    localweight::Float64
    globalweight::Float64
    valueconverter::Function

    #Criterion(name, localweight, globalweight) = new(name, localweight, globalweight, identity)
end

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

end # module
