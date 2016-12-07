function [it,population,runTime]=myGA(f,V,M,lb,ub)
% myGA(f,V,M,lb,ub)
% f : function to minimize
% V : Dimension of the search space.
% sM : Number of objectives.
% lb = lower bound vector.
% ub = upper bound vector.

%% Some settings
verbose = 0;
interpolationRecomb = 1; %choose genetic operators: either using interpolation (works in 2 stages, first 
variableParams = 0; % for interpolation, set to 1 to enable two stages

if interpolationRecomb == 0
    intervalScalar = 0;
else
    sd_mut_rec = 0;
end

%% DEFINITION OF THE PARAMETERS

% If using SBX for genetics
% P= 0.5 ; 
% sd_mut=0.2 ; 
% sd_mut_rec= 0.001 ; 
% Nbase = 20; N=round(Nbase);
% NP=round(0.5*Nbase); 
% NC=round(N*0.95);
P= 0.89136 ; 
sd_mut=0.03533; 
sd_mut_rec= 0.0132 ; 
Nbase = 24; N=round(Nbase);
NP=round(1*Nbase); 
NC=round(N*1.988);

%0.89136      0.03533     0.023195       43.322            1        1.988      %0.28953          190
%0.49602      0.18563        1e-05       9.4426      0.90519       1.4767     %0.068889     


% if using Interpolation for genetics
%optimal: P=0.44 | sd_mut:  0.26 | N: 10.00 | NP:  9.00 | NC:  8.00 | interval:  1.35 
% N_start = 24;         % Population size
% NP_start = 12;       % Size of the mating pool
% NC_start = 24;       % Number of children generated by generation
% P_start = 0.9;	% Recomination probability
% sd_mut_start = 0.1; %standard deviation for mutation
% intervalScalar_start = 1.35;
% 
P_start = 0.9;
sd_mut_start = 0.26; %doesn't really matter
N_start = 10;
NP_start = 9;
NC_start = 8;
intervalScalar_start = 1.35;

%once you reach the pareto curve (all individuals are rank 1), switch to
%larger population to get more points, and lower mutation as we only need
%to tweak a little
P_end = 0.9;
sd_mut_end = 0.05;
N_end = 16;
NP_end = round(0.6*N_end);
NC_end = round(1.8*N_end);
intervalScalar_end = 2;


%% GENETIC ALGORITHM
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
    crowdingDistanceFlag = convergedFlag;
    % for interpolation recombination, you can specify values for the 2
    % stages (convergence to Pareto curve, then spreading and more points)
    if interpolationRecomb == 1
        if convergedFlag == 0 || variableParams == 0
            P = P_start;
            sd_mut = sd_mut_start;
            N = N_start;
            NP = NP_start;
            NC = NC_start;
            intervalScalar = intervalScalar_start;
        else
            P = P_end;
            sd_mut = sd_mut_end;
            N = N_end;
            NP = NP_end;
            NC = NC_end;
            intervalScalar = intervalScalar_end;
        end
    end
    
    % use this to enable/disable variable P and sd_mut.
    % Setting to crowdingDistanceFlag uses first variable, and when everything reached rank 1 fixed
%     fixedPFlag = crowdingDistanceFlag;
%     if fixedPFlag == 0
%         sd_mut = sd_mut_start/it + sd_mut_end;
%         P = P_start/it + P_end;
%     else
%         P = P_end;
%         sd_mut = sd_mut_end;
%     end
    parents= selectionTournament(population,NP,V,M,crowdingDistanceFlag);
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
    it=it+1;
end
    
runTime = cputime - startTime;

end
        