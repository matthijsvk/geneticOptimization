function selection=selectionTournament(population,NP,V,M)
    %% Tournament Selection
    popSize = size(population);
    popSize = popSize(1);
    
    selection = zeros(NP,V+M+2);
    
%% 1. Binary tournament
    for i=1:NP
        competitors = population(randi([1,popSize],2,1),:);
        selected = selectBest(competitors(1,:), competitors(2,:), V, M);
        selection(i,:) = selected;
    end

%% 2. Select best NP_best and add some random others to prevent local
%     NP_best = round(NP * 0.8);
%     NP_random = NP - NP_best;
%     selection = population(1:NP_best,:);
%     
%     population_without_best = population(NP_best+1:end,:);
%     c = randperm(length(population_without_best),NP_random); 
%     selection = [selection; population_without_best(c,:)];  % output matrix
    
%% 3. Better rank = more probability for parenthood
%     for i=1:NP
%         competitorsRows = randi([1,popSize],2,1);
%         first = population(competitorsRows(1),:);
%         second = population(competitorsRows(1),:);
%         selected = selectBest(first,second,V, M);
%         while rand() > becomeParentProbability(selected(1,:),V,M)
%             competitorsRows = randi([1,popSize],2,1);
%             first = population(competitorsRows(1),:);
%             second = population(competitorsRows(1),:);
%             selected = selectBest(first,second,V, M);
%         end
%         selection(i,:) = selected;
%     end

end

function probTotal = becomeParentProbability(a,V,M)
    if M==1
        rankColumn = V+1; %only one column with scores
    else
        rankColumn = V+M+1;
    end
    rankA = a(1,rankColumn);
    
    probTotal = 1.0/(rankA^2); 
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
