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
@show prioritycrit = prioritycrit/maximum(prioritycrit)
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

matman = CMman^100/10.0^100
priorityman = sum(matman,dims=2)/sum(sum(matman))
@show priorityman = priorityman/maximum(priorityman)

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
@show prioritypow = prioritypow/maximum(prioritypow)
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
@show prioritycon = prioritycon/maximum(prioritycon)
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
@show prioritymain = prioritymain/maximum(prioritymain)

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
@show priorityvil = priorityvil/maximum(priorityvil)

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
@show prioritysaf = prioritysaf/maximum(prioritysaf)
