module MCDA

export Criterion, Concept

struct Criterion
    name::String
    localweight::Float64
    globalweight::Float64
end

struct Concept
    criteria::Vector{Criterion}
    values::Vector

    Concept() = new(Criterion[], [])
end

end # module
