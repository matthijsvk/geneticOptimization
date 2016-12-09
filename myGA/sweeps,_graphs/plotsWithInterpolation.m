% P, sdMut, N, NP, NC, intervalValue avgTime, avgIt
% for i= 0:10:40
%     x_axis= results(i+1 : i+10, 5);
%     y_axis= results(i+1 : i+10, 7);
%     plot(x_axis, y_axis)
%     hold on
% end

% load('sweepResults.mat');

pIndex = 1;
mutIndex = 2;
nIndex = 3;
npIndex = 4;
ncIndex = 5;
timeIndex = 8;
itIndex = 7;

% P = 0.2;
% mut = 0.01;
% NP = 6;
% NC = 6;
% 
% % NC sweep
% mMut = results( results(:, mutIndex) == mut, :);
% mMut_NP = mMut( mMut(:, npIndex) == NP, :);
% mMut_NP_P = mMut_NP( mMut_NP(:, pIndex) == P, :);
% NC_axis = mMut_NP_P(:, ncIndex);
% NC_time = mMut_NP_P(:, timeIndex);
% figure;
% plot(NC_axis,NC_time);
% title('NC');
% 
% 
% 
% % NP sweep
% mMut = results( results(:, mutIndex) == mut, :);
% mMut_P = mMut( mMut(:, pIndex) == P, :);
% mMut_P_NC = mMut_P( mMut_P(:, ncIndex) == NC, :);
% NP_axis = mMut_P_NC(:, npIndex);
% NP_time = mMut_P_NC(:, timeIndex);
% figure;
% plot(NP_axis,NP_time);
% title('NP');
% 
% 
% % mutation sweep
% mP = results( results(:, pIndex) == P, :);
% mP_NP = mP( mP(:, npIndex) == NP, :);
% mP_NP_NC = mP_NP( mP_NP(:, ncIndex) == NC, :);
% mut_axis = mP_NP_NC(:, mutIndex);
% mut_time = mP_NP_NC(:, timeIndex);
% figure;
% plot(mut_axis,mut_time);
% title('mutation');
% 
% 
% % P sweep
% mMut = results( results(:, mutIndex) == mut, :);
% mMut_NP = mMut( mMut(:, npIndex) == NP, :);
% mMut_NP_NC = mMut_NP( mMut_NP(:, ncIndex) == NC, :);
% P_axis = mMut_NP_NC(:, pIndex);
% P_time = mMut_NP_NC(:, timeIndex);
% figure;
% plot(P_axis,P_time);
% title('P');
% 

%% NC
load('NCsweepResults1.mat');
% Time
figure;
x_axis = results(1:39,ncIndex);
y1 = results(1:39,timeIndex);
p = polyfit( x_axis, y1, 6);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2 );
title('Number of children (NC) vs. Time');
xlabel('Number of children');
ylabel('Time (s)');


hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels


%[1 0.58 0.60]pink
% Iteration
figure;
x_axis = results(1:39,ncIndex);
y1 = results(1:39,itIndex);
p = polyfit( x_axis, y1, 6);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2);
title('Number of children (NC) vs. Number of iterations');
xlabel('Number of children');
ylabel('Number of iterations');

hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels



%% NP 
load('NPsweepResults8.mat')
% Time
figure;
x_axis = results(1:17,npIndex);
y1 = results(1:17,timeIndex);
p = polyfit( x_axis, y1, 3);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2);
title('Number of parents (NP) vs. Time');
xlabel('Number of parents');
ylabel('Time (s)');

hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels


%[1 0.58 0.60]pink
% Iteration
figure;
x_axis = results(1:17,npIndex);
y1 = results(1:17,itIndex);
p = polyfit( x_axis, y1, 3);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2);
title('Number of parents (NP) vs. Number of iterations');
xlabel('Number of parents');
ylabel('Number of iterations');

hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels



%% P

load('PsweepResults3.mat')
% Time
figure;
x_axis = results(1:16,pIndex);
y1 = results(1:16,timeIndex);
p = polyfit( x_axis, y1, 6);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2);
title('Probability of recombination (P) vs. Time');
xlabel('Probability of recombination');
ylabel('Time (s)');

hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels


%[1 0.58 0.60]pink
% Iteration
figure;
x_axis = results(1:16,pIndex);
y1 = results(1:16,itIndex);
p = polyfit( x_axis, y1, 6);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2);
title('Probability of recombination (P) vs. Number of iterations');
xlabel('Probability of recombination');
ylabel('Number of iterations');

hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels



%% N

load('NsweepResults1.mat')
% Time
figure;
x_axis = results(2:25,nIndex);
y1 = results(2:25,timeIndex);
p = polyfit( x_axis, y1, 6);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2);
title('Population size vs. Time');
xlabel('Population size');
ylabel('Time (s)');

hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels


%[1 0.58 0.60]pink
% Iteration
figure;
x_axis = results(2:25,nIndex);
y1 = results(2:25,itIndex);
p = polyfit( x_axis, y1, 6);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2);
title('Population size vs. Number of iterations');
xlabel('Population size');
ylabel('Number of iterations');

hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels





%% M

load('MsweepResults1.mat')
% Time
figure;
x_axis = results(1:20,mutIndex);
y1 = results(1:20,timeIndex);
p = polyfit( x_axis, y1, 6);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2);
title('Mutation vs. Time');
xlabel('Standart deviation of mutation');
ylabel('Time (s)');

hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels


%[1 0.58 0.60]pink
% Iteration
figure;
x_axis = results(1:20,mutIndex);
y1 = results(1:20,itIndex);
p = polyfit( x_axis, y1, 6);

y2 = polyval(p, x_axis);
plot(x_axis, y2, 'b', 'Linewidth', 2);
title('Mutation vs. Number of iterations');
xlabel('Standart deviation of mutation');
ylabel('Number of iterations');

hold on;
plot(x_axis, y1, 'Color','r' );
ax = gca;
ax.FontSize = 12;     % set font size for axes labels



% shadedErrorBar( results(1:77,ncIndex), results(1:77,itIndex), results(1:77, [13,15] ) )



