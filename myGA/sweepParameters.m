clear all;
format short g;
% sweep all Values, get 

% Define the boundaries of the problem.
lb=  zeros(1,6);
ub= ones(1,6); 
V = length(lb);
M = 2; %1 for benchmark 1 and 2, 2 for benchmark 3
%P=0.44 | sd_mut:  0.26 | N: 10.00 | NP:  9.00 | NC:  8.00 | interval:  1.35 
nbRunsAvg = 8; %take average nb of iterations of this amount of runs.
PValues = [0.2:0.2:0.95]
sdMutValues = [0.01:0.2:1]
NValues = [32]%:16:64];  
NPMult = [0.2:0.2:1]
NCMult = [0.2:0.2:2]
intervalValues = [1.35] %[1.1:0.1:1.5];
fprintf('Number of tests for each variable: \n \tP: %d, sdMut: %d, N: %d, NP: %d, NC: %d, interval: %d, avgNb: %d \n', ...
    length(PValues) , length(sdMutValues) , length(NValues) , ...
    length(NPMult) , length(NCMult) , length(intervalValues), nbRunsAvg);
totalNbTests = length(PValues) * length(sdMutValues) * length(NValues) ...
                * length(NPMult) * length(NCMult) * length(intervalValues)* nbRunsAvg;
disp(['You asked to run ',num2str(totalNbTests), ' tests.'])

maxRunTime = 40*3600; % in seconds
estimatedRunTime = round(5*totalNbTests); % 5s per iteration
estimatedRunTimeMins= round(estimatedRunTime/60);

runPossible =  (estimatedRunTime < maxRunTime); %hopefully not too long
disp(['Sweeping would take about: ',num2str(estimatedRunTimeMins),' mins, or ', num2str(round(estimatedRunTimeMins/60)), ' hours']);


memoryNeeded = round(totalNbTests * 7 * 64/8 /1e6); % rows * cols * bits/8 /1e6= MB needed to store results
if (memoryNeeded > 4e9) %4GB
    runPossible = false;
end
disp(['Storing results requires:  ',num2str(memoryNeeded), ' MB']);
    
if runPossible
    startTime = cputime;
    results = sweepParameterValues(nbRunsAvg, PValues, sdMutValues, NValues, NPMult, NCMult, intervalValues, totalNbTests, V, M, lb, ub);
    runTime = cputime - startTime
    save sweepResults.mat
    % read back with dlmread('SweepResults.txt')
else
    disp(['Not reasonable to run, try something different (',num2str(estimatedRunTimeMins),')']);
    return;
end


 function results = sweepParameterValues(nbRunsAvg, PValues, sdMutValues, NValues, NPMult, NCMult,  intervalValues, totalNbTests, V, M, lb, ub)
 results = zeros(totalNbTests,12); %columns: P, sdMut, N, NP, NC, intervalValue avgTime, avgIt
i=1;
for Pindex=1:length(PValues)
    P = PValues(Pindex);
    for sdMutindex=1:length(sdMutValues)
        sdMut = sdMutValues(sdMutindex);
        for Nindex=1:length(NValues)
            N = NValues(Nindex); 
            for NPindex=1:length(NPMult)
                NP = round(N .* NPMult(NPindex)); 
                for NCindex=1:length(NCMult)
                    NC = round(N .* NCMult(NCindex));
                    for intervalIndex=1:length(intervalValues)
                        intervalValue = intervalValues(intervalIndex);
                        fprintf('Now running test %5.0f out of %5.0f \n', i, totalNbTests/nbRunsAvg);
                        fprintf('\t P: %d, sdMut: %d, N: %d, NP: %d, NC: %d, interval: %d, avgNb: %d \n', ...
                                 P ,    sdMut ,     N ,   NP ,    NC ,    intervalValues, nbRunsAvg);
                        totIt = zeros(nbRunsAvg,1);
                        totRunTime = zeros(nbRunsAvg,1);
                        parfor run=1:nbRunsAvg
                            [it,runTime]=myGAEvaluator(@(y) benchmark(4,y,V),V,M,lb,ub, P, sdMut, N, NP, NC, intervalValue);
                            totIt(run) =  it;
                            totRunTime(run) = runTime;
                        end
                        itAvg = mean(totIt) ;
                        runTimeAvg = mean(totRunTime);
                        fprintf('\t itAvg: %5.2f | runTimeAvg: %5.0f\n', itAvg, runTimeAvg);
                        itMed = median(totIt) ;
                        runTimeMed = median(totRunTime);
                        fprintf('\t itMedian: %5.2f |\t runTimeMedian: %5.2f \n', itMed, runTimeMed);
                        itMax = max(totIt);
                        runTimeMax = max(totRunTime);
                        fprintf('\t ItMax: %5.2f |\t runtTimeMax: %5.2f \n', itMax, runTimeMax);
                        results(i,:) = [P, sdMut, N, NP, NC, intervalValue, itAvg, runTimeAvg ,itMed, runTimeMed, itMax, runTimeMax];
                        disp(results(i,:))
                        i = i +1;
                        % now, do the test with different parameters
                    end
                end
            end
        end
    end
end


end