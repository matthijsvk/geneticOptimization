clear all;
clc;
close all;
format short g;

addpath('interfaceEldo');
eldo_setup;
pMinWidth = 0.27*1e-6;
nMinWidth = 0.18*1e-6;
nMaxWidth = 50*1e-4;
% %    R1     R2      w1          w2          wbias       Vbias   Vcm
% lb=[ 1e3    1e3     nMinWidth   nMinWidth   nMinWidth   0       0];
% ub=[ 10e3   10e3    nMaxWidth   nMaxWidth   nMaxWidth   1.8     1.8] ;

%    R1       w1            wbias       Vbias   Vcm
lb=[ 1e3      nMinWidth     nMinWidth   0       0];
ub=[ 10e4     nMaxWidth     nMaxWidth   1.8     1.8] ;

V = length(lb);
M = 1; %GBW, BW, Power

% % just for testing
% x=rand(10,7);
% for j=1:10
%     x(j,:)=lb+(ub-lb).*x(j,:);
% end
%ac=interfaceEldo('circuit3',x)

% circuit 3: 7 parameters
% circuit 4: 5 parameters (w1 = w2; R1 - R2)
res=myGA(@(x) interfaceEldo('circuit4',x),V,M,lb,ub);
