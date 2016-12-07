function illustratePopulation(population,V,M,lb,ub,it)

if V==2
    
    for j=1:size(population,1)
        x(j,1:V)=lb+(ub-lb).*population(j,1:V);
    end
    
    plot(x(:,1),x(:,2),'*');
    title(['Search Space, Iteration ' num2str(it)])
    xlabel('x1');
    ylabel('x2');
    axis([lb(1) ub(1) lb(2) ub(2)]);


elseif V>2
    if M==2
        index=1;
        for j=1:size(population,1)
            %if population(j,V+M+1) == 1
                x(index,1:V)=lb+(ub-lb).*population(j,1:V);
                x(index,V+1:V+M) = population(j,V+1:V+M);
            %end
            index = index + 1;
        end
        plot(x(:,V+1),x(:,V+2),'*');


        title(['Search Space, Iteration ' num2str(it)]);
        xlabel('x1');
        ylabel('x2');
        %axis([lb(1) ub(1) lb(2) ub(2)]);
    end

   
end
