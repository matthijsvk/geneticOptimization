function population=evaluatePopulation(population,f,V,M,lb,ub)
    ranks = population(:,V+M+1); %save to restore it after normalization
    crowdingDistance = population(:,V+M+2);
   
    populationCore = population(:,1:V);
    populationUnnormalized = unnormalizePopulation(populationCore, lb,ub);

    % onedimensional M: scores = f(population)
    popLength = size(populationUnnormalized,1);
    scores = zeros(popLength,M);
    for i=1:popLength
        scores(i,:) = f(populationUnnormalized(i,1:V));
    end

    %population = normalizePopulation(population, lb,ub);
    population = [populationCore,scores,ranks,crowdingDistance];

end
