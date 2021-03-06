function [it,runTime]=myGA_evaluator(f,V,M,lb,ub, P, sd_mut, sd_mut_rec, N, NP, NC)
% myGA(f,V,M,lb,ub)
% f : function to minimize
% V : Dimension of the search space.
% sM : Number of objectives.
% lb = lower bound vector.
% ub = upper bound vector.

%% Some settings
verbose = 0;
interpolationRecomb = 0; %choose genetic operators: either using interpolation (works in 2 stages, first 
variableParams = 0; % for interpolation, set to 1 to enable two stages
intervalScalar = 0;
        
%% GENETIC ALGORITHM
% Generation of the intial population
population=initPopulation(N,V,M);
population=evaluatePopulation(population,f,V,M,lb,ub);
population=sortPopulation(population,V,M);

% Main loop
startTime = cputime;

it=1;
stopFlag = 0;
convergedFlag = 0;

while stopFlag==0
    parents= selectionTournament(population,NP,V,M,convergedFlag);
    offspring= geneticOperators(parents,NC,P,intervalScalar,sd_mut,sd_mut_rec,V,M,f,lb,ub);
    population = [ population ; offspring ];
    
    [~,uniqueIndividuals,~] = unique(population(:,1:V),'rows','stable');
    population = population(uniqueIndividuals,:);
    
    if convergedFlag == 0
        population = sortPopulation(population,V,M);
        population = cropPopulation(population,N);
    else
        population = sortPopulationCrowding(population,V,M,N);
    end
    
    % Visualization
    if verbose && mod(it,10)==0
        pop = [unnormalizePopulation(population(:,1:V),lb,ub) , population(:,V+1:end)]
        illustratePopulation(population,V,M,lb,ub,it);
        drawnow;
        pause(0.05);
    end
    
    [stopFlag, convergedFlag] = stopCriterion(it, population(:,V+M+1),population, V+M+2,M);
    it = it +1;
    
    runTime = cputime - startTime;
    if (runTime > 10)
        stopFlag = 1;
    end
end
    
runTime = cputime - startTime;
%runTime = runTime/N; % lower N is always faster because less calculations.
                                    % we want to optimize for convergence
                                    % speed, independent of population
                                    % size, so compensate for this

% Penalize for not converging at all, and just running randomly. 
% We have to fix this (that noone in the population converges) by adding some good (manually determined) individuals in the startPopulation. 
% They will reproduce becauce they finish before 500 iterations.
% if it>499  
%     runTime = 1000;
% end
% 
% % it hasn't converged at all
% if ( max(population(V+1)) > 1) || (max(population(V+2)) > 1) % V+1 : x1 (horizontal), V+2 = x2 (vertical)
%     runTime = 1000;
% end

if it>499  
    it = it + rand(1,1);
    if convergedFlag == 1 %give points for all rank 1
        runTime = 25 + 0.1*rand(1,1);
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



end
  