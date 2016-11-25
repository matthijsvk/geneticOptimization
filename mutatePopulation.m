function population = mutatePopulation(population, mut_prob, sd_mut, V)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % MUTATION
    popLength = size(population,1);
    for i=1:popLength
        for j=1:V  %mutate each gene with probablilty 1-P
            if rand() < mut_prob  %probablilty 1-P to mutate a gene
                population(i,j) = sd_mut.*randn(1,1) + population(i,j);  %deviation + mean value
                population(i,j) = max(0,population(i,j));
                population(i,j) = min(1,population(i,j));
            end
        end
    end

end

