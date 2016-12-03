clear all;
%clf;

% Define the boundaries of the problem.
% lb=[-5,-5];
% V =length(lb);
% ub=[5,5];
% M=1;
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


