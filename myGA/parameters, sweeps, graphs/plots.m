%% Don't touch this, these are the columns of 'results' where the parameter values are stored
pIndex = 1;
mutIndex = 2;
mutRecIndex = 3;
nIndex = 4;
npIndex = 5;
ncIndex = 6;
itIndex = 7;
timeIndex = 8;

P = 0.5;
mut = 0.1;
N = 24;
NP = 12;
NC = 24;

%% Uncomment the sweep you want to plot

%% P sweep
load('Psweep.mat');
figure;
P_axis = results(:, pIndex);
P_time = results(:, timeIndex);
plot(P_axis,P_time);
title('P');

%% mut sweep
% load('Mutsweep.mat');
% figure;
% mut_axis = results(:, mutIndex);
% mut_it = results(:, itIndex);
% plot(mut_axis,mut_it);
% title('mutation');

%% mutRec sweep
% load('MutRecsweep.mat');
% figure;
% mut_axis = results(:, mutRecIndex);
% mut_it = results(:, itIndex);
% plot(mut_axis,mut_it);
% title('mutation');

%% NC sweep
% load('NCsweep.mat');
% figure;
% NC_axis = results(:, ncIndex)
% NC_time = results(:, timeIndex)
% plot(NC_axis,NC_time);
% title('NC');

%% NP sweep
% load('NPsweep.mat');
% figure;
% NP_axis = results(:, npIndex);
% NP_time = results(:, timeIndex);
% plot(NP_axis,NP_time);
% title('NP');




