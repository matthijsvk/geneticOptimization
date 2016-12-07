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

nbTests = 8;
totIt = [];
totRunTime = zeros(nbTests,1);

j = 1;
prevItAvg = 10; itAvg = 0;
while abs(prevItAvg - itAvg) > 1
    disp('deviation too large, run more tests...')
    for i=j:j+nbTests
    %     disp(['now running test: ',num2str(i)])
        [it,population,runTime]= myGA(@(x) benchmark(4,x,V),V,M,lb,ub);
        totIt(i,1) =  it;
        totRunTime(i,1) = runTime;
    %     disp([it, runTime])

        % draw so we can visualize the population results
%         illustratePopulation(population,V,M,lb,ub,it);
    %     disp(population)
    %     drawnow;
         %pause(2);
    end
    prevItAvg = itAvg;
    itAvg = mean(totIt) ;
    runTimeAvg = mean(totRunTime);
%     fprintf('itAvg: %5.2f\f|\t runTimeAvg: %5.2f\n', itAvg, runTimeAvg);
    itMed = median(totIt) ;
    runTimeMed = median(totRunTime);
%     fprintf('itMedian: %5.2f\t|\t runTimeMedian: %5.2f\n', itMed, runTimeMed);
    maxIt = max(totIt);
    maxTime = max(totRunTime);
%     fprintf('maxIt: %5.2f\t|\t maxTime: %5.2f \n', maxIt, maxTime);
    stdIt = std(totIt);
    stdTime= std(totRunTime);
%     fprintf('stdIt: %5.2f\t|\t stdTime: %5.2f \n', stdIt, stdTime);
    
    names = [string('average'); string('median'); string('maximum'); string('std deviation')];
    valuesIt = [itAvg; itMed; maxIt;stdIt];
    valuesTime = [runTimeAvg; runTimeMed;maxTime; stdTime];
    show = [names,valuesIt,valuesTime]
    
    disp(['we already ran ', num2str(size(totIt,1)), ' tests']);
    disp(['the current avgIt is: ', num2str(itAvg)])
    
    j = j+nbTests;
end

disp('we converged to a small std deviation');
disp(['we ran ',num2str(j),' tests'])
itAvg = mean(totIt) ;
    runTimeAvg = mean(totRunTime);
    fprintf('itAvg: %5.2f\f|\t runTimeAvg: %5.2f\n', itAvg, runTimeAvg);
    itMed = median(totIt) ;
    runTimeMed = median(totRunTime);
    fprintf('itMedian: %5.2f\t|\t runTimeMedian: %5.2f\n', itMed, runTimeMed);
    maxIt = max(totIt);
    maxTime = max(totRunTime);
    fprintf('maxIt: %5.2f\t|\t maxTime: %5.2f \n', maxIt, maxTime);
    stdIt = std(totIt);
    stdTime= std(totRunTime);
    fprintf('stdIt: %5.2f\t|\t stdTime: %5.2f \n', stdIt, stdTime);



% % Use the GA
% %[it,population,runTime]=myGAoriginal(@(x) benchmark(4,x,V),V,M,lb,ub);
% disp(['Total runTime: ', num2str(runTime)]);
% disp(['Number of iterations till convergence: ',num2str(it)])

%disp('FinalPopulation')
%disp(population)    

%illustratePopulation(population,V,M,lb,ub,it);


