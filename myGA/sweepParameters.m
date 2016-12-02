clear all;

% sweep all Values, get 

% Define the boundaries of the problem.
lb=  zeros(1,6);
ub= ones(1,6); 
V = length(lb);
M = 2; %1 for benchmark 1 and 2, 2 for benchmark 3

% Use the GA

nbRunsAvg = 10; %take average nb of iterations of this amount of runs.
PValues = [0.2:0.2:1];
sdMutValues = [0:0.1:0.2]; 
NValues = [16:16:64];  
NPMult = [0:0.2:1]; 
NCMult = [0:0.2:2]; 
intervalValues = [1.1:0.1:1.5];
fprintf('P: %d, sdMut: %d, N: %d, NP: %d, NC: %d, interval: %d, avgNb: %d \n',length(PValues) , length(sdMutValues) , length(NValues) , length(NPMult) , length(NCMult) , length(intevalValues), nbRunsAvg)
totalNbTests = length(PValues) * length(sdMutValues) * length(NValues) * length(NPMult) * length(NCMult) * length(intevalValues)* nbRunsAvg;
disp(['You asked to run ',num2str(totalNbTests), ' tests.'])

maxRunTime = 3600; % in seconds
estimatedRunTime = round(5*totalNbTests); % 5s per iteration
estimatedRunTimeMins= round(estimatedRunTime/60);

runPossible =  (estimatedRunTime < maxRunTime); %hopefully not too long
disp(['sweeping would take about: ',num2str(estimatedRunTimeMins),' mins, or ', num2str(round(estimatedRunTimeMins/60)), ' hours']);


memoryNeeded = round(totalNbTests * 7 * 64/8 /1e6); % rows * cols * bits/8 /1e6= MB needed to store results
if (memoryNeeded > 4e9) %4GB
    runPossible = false;
end
disp(['storing results requires:  ',num2str(memoryNeeded), ' MB']);
    
if runPossible
    results = sweepParameterValues(PValues, sdMutValues, NValues, NPValues, NCValues);
    dlmwrite('SweepResults.txt')
    % read back with dlmread('SweepResults.txt')
else
    disp(['not doable to run, try something different (',num2str(estimatedRunTimeMins),')']);
    return;
end


 function results = sweepParameterValues(PValues, sdMutValues, NValues, NPMult, NCMult, nbRunsAvg, totalNbTests)
 results = zeros(totalNbTests,7); %columns: PValues, sdMutValues, NValues, NPValues, NCValues, avgTime, avgIt
i=1;
for Pindex=1:length(PValues)
    P = PValues(Pindex);
    for sdMutindex=1:length(sdMutValues)
        sd_mut = sdMutValues(sdMutindex);
        for Nindex=1:length(NValues)
            N = NValues(Nindex); 
            for NPindex=1:length(NPVal)
                NP = N * NPMult(NPindex); 
                for NCindex=1:length(NCValues)
                    NC = N * NCMult(NPindex);
                    for intervalIndex=1:length(intevalValues)
                        intervalValue = intervalValues(intervalIndex);
                        for run=1:nbRunsAvg
                            [it,~,runTime]=myGA(@(x) benchmark(4,x,V),V,M,lb,ub, P, sd_mut, N, NP, NC, intervalValue);
                            thisTotalTime = thisTotalTime + runTime;
                            thisTotalIt = thisTotalIt + it;
                        end
                        thisAvgTime = thisTotalTime ./ nbRunsAvg;
                        thisAvgIt = thisTotalIt ./ nbRunsAvg;
                        results(i) = [P, sd_mut, N, NP, NC, thisAvgTime, thisAvgIt];
                        i = i +1;
                        % now, do the test with different parameters
                    end
                end
            end
        end
    end
end


end