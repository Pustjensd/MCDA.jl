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
concepts = []

con = Concept("concept 1", criteria)
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
con = Concept("concept 2", criteria)
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
con = Concept("concept 3", criteria)
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
con = Concept("concept 4", criteria)
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
con = Concept("concept 5", criteria)
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
con = Concept("concept 6", criteria)
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
con = Concept("concept 7", criteria)
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
con = Concept("concept 8", criteria)
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

CMcrit = MCDA.CMcrit(criteria)
matcrit = CMcrit^100/10^57
prioritycrit = sum(matcrit,dims=2)/sum(sum(matcrit))
@show CRcrit = ConsRatio(CMcrit)

CMcon1 = MCDA.buildCM(concepts, 1, MCDA.CMScale0_maxdiff)
matcon1 = CMcon1^100/10^57
prioritycon1 = sum(matcon1,dims=2)/sum(sum(matcon1))
@show CRcon1 = ConsRatio(CMcon1)

CMcon2 = MCDA.buildCM(concepts, 2, MCDA.CMScale0_maxdiff)
matcon2 = CMcon2^100/10^57
prioritycon2 = sum(matcon2,dims=2)/sum(sum(matcon2))
@show CRcon2 = ConsRatio(CMcon2)

CMcon3 = MCDA.buildCM(concepts, 3, MCDA.CMscale0_maxdiff)
matcon3 = CMcon3^100/10^57
prioritycon3 = sum(matcon3,dims=2)/sum(sum(matcon3))
@show CRcon3 = ConsRatio(CMcon3)

CMcon4 = MCDA.buildCM(concepts, 4, MCDA.CMScale0_4; smaller_is_better=true)
matcon4 = CMcon4^100/10^57
prioritycon4 = sum(matcon4,dims=2)/sum(sum(matcon4))
@show CRcon4 = ConsRatio(CMcon4)

CMcon5 = MCDA.buildCM(concepts, 5, MCDA.CMScale0_maxdiff; smaller_is_better=true)
matcon5 = CMcon5^100/10^57
prioritycon5 = sum(matcon5,dims=2)/sum(sum(matcon5))
@show CRcon5 = ConsRatio(CMcon5)

CMcon6 = MCDA.buildCM(concepts, 6, MCDA.CMScale0_maxdiff; smaller_is_better=true)
matcon6 = CMcon6^100/10^57
prioritycon6 = sum(matcon6,dims=2)/sum(sum(matcon6))
@show CRcon6 = ConsRatio(CMcon6)

CMcon7 = MCDA.buildCM(concepts, 7, MCDA.CMScale0_maxdiff; smaller_is_better=true)
matcon7 = CMcon7^100/10^57
prioritycon7 = sum(matcon7,dims=2)/sum(sum(matcon7))
@show CRcon7 = ConsRatio(CMcon7)

CMcon8 = MCDA.buildCM(concepts, 8, MCDA.CMScale0_maxdiff)
matcon8 = CMcon8^100/10^57
prioritycon8 = sum(matcon8,dims=2)/sum(sum(matcon8))
@show CRcon8 = ConsRatio(CMcon8)

CMcon9 = MCDA.buildCM(concepts, 9, MCDA.CMScale0_maxdiff)
matcon9 = CMcon9^100/10^57
prioritycon9 = sum(matcon9,dims=2)/sum(sum(matcon9))
@show CRcon9 = ConsRatio(CMcon9)

CMcon10 = MCDA.buildCM(concepts, 10, MCDA.CMScale0_maxdiff)
matcon10 = CMcon10^100/10^57
prioritycon10 = sum(matcon10,dims=2)/sum(sum(matcon10))
@show CRcon10 = ConsRatio(CMcon10)

CMcon11 = MCDA.buildCM(concepts, 11, MCDA.CMScale0_maxdiff; smaller_is_better=true)
matcon11 = CMcon11^100/10^57
prioritycon11 = sum(matcon11,dims=2)/sum(sum(matcon11))
@show CRcon11 = ConsRatio(CMcon11)

CMcon12 = MCDA.buildCM(concepts, 12, MCDA.CMScale0_maxdiff; smaller_is_better=true)
matcon12 = CMcon12^100/10^57
prioritycon12 = sum(matcon12,dims=2)/sum(sum(matcon12))
@show CRcon12 = ConsRatio(CMcon12)

CMcon13 = MCDA.buildCM(concepts, 13, MCDA.CMScale0_maxdiff; smaller_is_better=true)
matcon13 = CMcon13^100/10^57
prioritycon13 = sum(matcon13,dims=2)/sum(sum(matcon13))
@show CRcon13 = ConsRatio(CMcon13)
