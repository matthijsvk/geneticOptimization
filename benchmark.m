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
		% http://people.ee.ethz.ch/~sop/download/supplementary/testproblems/zdt6/
		f = [];
		%% Objective function one
		f(1) = 1 - exp(-4*x(1))*(sin(6*pi*x(1)))^6;
		sum1 = 0;
		for i = 2 : 6
		    sum1 = sum1 + x(i)/4;
		end
		%% Intermediate function
		g_x = 1 + 9*(sum1)^(0.25);
		%% Objective function one
		f(2) = g_x*(1 - ((f(1))/(g_x))^2);
		
end


end 
