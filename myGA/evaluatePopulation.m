function population=evaluatePopulation(population,f,V,M,lb,ub)
    
    ranks = population(:,V+M+1); %save to restore it after normalization
    crowdingDistance = population(:,V+M+2);
    
    population = population(:,1:V);
%     disp('Begin evalPopulation')
%     disp(population)    
    population = unnormalizePopulation(population, lb,ub);
%     disp('evalPopulation')
%     disp(population)
    
    % onedimensional M: scores = f(population)
    popLength = size(population,1);
    scores = zeros(popLength,M);
    for i=1:popLength
        scores(i,:) = f(population(i,1:V));
    end
%     scores = f(population(:,1:V))
    
    population = normalizePopulation(population, lb,ub);
%     disp('end evalPopulation')
%     disp(population)
    population = [population,scores,ranks,crowdingDistance];
end
