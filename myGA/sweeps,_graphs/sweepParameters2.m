% clear all;
format short g;

%% Define the boundaries of the problem.
lb=  zeros(1,6);
ub= ones(1,6); 
V = length(lb);
M = 2; %1 for benchmark 1 and 2, 2 for benchmark 3
nbRunsAvg = 32; %take average nb of iterations of this amount of runs.
PValues = 0.5%[0.0:0.05:1]
sdMutValues = 0.1;%[0.01:0.05:2]
sdMutRec = [0.001:0.002:0.05];
NValues = 24; %:16:64];  
NPMult = 0.5; %[0.2:0.2:1]
NCMult = 1;%[0.2:0.05:4] %24; %[0.2:0.1:4]

%% Lots of checking, messages to estimate runtime etc...
fprintf('Number of tests for each variable: \n \tP: %d, sdMut: %d, sdMutRec: %d, N: %d, NP: %d, NC: %d, avgNb: %d \n', ...
    length(PValues) , length(sdMutValues) , length(sdMutRec), length(NValues) , ...
    length(NPMult) , length(NCMult), nbRunsAvg);
totalNbTests = length(PValues) * length(sdMutRec) * length(sdMutValues) * length(NValues) ...
                * length(NPMult) * length(NCMult) * nbRunsAvg;
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
    
%% Actually execute the thing
if runPossible
    startTime = cputime;
    results = sweepParameterValues(nbRunsAvg, PValues, sdMutValues, sdMutRec, NValues, NPMult, NCMult, totalNbTests, V, M, lb, ub);
    runTime = cputime - startTime
    save sdMutSweep0_2.mat
    % read back with dlmread('SweepResults.txt')
else
    disp(['Not reasonable to run, try something different (',num2str(estimatedRunTimeMins),')']);
    return;
end


 function results = sweepParameterValues(nbRunsAvg, PValues, sdMutValues, sdMutRecValues, NValues, NPMult, NCMult,  totalNbTests, V, M, lb, ub)
 results = zeros(round(totalNbTests/nbRunsAvg),16); %columns: P, sdMut, N, NP, NC, intervalValue avgTime, avgIt
 disp(size(results,1));
 disp('starting sweep...')
i=1;
for Pindex=1:length(PValues)
    P = PValues(Pindex);
    for sdMutindex=1:length(sdMutValues)
        sdMut = sdMutValues(sdMutindex);
        for sdMutRecIndex=1:length(sdMutRecValues)
            sdMutRec = sdMutRecValues(sdMutRecIndex);
            for Nindex=1:length(NValues)
                N = NValues(Nindex); 
                for NPindex=1:length(NPMult)
                    NP = round(N .* NPMult(NPindex)); 
                    for NCindex=1:length(NCMult)
                        NC = round(N .* NCMult(NCindex));
                        fprintf('Now running test %5.0f out of %5.0f \n', i, totalNbTests/nbRunsAvg);
                        fprintf('\t P: %d, sdMut: %d, sdMutRec: %d, N: %d, NP: %d, NC: %d, avgNb: %d \n', ...
                                 P ,    sdMut ,  sdMutRec,   N ,   NP ,    NC , nbRunsAvg);
                        totIt = zeros(nbRunsAvg,1);
                        totRunTime = zeros(nbRunsAvg,1);
                        parfor run=1:nbRunsAvg
                            [it,runTime]=myGA_sweep(@(y) benchmark(4,y,V),V,M,lb,ub, P, sdMut, sdMutRec, N, NP, NC);
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

                        itMin = min(totIt);
                        runTimeMin = min(totRunTime);
                        fprintf('\t ItMin: %5.2f |\t runtTimeMin: %5.2f \n', itMin, runTimeMin);

                        itStd = std(totIt);
                        runTimeStd = std(totRunTime);

                        results(i,:) = [P, sdMut, sdMutRec, N, NP, NC, itAvg, runTimeAvg ,itMed, runTimeMed, itMax, runTimeMax, itMin, runTimeMin, itStd, runTimeStd];
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