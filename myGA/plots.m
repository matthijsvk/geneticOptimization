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
itIndex = 7;
timeIndex = 8;


P = 0.5;
mut = 0.01;
NP = 12;
NC = 24;

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
mP = results( results(:, pIndex) == P, :);
mP_NP = mP( mP(:, npIndex) == NP, :);
mP_NP_NC = mP_NP( mP_NP(:, ncIndex) == NC, :);
% mut vs time
mut_axis = mP_NP_NC(:, mutIndex);
mut_time = mP_NP_NC(:, timeIndex);
figure;
plot(mut_axis,mut_time);
title('mutation');
% mut vs iterations
mut_axis = mP_NP_NC(:, mutIndex);
mut_it = mP_NP_NC(:, itIndex);
figure;
plot(mut_axis,mut_it);
title('mutation');
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

figure;
plot( results(1:5,ncIndex), results(1:5,timeIndex) ); 


% dev001 = results( results(:,2) == 0.01, :);
% 
% dev001_NP26 = dev001( dev001(:,4) == 26, :);
% dev001_NP26(:,1) = 10*dev001_NP26(:,1);
% dev001_NP26_P06 = dev001_NP26( dev001_NP26(:,1) == 6, :);

