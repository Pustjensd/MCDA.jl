using MCDA
using Test

c1 = Criterion("Redundancy", 7, 0.101)

@test c1.name == "Redundancy"
