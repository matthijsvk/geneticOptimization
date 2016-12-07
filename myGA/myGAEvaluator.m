function [it,runTime]=myGAEvaluator(f,V,M,lb,ub,P, sd_mut,sd_mut_rec, N, NP, NC)
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
    
    parents=selectionTournament(population,NP,V,M,crowdingDistanceFlag);
    % use interval = 0
    offspring=geneticOperators(parents,NC,P,0,sd_mut,sd_mut_rec,V,M,f,lb,ub);
    populationOffspring = [ population ; offspring ];
    
    [~,uniqueIndividuals,~] = unique(populationOffspring(:,1:V),'rows','stable');
    populationOffspring = populationOffspring(uniqueIndividuals,:);

    if crowdingDistanceFlag == 0
        populationOffspring = sortPopulation(populationOffspring,V,M);
        population = cropPopulation(populationOffspring,N);
    else
        population = sortPopulationCrowding(populationOffspring,V,M,N);
    end
    
    [stopFlag, crowdingDistanceFlag] = stopCriterion(it, population(:,V+M+1),population, V+M+2, M);
    it=it+1;
    runTime = cputime - startTime;
    if (runTime > 50)
        stopFlag = 1;
    end
    % don't end yet is stopFlag (low std dev, and all rank 1), but not in
    % cnovergence region  yet
    if (stopFlag == 1 && it<499)
        if (mean(population(:,V+1)) > 1) || (mean(population(:,V+2)) > 1) % V+1 : x1 (horizontal), V+2 = x2 (vertical)
            stopFlag = 0;
        end
    end
end

runTime = cputime - startTime;

% compensate for N
runTime = runTime/N; % lower N is always faster because less calculations.
                                    % we want to optimize for convergence
                                    % speed, independent of population
                                    % size, so compensate for this

% Penalize for not converging at all, and just running randomly. 
% We have to fix this (that noone in the population converges) by adding some good (manually determined) individuals in the startPopulation. 
% They will reproduce becauce they finish before 500 iterations.
if it>499  
    it = it + rand(1,1);
    if crowdingDistanceFlag == 1 %give points for all rank 1
        runTime = 5 + 0.1*rand(1,1);
    else
        runTime = 100 + rand(1,1);
    end
end

% it hasn't converged, give penalty
mean1 = mean(population(:,V+1));
mean2 = mean(population(:,V+2));

if ( mean1> 1) && (mean2 > 1) % V+1 : x1 (horizontal), V+2 = x2 (vertical)
    runTime = runTime + (mean1(1,1) - 1)*50 ;
elseif mean2(1,1) > 1
    runTime = runTime + (mean2(1,1) - 1)*50;
elseif mean1(1,1) > 1
    runTime = runTime + (mean1(1,1) - 1)*100;
end

% disp([mean1, mean2, runTime])
% pop = [unnormalizePopulation(population(:,1:V),lb,ub) , population(:,V+1:end)]
% illustratePopulation(population,V,M,lb,ub,it);
% pause(1)

end
