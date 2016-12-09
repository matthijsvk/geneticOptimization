%% Don't touch this, these are the columns of 'results' where the parameter values are stored
clear all;
close all;

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
mutRec = 0.01;
N = 24;
NP = 12;
NC = 24;


%% Uncomment the sweep you want to plot. Only works if you sweep one value at a time
%  otherwise you'll have to extract the rows where only one parameter
%  changes. For example for NP sweep:
% mMut = results( results(:, mutIndex) == mut, :);
% mMutRec = mMut( mMut(:, mutRecIndex) == mutRec, :);
% mMut_P = mMutRec( mMutRec(:, pIndex) == P, :);
% mMut_P_NC = mMut_P( mMut_P(:, ncIndex) == NC, :);
% NP_axis = mMut_P_NC(:, npIndex);
% NP_time = mMut_P_NC(:, timeIndex);
% figure;
% plot(NP_axis,NP_time);
% title('NP');

%% P sweep
% load('Psweep.mat');
% figure;
% x = results(:, pIndex);
% y = results(:, timeIndex);
% plot(x,y);
% title('P');
% 
% % add a polynomial fit
% y1 = results(:,itIndex);
% % y1 = results(:,timeIndex);
% 
% p = polyfit(x, y1, 5);
% y2 = polyval(p, x);
% plot(x, y2, 'b', 'Linewidth', 2);
% xlabel('Probability of Recombination');
% axis([min(x) max(x) min(y1) max(y1)]);
% % title('P vs. Time');
% % ylabel('Time (s)');
% title('P vs. # Iterations');
% ylabel('# Iterations ');
% 
% hold on;
% plot(x, y1, 'Color','r' );
% ax = gca;
% ax.FontSize = 12;     % set font size for axes labels


%% mut sweep
% load('sdMutsweep.mat');
% figure;
% x = results(:, mutIndex);
% % y = results(:, itIndex);
% % y = results(:, timeIndex);
% % plot(x,y);
% % title('mutation');
% 
% % add a polynomial fit
% y1 = results(:,itIndex);
% % y1 = results(:,timeIndex);
% 
% p = polyfit(x, y1, 5);
% y2 = polyval(p, x);
% plot(x, y2, 'b', 'Linewidth', 2);
% xlabel('Standard deviation of mutation');
% axis([min(x) max(x) min(y1) max(y1)]);
% % ylabel('Time (s)');
% % title('Mutation vs. Time');
% ylabel('# Iterations ');
% title('Mutation vs. # Iterations');
% 
% hold on;
% plot(x, y1, 'Color','r' );
% ax = gca;
% ax.FontSize = 12;     % set font size for axes labels


%% mutRec sweep
load('sdMutRecsweep.mat');
figure;
x = results(:, mutRecIndex);
% y = results(:, itIndex);
% y = results(:, timeIndex);
% plot(x,y);
% title('mutRec');

% add a polynomial fit
% y1 = results(:,itIndex);
y1 = results(:,timeIndex);

p = polyfit(x, y1, 4);
y2 = polyval(p, x);
plot(x, y2, 'b', 'Linewidth', 1);
xlabel('Standard deviation of mutRec');
% axis([min(x) max(x) min(y1) max(y1)]);
ylabel('Time (s)');
title('MutRec vs. Time');
% ylabel('# Iterations ');
% title('MutRec vs. # Iterations');

hold on;
plot(x, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels


%% Simple plotters, no curve fitting
% Mut sweep
% load('sdMutsweep.mat');
% figure;
% x = results(:, mutIndex);
% % y = results(:, itIndex);
% y = results(:, timeIndex);
% plot(x,y);
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




