function [it,population,runTime]=myOptimizeGA(f,V,M,lb,ub)
% myGA(f,V,M,lb,ub)
% f : function to minimize
% V : Dimension of the search space.
% M : Number of objectives.
% lb = lower bound vector.
% ub = upper bound vector.

%% DEFINITION OF THE PARAMETERS
N = 32;         % Population size
NP = round(N);       % Size of the mating pool
NC = round(N);       % Number of children generated by generation
P_start = 0.05;        % probability of recombination
M_start = 1 - P_start;
P_end = 0.6;
sd_mut_start = 1;  % standard deviation of Gaussian for mutation
sd_mut_end = 0.2;
intervalScalar = 1.4;   % scale the parent interval to create more variation 
%                         % and not get stuck in local minimum because you always stay in between the parents

verbose=1;

%% GENETIC ALGORITHM

% Generation of the intial population
disp('initPopulation')

% manually set some reasonably good starting values
%               N P sd_mut NPMult NCMult intervalScalar score rank crowding
population= [   32, 0.5, 0.1, 0.5, 0.95, 1.3;
                25, 0.8, 0.3, 0.8, 0.8, 1.1;
                20, 0.6, 0.05, 1, 0.75, 1.5;
                28, 0.3, 0.15, 2.4, 0.9, 1.2];
population = normalizePopulation(population, lb, ub)
population= [population,zeros(size(population,1),M),ones(size(population,1),1),zeros(size(population,1),1)];
% add some random till we fill the population
randomPopulation=initPopulation(N-size(population,1),V,M);
population = [population; randomPopulation];

population=evaluatePopulation(population,f,V,M,lb,ub);
population=sortPopulation(population,V,M);

% print the initial population for checking
popUnnormalized = unnormalizePopulation(population(:,1:V),lb,ub);
disp('initial population: ')
disp([popUnnormalized,population(:,V+1:end)]);


% Main loop
startTime = cputime;

it=1;
stopFlag = 0;
crowdingDistanceFlag = 0;
while stopFlag==0
    if verbose
        disp('##################################################')
        disp(['######## NEW ITERATION:  ',num2str(it), '  ############'])
        disp('##################################################')
    end
    % use this to enable/disable variable P and sd_mut.
    % Setting to crowdingDistanceFlag uses first variable, and when everything reached rank 1 fixed
    fixedPFlag = 1;%crowdingDistanceFlag;
    if fixedPFlag == 0
        sd_mut = sd_mut_start/(it)^1; %with low population sizes, we might miss some optimal direction and it will get stuck
        P = 1 - M_start/(it)^1;
    else
        P = P_end;
        sd_mut = sd_mut_end;
    end
    
    disp('selectionTournament')
    parents=selectionTournament(population,NP,V,M);
    
    disp('geneticOperators')
    offspring=geneticOperators(parents,NC,P,intervalScalar,sd_mut,V,M,f,lb,ub);
    population = [ population ; offspring ];
    
    disp('removeUnique')
    [~,uniqueIndividuals,~] = unique(population(:,1:V),'rows','stable');
    population = population(uniqueIndividuals,:);
    
    disp('sort and crop population')
    if crowdingDistanceFlag == 0
        population = sortPopulation(population,V,M);
        population = cropPopulation(population,N);
    else
        population = sortPopulationCrowding(population,V,M,N);
    end
    
    % Visualization
    if verbose %&& mod(it,10)==0
        pop= unnormalizePopulation(population(:,1:V),lb,ub)%, population(end-19:end,V+1:end)]
        %illustratePopulation(population,V,M,lb,ub,it);  % doesn't make
        %sene to plot as only one objective function
        drawnow;
        pause(0.05);
    end
    
    [stopFlag, crowdingDistanceFlag] = stopCriterion(it, population(:,V+M+1),population, V+M+2, N);%oldPopulationObjectives, population(:,V+1:V+M), notChangingLimit, V, M);
    it=it+1;
    
end
    
runTime = cputime - startTime;

end
