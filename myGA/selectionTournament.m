function selection=selectionTournament(population,NP,V,M, crowdingDistanceFlag)
    %% Tournament Selection
    popSize = size(population);
    popSize = popSize(1);
    
    selection = zeros(NP,V+M+2);
    if crowdingDistanceFlag == 1 %we converged, now select top crowding distancers
        selection = population(3:min(popSize,NP)-2,:);
        return;
    end
    for i=1:NP
        competitorsRows = randi([1,popSize],2,1);
        first = population(competitorsRows(1),:);
        second = population(competitorsRows(1),:);
        selected = selectBest(first,second,V, M);
%         while rand() > becomeParentProbability(selected(1,:),V,M)
%             competitorsRows = randi([1,popSize],2,1);
%             first = population(competitorsRows(1),:);
%             second = population(competitorsRows(1),:);
%             selected = selectBest(first,second,V, M);
%         end
        
        selection(i,:) = selected;
    end

    %% Select best NP_best and add some random others to prevent local
%     NP_best = round(NP * 0.8);
%     NP_random = NP - NP_best;
%     selection = population(1:NP_best,:);
%     
%     population_without_best = population(NP_best+1:end,:);
%     c = randperm(length(population_without_best),NP_random); 
%     random_selected = population_without_best(c,:);  % output matrix
%     
%     selection(i,:) = selected;
end

function probTotal = becomeParentProbability(a,V,M)
    if M==1
        rankColumn = V+1; %only one column with scores
    else
        rankColumn = V+M+1;
    end
    crowdingDistanceColumn = rankColumn + 1;
    rankA = a(1,rankColumn);
    cdA = a(1,crowdingDistanceColumn);
    if rankA == 1
        probTotal = 1.0;
    elseif rankA == 2
        probTotal = 0.5 + cdA;
    elseif rankA == 3
        probTotal = 0.1 + cdA;
    else
        probTotal = 1.0/(rankA^4)+cdA; 
    end
    probTotal = max(min(probTotal,1.0),0);
end


function selected = selectBest(a,b,V, M)
    if M==1
        rankColumn = V+1; %only one column with scores
    else
        rankColumn = V+M+1;
    end
    crowdingDistanceColumn = rankColumn + 1;
    
    rankA = a(1,rankColumn);
    rankB = b(1,rankColumn);
    if rankA < rankB % lower rank = better
        selected = a;
    elseif rankB < rankA
        selected = b;
    else %rankA == rankB
        if (a(1,crowdingDistanceColumn) > b(1,crowdingDistanceColumn))
            selected = a;
        else
            selected = b; % CD(b) >= CD(a)
        end
    end
end