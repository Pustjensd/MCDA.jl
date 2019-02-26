using MCDA
using Test

c1 = Criterion("Maneuverability", 8, 0.115)
c2 = Criterion("Signature profile", 9, 0.129)
c3 = Criterion("Redundancy", 7, 0.101)
c4 = Criterion("Nr. of components", 2, 0.023)
c5 = Criterion("Space consumption", 5, 0.058)
c6 = Criterion("Weight", 7, 0.081)
c7 = Criterion("Fuel capacity", 7, 0.081)
c8 = Criterion("Reliability", 4, 0.042)
c9 = Criterion("Maintainability", 6, 0.064)
c10 = Criterion("Shock-proofness", 3, 0.032)
c11 = Criterion("Purchase costs", 7, 0.107)
c12 = Criterion("Fuel costs", 9, 0.138)
c13 = Criterion("Maintenance costs", 2, 0.031)

@test c1.name == "Maneuverability"
