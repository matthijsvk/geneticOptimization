clear all;

%% This function runs the GA 'on itself' in order to find better parameters for the GA.
%% The top GA (myOpimizeGA) has manually set parameters, which allow for reasonably fast convergence
% The script creates a population of GA parameters (P, sd_mut, N, NPMUlt (=NP/N),
% NCMult (=NC/N), intervalScalar). Each individual in the population is
% tested for convergence speed against the ZDT6 benchmark (in benchmark.m),
% taking as objective function the runtime till convergence divided by the
% population size (as larger populations will always take longer to
% calculate), since we want to optimize for convergence independent of
% population size. The calculation of this convergence time happens in
% myGAEvaluator.m

%     P       sd_mut    N     NPMult  NCMult  intervalScalar
lb=  [0.1,    0.001,    8,    0.1,    0.1,      1];
ub=  [1,      2,        64,   1,      2,      1.5];
V = length(lb);
M = 1;

% Use the GA
[it,population,runTime]=myOptimizeGA(@(x) benchmark(5,x,V),V,M,lb,ub);

disp(['Total runTime: ', num2str(runTime)]);
disp(['Number of iterations till convergence: ',num2str(it)])

disp('FinalPopulation')
disp([unnormalizePopulation(population(:,1:V),lb, ub),population(:,V+1)])    

%illustratePopulation(population,V,M,lb,ub,it);


