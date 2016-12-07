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


elseif V>=2
    x = population(:,V+1:V+M);
    if M == 1
        plot(x(:,1));
        
    elseif M == 2
        plot(x(:,1),x(:,2),'*');

        title(['Search Space V>2, Iteration ' num2str(it)]);
        xlabel('x1');
        ylabel('x2');
        %axis([lb(1) ub(1) lb(2) ub(2)]);

    elseif M== 3
        
        scatter3(x(:,1),x(:,2),x(:,3),'filled');
    else
        disp('the objective dimensionality is too high, cant be plotted');
    end
   
end
