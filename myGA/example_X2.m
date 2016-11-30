clear all;
%clf;

% Define the boundaries of the problem.
% lb=[-5,-5];
% V =length(lb);
% ub=[5,5];
% M=1;

lb=  zeros(1,6);
ub= ones(1,6); 
V = length(lb);
M = 2; %1 for benchmark 1 and 2, 2 for benchmark 3

% Use the GA
[it,population,runTime]=myGA(@(x) benchmark(4,x,V),V,M,lb,ub);

disp(['Total runTime: ', num2str(runTime)]);
disp(['Number of iterations till convergence: ',num2str(it)])

% disp('FinalPopulation')
% disp(population)    

illustratePopulation(population,V,M,lb,ub,it);


