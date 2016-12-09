function f=benchmark(nb,x,V)
% This function evaluates the functions used in these sessions 
% nb : number of the function (see below).
% x : vector of variables.

switch nb

	case 1
		% Function x^2 in R^2
        %f=sum(x.^2,2);
       

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
% 	    	f(1)=x(1);
% 		g=1+10*(V-1);
% 		for i=2:6
% 		    g=g+(x(i))^2-10*cos(4*pi*x(i));
% 		end
% 		f(2)=g*(1-sqrt(x(1)/g));
        
        % in vectorized form
        f(:,1)=x(:,1);
        g = zeros(size(x,1));
		g(:,1)=1+10*(V-1);
		for i=2:6
		    g(:,1)=g(:,1)+(x(:,i)).^2-10*cos(4*pi.*x(:,i));
		end
		f(:,2)=g(:,1).*(1-sqrt(x(:,1)./g(:,1)));

    case 4 %ZDT6
		% http://people.ee.ethz.ch/~sop/download/supplementary/testproblems/zdt6/
		f = [];
		%% Objective function one
		f(:,1) = 1 - exp(-4*x(1))*(sin(6*pi*x(1)))^6;
		sum1 = 0;
		for i = 2 : 6
		    sum1 = sum1 + x(i)/4;
		end
		%% Intermediate function
		g_x = 1 + 9*(sum1)^(0.25);
		%% Objective function one
		f(2) = g_x*(1 - ((f(1))/(g_x))^2);
        
        % in vectorized form
%         f=[];
%         x1 = x(:,1);
%         f1 = 1.0 - (exp(-4.0 .* x1) .* (sin(6.0 .* pi .* x1) .^6.0));
%         gvals = x(:,2:end);
%         g = sum(gvals,2);
%         g = g./ 9.0; g = g.^ 0.25; g = 1.0 + (9.0 .* g);
%         h = ones(length(g),1) - ((f1./g) .^ 2.0);
%         f2 = g.*h;
%         f(:,1) = f1;
%         f(:,2) = f2;
        
        
    case 5 % optimize the algorithm itself
        P = x(:,1);
        sd_mut = x(:,2);
        sd_mut_rec = x(:,3);
        N = x(:,4);
        NPMult = x(:,5);
        NCMult = x(:,6);
        
        % print so we can follow what's happening
        N = round(N);
        NP = round(N .* NPMult);
        NC = round(N .* NCMult);
        
        s = size(x,1);
        lb= zeros(s,6);
        ub= ones(s,6); 
        V = 6;
        M = 2;
        
        f1 = zeros(s,1);f2 = zeros(s,1);
        % Parallelize the for loop
        parfor i = 1 : s
            nbTests = 1; % just 1 for faster convergence 
            % benchmark returns runtime ant #iterations till convergence. Run on ZDT6
            disp('Testing the following configuration: ')
            fprintf('   P  \t sd_mut\t sd_rec\t N \t NP \t NC \n');
            disp([ P(i,:), sd_mut(i,:), sd_mut_rec(i,:),N(i,:), NP(i,:), NC(i,:)]);
            totIt = zeros(nbTests,1);
            totRunTime = zeros(nbTests,1);
            for j=1:nbTests
                [it,runTime]= myGA_evaluator(@(y) benchmark(4,y,V),V,M,lb(i,:),ub(i,:),P(i,:), sd_mut(i,:),sd_mut_rec(i,:), N(i,:), NP(i,:), NC(i,:));
                totIt(j) =  it;
                totRunTime(j) = runTime;
            end
            itAvg = mean(totIt) ;
            runTimeAvg = mean(totRunTime);
            fprintf('\t itAvg: %5.0f |\t runTime/N: %5.4f \n', itAvg, runTimeAvg)
            f1(i) = runTimeAvg;
            f2(i) = itAvg;
        end 
        f=[f1,f2];
end


end 
