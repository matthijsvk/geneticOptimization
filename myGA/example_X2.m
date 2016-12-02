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


nbTests = 100;
totIt = zeros(nbTests,1);
totRunTime = zeros(nbTests,1);
for i=1:nbTests
    [it,population,runTime]= myGA(@(x) benchmark(4,x,V),V,M,lb,ub);
    totIt(i) =  it;
    totRunTime(i) = runTime;
    
    % draw so we can visualize the population results
    illustratePopulation(population,V,M,lb,ub,it);
    drawnow;
    %pause(0.5);
end
itAvg = sum(totIt) / nbTests;
runTimeAvg = sum(totRunTime) / nbTests;
fprintf('itAvg: %5.2f |\t runTimeAvg: %5.2f \n', it, runTime);

maxIt = max(totIt);
maxTime = max(totRunTime);
fprintf('maxIt: %5.2f |\t maxTime: %5.2f \n', maxIt, maxTime);


% % Use the GA
% %[it,population,runTime]=myGAoriginal(@(x) benchmark(4,x,V),V,M,lb,ub);
% disp(['Total runTime: ', num2str(runTime)]);
% disp(['Number of iterations till convergence: ',num2str(it)])

disp('FinalPopulation')
disp(population)    

illustratePopulation(population,V,M,lb,ub,it);


