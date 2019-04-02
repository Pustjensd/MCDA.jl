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
con.values[1] = 2
con.values[2] = 69
con.values[3] = 800
con.values[4] = 2.6
con.values[5] = 2
con.values[6] = 4
push!(concepts, con)
con = Concept("Greece", criteria)
con.values[1] = 3
con.values[2] = 62
con.values[3] = 350
con.values[4] = 3.3
con.values[5] = 3
con.values[6] = 3
push!(concepts, con)
con = Concept("Poland", criteria)
con.values[1] = 1
con.values[2] = 55
con.values[3] = 450
con.values[4] = 2.7
con.values[5] = 4
con.values[6] = 2
push!(concepts, con)
con = Concept("Denmark", criteria)
con.values[1] = 2
con.values[2] = 77
con.values[3] = 550
con.values[4] = 8.1
con.values[5] = 1
con.values[6] = 4
push!(concepts, con)

nconcepts = length(concepts)
wmaxdiff = maximum(globalweight.(criteria))-minimum(globalweight.(criteria))

CMcrit = zeros(6,6)
for i = 1:6
    for j = 1:6
        diff = globalweight.(criteria)[i]-globalweight.(criteria)[j]
        if diff == 0
            CMcrit[i,j] = 1
        elseif diff>0
            for k=0:8
                if diff>k*wmaxdiff/9 && diff<=(k+1)*wmaxdiff/9
                    CMcrit[i,j] = k+1
                end
            end
        elseif diff<0
            for k= 0:8
                if diff<-k*wmaxdiff/9 && diff>=-(k+1)*wmaxdiff/9
                    CMcrit[i,j] = 1/(k+1)
                end
            end
        end
    end
end

matcrit = CMcrit^100/10^57
@show prioritycrit = sum(matcrit,dims=2)/sum(sum(matcrit))
b = eigvals(CMcrit)
lambdamax = maximum(abs.(b))
CIcrit = (lambdamax-6)/(6-1)
RIcrit= 1.24
@show CRcrit= CIcrit/RIcrit*100
# @show p = reverse(sortperm(reshape(prioritycrit,length(prioritycrit))))
# @show collect(1:6)[p]

CMman = zeros(10,10)
for i = 1:10
    for j = 1:10
        diff = criterionvalue.(concepts,(1))[i]-criterionvalue.(concepts,(1))'[j]
        if diff == 0
            CMman[i,j] = 1
        elseif diff == 1
            CMman[i,j] = 3
        elseif diff == 2
            CMman[i,j] = 6
        elseif diff == 3
            CMman[i,j] = 9
        elseif diff == -1
            CMman[i,j] = 1/3
        elseif diff == -2
            CMman[i,j] = 1/6
        elseif diff == -3
            CMman[i,j] = 1/9
        end
    end
end

matman = CMcrit^100/10^100
priorityman = sum(matman,dims=2)/sum(sum(matman))
b = eigvals(CMman)
lambdamax = maximum(abs.(b))
CIman = (lambdamax-10)/(10-1)
RIman= 1.49
@show CRman= CIman/RIman*100

maxdiff = maximum(criterionvalue.(concepts,(2)))-minimum(criterionvalue.(concepts,(2)))
CMpow = zeros(10,10)
for i = 1:10
    for j = 1:10
        diff = criterionvalue.(concepts,(2))[i]-criterionvalue.(concepts,(2))[j]
        if diff == 0
            CMpow[i,j] = 1
        elseif diff>0
            for k=0:8
                if diff>k*maxdiff/9 && diff<=(k+1)*maxdiff/9
                    CMpow[i,j] = k+1
                end
            end
        elseif diff<0
            for k=0:8
                if diff<-k*maxdiff/9 && diff>=-(k+1)*maxdiff/9
                    CMpow[i,j] = 1/(k+1)
                end
            end
        end
   end
end

matpow = CMpow^100/10^57
prioritypow = sum(matpow,dims=2)/sum(sum(matpow))
b = eigvals(CMpow)
lambdamax = maximum(abs.(b))
CIpow = (lambdamax-10)/(10-1)
RIpow= 1.49
@show CRpow= CIpow/RIpow*100

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
b=eigvals(CMcon)
lambdamax = maximum(abs.(b))
CIcon = (lambdamax-10)/(10-1)
RIcon = 1.49
@show CRcon = CIcon/RIcon*100

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
b=eigvals(CMmain)
lambdamax = maximum(abs.(b))
CImain = (lambdamax-10)/(10-1)
RImain = 1.49
@show CRmain = CImain/RImain*100

villages= criterionvalue.(concepts,(5))'
CMvil = zeros(10,10)
for i = 1:10
    for j = 1:10
        diff = villages[i]-villages[j]
        if diff==0
            CMvil[i,j] = 1
        elseif diff>0
            CMvil[i,j] = 1/3
        elseif diff<0
            CMvil[i,j] = 3
        end
    end
end
matvil = CMvil^100/10^57
priorityvil = sum(matvil,dims=2)/sum(sum(matvil))
b=eigvals(CMvil)
lambdamax = maximum(abs.(b))
CIvil = (lambdamax-10)/(10-1)
RIvil = 1.49
@show CRvil = CIvil/RIvil*100

safety = criterionvalue.(concepts,(6))'
CMsaf = zeros(10,10)
for i = 1:10
    for j = 1:10
        diff = safety[i]-safety[j]
        if diff == 0
            CMsaf[i,j] = 1
        elseif diff == 1
            CMsaf[i,j] = 3
        elseif diff == 2
            CMsaf[i,j] = 5
        elseif diff == 3
            CMsaf[i,j] = 7
        elseif diff == 4
            CMsaf[i,j] = 9
        elseif diff == -1
            CMsaf[i,j] = 1/3
        elseif diff == -2
            CMsaf[i,j] = 1/5
        elseif diff == -3
            CMsaf[i,j] = 1/7
        elseif diff == -4
            CMsaf[i,j] = 1/9
        end
    end
end
matsaf = CMsaf^100/10^57
# println()
# display(matsaf)
prioritysaf = sum(matsaf,dims=2)/sum(sum(matsaf))
println()
display(prioritysaf)
b=eigvals(CMsaf)
lambdamax = maximum(abs.(b))
CIsaf = (lambdamax-10)/(10-1)
RIsaf = 1.49
@show CRsaf = CIsaf/RIsaf*100

# for i=1:10
#     TotalPriority[i] = priorityman[i]*prioritycrit[1]+prioritypow[i]*prioritycrit[2]+prioritycon[i]*prioritycrit[3]
#         +prioritymain[i]*prioritycrit[4]+priorityvil[i]*prioritycrit[5]+prioritysaf[i]*prioritycrit[6]
# end
