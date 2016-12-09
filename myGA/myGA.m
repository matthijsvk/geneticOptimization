function [it,population,runTime]=myGA(f,V,M,lb,ub)
% myGA(f,V,M,lb,ub)
% f : function to minimize
% V : Dimension of the search space.
% sM : Number of objectives.
% lb = lower bound vector.
% ub = upper bound vector.

%% Settings
verbose = 1;

%choose genetic operators: 
%either using interpolation or random uniform crossover
interpolationRecomb = 1; 
% choose whether to swith to different parameters after reaching the Pareto
% curve
variableParams = 0; % set to 1 to enable two stages

if interpolationRecomb == 0  % RUB
     % % If using RUB, set interval to 0 so geneticOperators knows.
    intervalScalar_start = 0; intervalScalar_end = 0;
    
    % manually found values
%     P_start = 1.0 ; 
%     sd_mut_start=0.1; 
%     sd_mut_rec_start= 0.01; 
%     N_start=24;
%     NP_start=12; 
%     NC_start=24;

% optimized values after genetic optimization: P  sd_mut sd_rec N NC/N NP/N
% From myOptimizeGA.m after 11 iterations:    0.81 1.47 0.0255 24 0.88 1.78
    P_start = 0.81 ; 
    sd_mut_start=0.2; 
    sd_mut_rec_start= 0.0255; 
    N_start=24;
    NP_start=round(0.88*N_start); 
    NC_start=round(1.78*N_start);
% this should give evaluateGA.m results of about
%     average"          "33.5258"    "0.57423"
%     "median"           "31"         "0.5"    
%     "maximum"          "83"         "1.68"   
%     "std deviation"    "9.92166"    "0.25529"
    
% different values once the Pareto curve is reached, if 'variableParams' is
% set to 1
    P_end = 0.8;
    sd_mut_end=0.1; 
    sd_mut_rec_end= 0.0255; 
    N_end=32;
    NP_end=8; 
    NC_end=10;
else
    % using Interpolation for genetics 
    sd_mut_rec_start = 0; sd_mut_rec_end = 0;
    P_start = 1;	% Recomination probability
    sd_mut_start = 0.1; %standard deviation for mutation
    N_start = 24;         % Population size
    NP_start = 12;       % Size of the mating pool
    NC_start = 24;       % Number of children generated by generation
    intervalScalar_start = 1.4;
    
    % different values once the Pareto curve is reached, if 'variableParams' is
% set to 1
    P_end = 1;	% Recomination probability
    sd_mut_end = 0.1; %standard deviation for mutation
    N_end = 24;         % Population size
    NP_end = 12;       % Size of the mating pool
    NC_end = 24;       % Number of children generated by generation
    intervalScalar_end = 1.4;
end
N = N_start;

%% THE GENETIC ALGORITHM ITSELF
% Generation of the intial population
population=initPopulation(N,V,M);
population=evaluatePopulation(population,f,V,M,lb,ub);
population=sortPopulation(population,V,M);
% disp('initialPopulation')
% disp(population)

% Main loop
startTime = cputime;

it=1;
stopFlag = 0;
convergedFlag = 0;

while stopFlag==0
    % you can specify parameters for the 2 stages 
    %(convergence to Pareto curve, then spreading and more points)
    % first stage  -> parameter_start
    % second stage -> parameter_end
    if variableParams == 1 && convergedFlag == 1
%         disp('reached PARETO')
        P = P_end;
        sd_mut = sd_mut_end;
        sd_mut_rec = sd_mut_rec_end;
        N = N_end;
        NP = NP_end;
        NC = NC_end;
        intervalScalar = intervalScalar_end;
    else
        P = P_start;
        sd_mut = sd_mut_start;
        sd_mut_rec = sd_mut_rec_start;
        N = N_start;
        NP = NP_start;
        NC = NC_start;
        intervalScalar = intervalScalar_start;
    end
    
    parents= selectionTournament(population,NP,V,M,convergedFlag);
    offspring= geneticOperators(parents,NC,P,intervalScalar,sd_mut,sd_mut_rec,V,M,f,lb,ub);
    population = [ population ; offspring ];
    
    % remove children that are equal to parents
    [~,uniqueIndividuals,~] = unique(population(:,1:V),'rows','stable');
    population = population(uniqueIndividuals,:);
    
    % if reached the Pareto curve, use slower but more precise individual
    % removal based on crowding distance (1 by 1 instead of in batch).
    if convergedFlag == 0
        population = sortPopulation(population,V,M);
        population = cropPopulation(population,N);
    else
        population = sortPopulationCrowding(population,V,M,N);
    end
    
    % Visualization
    if verbose %&& mod(it,10)==0
        pop = [unnormalizePopulation(population(:,1:V),lb,ub) , population(:,V+1:end)]
        illustratePopulation(population,V,M,lb,ub,it);
        drawnow;
        pause(0.05);
    end
    
    [stopFlag, convergedFlag] = stopCriterion(it, population(:,V+M+1),population, V+M+2,M);
    it=it+1;
end
    
runTime = cputime - startTime;

end
        