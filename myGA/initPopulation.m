function population=initPopulation(N,V,M)

% simple random distribution
% population = random('uniform',0,1,N,V);

% sobol random: better spread over parameter space => faster convergence
p = sobolset(V);
p = scramble(p,'MatousekAffineOwen');
disp(N)
population = net(p,N);

population(:,V+M+1) = 1;  %all are in rank 1 to start off
population(:,V+M+2) = 0;  %all have crowdingDistance 0 to start off

end
