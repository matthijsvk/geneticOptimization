function [it,runTime]=myGAEvaluator(f,V,M,lb,ub,P, sd_mut, N, NPMult, NCMult, intervalScalar)
% myGA(f,V,M,lb,ub)
% f : function to minimize
% V : Dimension of the search space.
% M : Number of objectives.
% lb = lower bound vector.
% ub = upper bound vector.

verbose=0;

N = round(N);
NP = round(N * NPMult);
NC = round(N * NCMult);
%fprintf('P: %d, sd_mut: %d, N: %d, NP: %d, NC: %d, interval: %d \n', P,sd_mut,N,NP,NC,intervalScalar);

%% GENETIC ALGORITHM

% Generation of the intial population
population=initPopulation(N,V,M);
population=evaluatePopulation(population,f,V,M,lb,ub);
population=sortPopulation(population,V,M);

% Main loop
startTime = cputime;

it=1;
stopFlag = 0;
crowdingDistanceFlag = 0;
while stopFlag==0
    
    parents=selectionTournament(population,NP,V,M);
    
    offspring=geneticOperators(parents,NC,P,intervalScalar,sd_mut,V,M,f,lb,ub);
    population = [ population ; offspring ];
    
    [~,uniqueIndividuals,~] = unique(population(:,1:V),'rows','stable');
    population = population(uniqueIndividuals,:);

    if crowdingDistanceFlag == 0
        population = sortPopulation(population,V,M);
        population = cropPopulation(population,N);
    else
        population = sortPopulationCrowding(population,V,M,N);
    end
    
    [stopFlag, crowdingDistanceFlag] = stopCriterion(it, population(:,V+M+1),population, V+M+2, N);
    it=it+1;
    runTime = cputime - startTime;
    if (runTime > 10)
        stopFlag = 1;
    end
end

runTime = cputime - startTime;

% Penalize for not converging at all, and just running randomly. 
% We have to fix this (that noone in the population converges) by adding some good (manually determined) individuals in the startPopulation. 
% They will reproduce becauce they finish before 500 iterations.
if it>499  
    runTime = 100;
end

% it hasn't converged at all
if ( max(population(V+1)) > 1) || (max(population(V+2)) > 1) % V+1 : x1 (horizontal), V+2 = x2 (vertical)
    runTime = 100;
end

end
