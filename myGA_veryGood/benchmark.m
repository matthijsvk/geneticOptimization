function f=benchmark(nb,x,V)
% This function evaluates the functions used in these sessions 
% nb : number of the function (see below).
% x : vector of variables.

switch nb

	case 1
		% Function x^2 in R^2
		f=sum(x.^2,2);

	case 2 % Variation on x^2 in R^2
        
		if sum((x-[2 2]).^2) < 0.5  
			f=-1+4*sum((x-[2 2]).^2);
		elseif sum((x-[-1 3]).^2) < 0.25  
				f=-3+20*sum((x-[-1 3]).^2);
		else
		    f=sum(x.^2,2);    
		end

        case 3  %ZDT4
		% http://people.ee.ethz.ch/~sop/download/supplementary/testproblems/zdt4/
	    	f(1)=x(1);
		g=1+10*(V-1);
		for i=2:6
		    g=g+(x(i))^2-10*cos(4*pi*x(i));
		end
		f(2)=g*(1-sqrt(x(1)/g));

    case 4 %ZDT6
% 		% http://people.ee.ethz.ch/~sop/download/supplementary/testproblems/zdt6/
% 		f = [];
% 		%% Objective function one
% 		f(1) = 1 - exp(-4*x(1))*(sin(6*pi*x(1)))^6;
% 		sum1 = 0;
% 		for i = 2 : 6
% 		    sum1 = sum1 + x(i)/4;
% 		end
% 		%% Intermediate function
% 		g_x = 1 + 9*(sum1)^(0.25);
% 		%% Objective function one
% 		f(2) = g_x*(1 - ((f(1))/(g_x))^2);
        % online I found this implementation (vectorized)
        f=[];
        x1 = x(:,1);
        f1 = 1.0 - (exp(-4.0 .* x1) .* (sin(6.0 .* pi .* x1) .^6.0));
        gvals = x(:,2:end);
        g = sum(gvals,2);
        g = g./ 9.0; g = g.^ 0.25; g = 1.0 + (9.0 .* g);
        h = ones(length(g),1) - ((f1./g) .^ 2.0);
        f2 = g.*h;
        f(:,1) = f1;
        f(:,2) = f2;
        
    case 5 % optimize the algorithm itself
        N = x(1);
        P = x(2);
        sd_mut = x(3);
        NPMult = x(4);
        NCMult = x(5);
        intervalScalar = x(6);
        
        % print so we can follow what's happening
        N = round(N);
        NP = round(N * NPMult);
        NC = round(N * NCMult);
        fprintf('P: %5.2f | sd_mut: %5.2f | N: %5.2f | NP: %5.2f | NC: %5.2f | interval: %5.2f \n', P,sd_mut,N,NP,NC,intervalScalar);
        
        lb=  zeros(1,6);
        ub= ones(1,6); 
        V = length(lb);
        M = 2;
        
        % benchmark value should be runtime till convergence. Run on ZDT6
        totIt = 0;
        totRunTime = 0;
        for i=1:10
            [it,runTime]= myGAEvaluator(@(x) benchmark(4,x,V),V,M,lb,ub,P, sd_mut, N, NPMult, NCMult, intervalScalar);
            totIt = totIt + it;
            totRunTime = totRunTime + runTime;
        end
        it = totIt / 10.0;
        runTime = totRunTime / 10.0;
        fprintf('it: %5.2f |\t runTime: %5.2f \n', it, runTime);
        f(1) = runTime;
end


end 
