function [it,runTime]=myGAEvaluator(f,V,M,lb,ub,P, sd_mut, N, NP, NC, intervalScalar)
% myGA(f,V,M,lb,ub)
% f : function to minimize
% V : Dimension of the search space.
% M : Number of objectives.
% lb = lower bound vector.
% ub = upper bound vector.

verbose=0;

%N = round(N);
%NP = round(N * NPMult);
%NC = round(N * NCMult);

%% GENETIC ALGORITHM

% Generation of the intial population
population=initPopulation(N,V,M);
population=evaluatePopulation(population,f,V,M,lb,ub);
%     disp('after evalPopulation')
%     disp(population)
population=sortPopulation(population,V,M);

% Main loop
startTime = cputime;

it=1;
stopFlag = 0;
crowdingDistanceFlag = 0;

populationOffspring = zeros(N+NC,V);
while stopFlag==0
    
    parents=selectionTournament(population,NP,V,M);
    
    offspring=geneticOperators(parents,NC,P,intervalScalar,sd_mut,V,M,f,lb,ub);
    populationOffspring = [ population ; offspring ];
    
    [~,uniqueIndividuals,~] = unique(populationOffspring(:,1:V),'rows','stable');
    populationOffspring = populationOffspring(uniqueIndividuals,:);

    if crowdingDistanceFlag == 0
        populationOffspring = sortPopulation(populationOffspring,V,M);
        population = cropPopulation(populationOffspring,N);
    else
        population = sortPopulationCrowding(populationOffspring,V,M,N);
    end
    
    [stopFlag, crowdingDistanceFlag] = stopCriterion(it, population(:,V+M+1),population, V+M+2, N, M);
    it=it+1;
    runTime = cputime - startTime;
    if (runTime > 50)
        stopFlag = 1;
    end
end

runTime = cputime - startTime;
runTimeCompensatedForN = runTime/N; % lower N is always faster because less calculations.
                                    % we want to optimize for convergence
                                    % speed, independent of population
                                    % size, so compensate for this

% Penalize for not converging at all, and just running randomly. 
% We have to fix this (that noone in the population converges) by adding some good (manually determined) individuals in the startPopulation. 
% They will reproduce becauce they finish before 500 iterations.
if it>499  
    runTime = 1000;
end

% it hasn't converged at all
if ( max(population(V+1)) > 1) || (max(population(V+2)) > 1) % V+1 : x1 (horizontal), V+2 = x2 (vertical)
    runTime = 1000;
end

end
