function [it,population,runTime]=myGA(f,V,M,lb,ub)
% myGA(f,V,M,lb,ub)
% f : function to minimize
% V : Dimension of the search space.
% sM : Number of objectives.
% lb = lower bound vector.
% ub = upper bound vector.

%% DEFINITION OF THE PARAMETERS
P_start = 0.44;
sd_mut_start = 0.26;
N_start = 10;N = N_start;
NP_start = 9;
NC_start = 32;
intervalScalar_start = 1.35;

P_end = 0.8;
sd_mut_end = 0.1;
N_end = 32;
NP_end = round(0.4*N_end);
NC_end = round(0.8*N_end);
intervalScalar_end = 1.2;


%0.44 | sd_mut:  0.26 | N: 10.00 | NP:  9.00 | NC:  8.00 | interval:  1.35 

verbose=0;
%% GENETIC ALGORITHM

% Generation of the intial population
population=initPopulation(N,V,M);
population=evaluatePopulation(population,f,V,M,lb,ub);
population=sortPopulation(population,V,M);

% Main loop
tic;

it=1;
stopFlag = 0;
convergedFlag = 0;
while stopFlag==0
    if convergedFlag == 1
        P = P_end;
        sd_mut = sd_mut_end;
        N = N_end;
        NP = NP_end;
        NC = NC_end;
        intervalScalar = intervalScalar_end;
    else
        P = P_start;
        sd_mut = sd_mut_start;
        N = N_start;
        NP = NP_start;
        NC = NC_start;
        intervalScalar = intervalScalar_start;
    end
    
    parents=selectionTournament(population,NP,V,M, convergedFlag);
    
    offspring=geneticOperators(parents,NC,P,intervalScalar,sd_mut,V,M,f,lb,ub);
    % new variable to prevent MATLAB from copying the whole array -> faster
    populationOffspring = [ population ; offspring ];

    [~,uniqueIndividuals,~] = unique(population(:,1:V),'rows','stable');
    population = population(uniqueIndividuals,:);
    
    if convergedFlag == 0 || M == 1
        populationOffspring = sortPopulation(populationOffspring,V,M);
        population = cropPopulation(populationOffspring,N);
    else
        population = sortPopulationCrowding(populationOffspring,V,M,N);
    end
    
    % Visualization
    if verbose %&& mod(it,10)==0
        disp(['convergedFlag: ', crowdingDistanceFlag])
        disp([P, sd_mut,N, NP, NC,intervalScalar]);
        top = population(:,:)
        illustratePopulation(population,V,M,lb,ub,it);
        drawnow;
        pause(0.05);
    end
    
    [stopFlag, convergedFlag] = stopCriterion(it, population(:,V+M+1),population, V+M+2, M);%oldPopulationObjectives, population(:,V+1:V+M), notChangingLimit, V, M);
    it=it+1;
end
    
runTime = toc;

end
        
