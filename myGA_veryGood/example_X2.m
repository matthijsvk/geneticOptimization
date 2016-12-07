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

nbTests = 200;
totIt = zeros(nbTests,1);
totRunTime = zeros(nbTests,1);
parfor i=1:nbTests
    disp(i);
    [it,population,runTime]= myGA(@(x) benchmark(4,x,V),V,M,lb,ub);
    totIt(i) =  it;
    totRunTime(i) = runTime;
    
    % draw so we can visualize the population results
%     illustratePopulation(population,V,M,lb,ub,it);
%     disp(population)
%     drawnow;
    %pause(2);
end
itAvg = sum(totIt) / nbTests;
runTimeAvg = sum(totRunTime) / nbTests;
fprintf('itAvg: %5.2f, std: %5.2f |\t runTimeAvg: %5.2f, std: %5.2f \n', itAvg, std(totIt), runTimeAvg, std(totRunTime));

maxIt = max(totIt);
maxTime = max(totRunTime);
fprintf('maxIt: %5.2f |\t maxTime: %5.2f \n', maxIt, maxTime);


% % Use the GA
% %[it,population,runTime]=myGAoriginal(@(x) benchmark(4,x,V),V,M,lb,ub);
% disp(['Total runTime: ', num2str(runTime)]);
% disp(['Number of iterations till convergence: ',num2str(it)])

% disp('FinalPopulation')
% disp(population)    
% 
% illustratePopulation(population,V,M,lb,ub,it);


