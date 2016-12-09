clear all;
clc;
close all;
format short g;

addpath('interfaceEldo');
eldo_setup;
minWidth = 0.27*1e-6;
maxWidth = 27*1e-6;
minLength = 0.18*1e-6;
maxLength = 27*1e-6;


% circuit 3
% %    R1     R2      w1          w2          wbias       Vbias   Vcm
% lb=[ 1e3    1e3     minWidth   minWidth   minWidth   0       0];
% % ub=[ 10e3   10e3    maxWidth   maxWidth   maxWidth   1.8     1.8] ;

% circuit4
% %    R1       w1            wbias       Vbias   Vcm
lb=[ 1e3      minWidth     minWidth   0       0];
ub=[ 10e4     maxWidth     maxWidth   1.8     1.8] ;

% circuit 5
%    wNmos            lNmos          w2          l2          wbias       Vbias  
% lb=[ minWidth     minLength   minWidth   minLength  minWidth      0];
% ub=[ maxWidth     maxLength   maxWidth   maxLength  maxWidth    1.8] ;

% circuit 6
%    1              2           3           4       5           6       7
%    w5, w6            l5,l6   w7,w8      l6,l7      w9       R         l5                                                                                                                                                                     
% lb=[ minWidth     minLength   minWidth   minLength  minWidth   1   1   1    1   1];
% ub=[ maxWidth     maxLength   maxWidth   maxLength  maxWidth   1e9 1e9 1e9  1e9 1e9];

V = length(lb);
M = 2; %GBW, BW, Power

% % just for testing
% x=rand(10,7);
% for j=1:10
%     x(j,:)=lb+(ub-lb).*x(j,:);
% end
%ac=interfaceEldo('circuit3',x)

% circuit 3: 7 parameters
% circuit 4: 5 parameters (w1 = w2; R1 - R2)
res=myGA(@(x) interfaceEldo('circuit4',x),V,M,lb,ub);
