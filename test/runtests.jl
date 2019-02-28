using MCDA
using Test

c1 = Criterion("Maneuverability", 8, 0.115, MCDA.convertSymbolicScale)
c2 = Criterion("Signature profile", 9, 0.129, MCDA.convertSymbolicScale)
c3 = Criterion("Redundancy", 7, 0.101, identity)
c4 = Criterion("Nr. of components", 2, 0.023, identity)
c5 = Criterion("Space consumption", 5, 0.058, identity)
c6 = Criterion("Weight", 7, 0.081, identity)
c7 = Criterion("Fuel capacity", 7, 0.081, identity)
c8 = Criterion("Reliability", 4, 0.042, MCDA.convertSymbolicScale)
c9 = Criterion("Maintainability", 6, 0.064, MCDA.convertSymbolicScale)
c10 = Criterion("Shock-proofness", 3, 0.032, MCDA.convertSymbolicScale)
c11 = Criterion("Purchase costs", 7, 0.107, identity)
c12 = Criterion("Fuel costs", 9, 0.138, identity)
c13 = Criterion("Maintenance costs", 2, 0.031, identity)

criteria = [c1, c2]

#con1 = Concept(Criterion)
@test c1.name == "Maneuverability"
@test c2.localweight == 9

@show con = Concept("concept 1", criteria)
con.values[1] = "---"
con.values[2] = "ref"
@show con = Concept("concept 2", criteria)
con.values[1] = "0"
con.values[2] = "0"
@show con = Concept("concept 3", criteria)
con.values[1] = "--"
con.values[2] = "-"
@show con = Concept("concept 4", criteria)
con.values[1] = "+++"
con.values[2] = "++"
@show con = Concept("concept 5", criteria)
con.values[1] = "+++"
con.values[2] = "++"
@show con = Concept("concept 6", criteria)
con.values[1] = "+"
con.values[2] = "+"
@show con = Concept("concept 7", criteria)
con.values[1] = "++"
con.values[2] = "+"
@show con = Concept("concept 8", criteria)
con.values[1] = "+++"
con.values[2] = "+++"
cvals = MCDA.convertedvalues(con)
@show cvals
