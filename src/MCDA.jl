module MCDA

export Criterion, Concept, addcriterion!, globalweight, criterionvalue, criterionconvertedvalue, criterionconvertedifneededvalue

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
function [P] = vshape(diff,z,optim,P)
# optim is 1 for maximization and 2 for minimization

maxnum = max(max(diff(:,:,z)));
if optim == 1
for i = 1:8
    for j = 1:8
        if diff(i,j,z)>0
            P(i,j,z) = diff(i,j,z)/maxnum;
        else
            P(i,j,z) = 0;
        end
    end
end
elseif optim == 2
for i = 1:8
    for j = 1:8
        if diff(i,j,z)<0
            P(i,j,z) = -diff(i,j,z)/maxnum;
        else
            P(i,j,z) = 0;
        end
    end
end
end
end
#usual
function [P] = usual(diff,z,optim,P)
# optim is 1 for maximization and 2 for minimization
if optim == 1
for i = 1:8
    for j = 1:8
        if diff(i,j,z)>0
            P(i,j,z) = 1;
        else
            P(i,j,z) = 0;
        end
    end
end

elseif optim == 2
for i = 1:8
    for j = 1:8
        if diff(i,j,z)<0
            P(i,j,z) = 1;
        else
            P(i,j,z) = 0;
        end
    end
end
end
end

diff  = zeros(8,8,13);
for z = 1:13
    for i = 1:8
        for j = 1:8
            diff(i,j,z) = M(i,z)-M(j,z);
        end
    end
end


end# module
