function population=initPopulation(N,V,M)

population = random('uniform',0,1,N,V);
population(:,V+M+1) = 1;  %all are in rank 1 to start off
population(:,V+M+2) = 0;  %all have crowdingDistance 0 to start off

   
end
