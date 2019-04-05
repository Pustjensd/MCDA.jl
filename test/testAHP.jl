using MCDA
using Test
using LinearAlgebra

criteria = [
    Criterion("Manpower", 1, 0.116279, identity),
    Criterion("Power", 1.6, 0.186, identity),
    Criterion("Construction", 1.2, 0.13953, identity),
    Criterion("Maintenance", 1, 0.116279, identity),
    Criterion("Villages", 1.8, 0.2093, identity),
    Criterion("Safety", 2, 0.232672, identity),
]

concepts = []

con = Concept("Italy", criteria)
con.values[1] = 1
con.values[2] = 90
con.values[3] = 600
con.values[4] = 5.4
con.values[5] = 8
con.values[6] = 3
push!(concepts, con)
con = Concept("Belgium", criteria)
con.values[1] = 3
con.values[2] = 58
con.values[3] = 200
con.values[4] = 9.7
con.values[5] = 1
con.values[6] = 1
push!(concepts, con)
con = Concept("Germany", criteria)
con.values[1] = 2
con.values[2] = 60
con.values[3] = 400
con.values[4] = 7.2
con.values[5] = 4
con.values[6] = 4
push!(concepts, con)
con = Concept("Sweden", criteria)
con.values[1] = 4
con.values[2] = 80
con.values[3] = 1000
con.values[4] = 7.5
con.values[5] = 7
con.values[6] = 5
push!(concepts, con)
con = Concept("Austria", criteria)
con.values[1] = 4
con.values[2] = 72
con.values[3] = 600
con.values[4] = 2.0
con.values[5] = 3
con.values[6] = 5
push!(concepts, con)
con = Concept("France", criteria)
con.values[1] = 1
con.values[2] = 96
con.values[3] = 700
con.values[4] = 3.6
con.values[5] = 5
con.values[6] = 3
push!(concepts, con)
con = Concept("Spain", criteria)
con.values[1] = 3#2
con.values[2] = 69
con.values[3] = 800
con.values[4] = 2.6
con.values[5] = 2
con.values[6] = 4
push!(concepts, con)
con = Concept("Greece", criteria)
con.values[1] = 2#3
con.values[2] = 62
con.values[3] = 350
con.values[4] = 3.3
con.values[5] = 3
con.values[6] = 3
push!(concepts, con)
con = Concept("Poland", criteria)
con.values[1] = 4#1
con.values[2] = 55
con.values[3] = 450
con.values[4] = 2.7
con.values[5] = 4
con.values[6] = 2
push!(concepts, con)
con = Concept("Denmark", criteria)
con.values[1] = 3#2
con.values[2] = 77
con.values[3] = 550
con.values[4] = 8.1
con.values[5] = 1
con.values[6] = 4
push!(concepts, con)

nconcepts = length(concepts)
ncriteria = length(criteria)

CMcrit = MCDA.CMcrit(criteria)
matcrit = CMcrit^100/10^57
prioritycrit = sum(matcrit,dims=2)/sum(sum(matcrit))
@show CRcrit = ConsRatio(CMcrit)
# @show p = reverse(sortperm(reshape(prioritycrit,length(prioritycrit))))
# @show collect(1:6)[p]

CMman = MCDA.buildCM(concepts, 1, MCDA.CMScale0_3)
matman = CMman^100/10.0^100
priorityman = sum(matman,dims=2)/sum(sum(matman))
@show CRman =ConsRatio(CMman)

CMpow = MCDA.buildCM(concepts, 2, MCDA.CMScale0_maxdiff)
matpow = CMpow^100/10^57
prioritypow = sum(matpow,dims=2)/sum(sum(matpow))
@show CRpow = ConsRatio(CMpow)

construction = 1000*ones(1,10) - criterionvalue.(concepts,(3))'
maxdiff = maximum(construction)-minimum(construction)
CMcon = zeros(10,10)
 for i = 1:10
    for j = 1:10
        diff = construction[i]-construction[j]
        if diff == 0
            CMcon[i,j] = 1
        elseif diff>0
            for k=0:8
                if diff>k*maxdiff/9 && diff<=(k+1)*maxdiff/9
                    CMcon[i,j] = k+1
                end
            end
        elseif diff<0
            for k=0:8
                if diff<-k*maxdiff/9 && diff>=-(k+1)*maxdiff/9
                    CMcon[i,j] = 1/(k+1)
                end
            end
        end
   end
end

matcon = CMcon^100/10^57;
prioritycon = sum(matcon,dims=2)/sum(sum(matcon))
@show CRcon = ConsRatio(CMcon)

maintenance = 9.7*ones(1,10) - criterionvalue.(concepts,(4))'
maxdiff = maximum(maintenance)-minimum(maintenance)
CMmain = zeros(10,10)
for i = 1:10
    for j = 1:10
        diff = maintenance[i]-maintenance[j]
        if diff == 0
            CMmain[i,j] = 1
        elseif diff>0
            for k=0:8
                if diff>k*maxdiff/9 && diff<=(k+1)*maxdiff/9
                    CMmain[i,j] = k+1
                end
            end
        elseif diff<0
            for k=0:8
                if diff<-k*maxdiff/9 && diff>=-(k+1)*maxdiff/9
                    CMmain[i,j] = 1/(k+1)
                end
            end
        end
   end
end
matmain = CMmain^100/10^57
prioritymain = sum(matmain,dims=2)/sum(sum(matmain))
@show CRmain = ConsRatio(CMmain)

CMvil= MCDA.buildCM(concepts, 5, MCDA.CMscale0)
matvil = CMvil^100/10^57
priorityvil = sum(matvil,dims=2)/sum(sum(matvil))
@show CRvil = ConsRatio(CMvil)

CMsaf = MCDA.buildCM(concepts, 6, MCDA.CMScale0_4)
matsaf = CMsaf^100/10.0^100
prioritysaf = sum(matsaf,dims=2)/sum(sum(matsaf))
@show CRsaf = ConsRatio(CMsaf)

# for idealized:
# prioritycrit ./= maximum(prioritycrit);
# priorityman ./= maximum(priorityman);
# prioritypow ./= maximum(prioritypow);
# prioritycon ./= maximum(prioritycon);
# prioritymain ./= maximum(prioritymain);
# priorityvil ./= maximum(priorityvil);
# prioritysaf ./= maximum(prioritysaf);

Totalpriority = zeros(10)
for i in 1:10
    # line continuation problem here
    Totalpriority[i] = priorityman[i]*prioritycrit[1]+prioritypow[i]*prioritycrit[2]+prioritycon[i]*prioritycrit[3] +
                       prioritymain[i]*prioritycrit[4]+priorityvil[i]*prioritycrit[5]+prioritysaf[i]*prioritycrit[6]
end

display(Totalpriority)
println()

# alternative method
priorityall = hcat(priorityman, prioritypow, prioritycon, prioritymain, priorityvil, prioritysaf)
Totalpriority = priorityall * prioritycrit
display(Totalpriority)
println()
