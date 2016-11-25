function sorted=sortPopulation(unsorted,V,M)

% if M==1
%    % To be written
%     sorted = sortrows(unsorted,V+1);
% else % Multi-objective case : non-domination sorting
    
    %% Ranking  
    nbRanks = 3;
    
    popSize = size(unsorted);
    popLength = popSize(1);
    rankColumn = V+M+1;
    
    for currentRank=1:nbRanks-1 % which ones do not belong in rank 1? move them to rank 2
        unsorted = sortrows(unsorted,rankColumn);
        for currentPointIndex=1:popLength
            currentPoint = unsorted(currentPointIndex,:);
            if currentPoint(1,rankColumn) == currentRank
                % check all point in rank 1 to see if they're dominating
                % the current point. If so, move it  the current point to rank 2
                for checkPointIndex=1:popLength
                    checkPoint = unsorted(checkPointIndex,:);
                    if checkPoint(1,rankColumn) == currentRank
                        % dominating if all values are lower
                        comparison = currentPoint(1,V+1:V+M) - checkPoint(1,V+1:V+M) >= -eps ;
                        if min(currentPoint(1,V+1:V+M) == checkPoint(1,V+1:V+M))== 0
                            % only if comparison is all 1's we move it to the
                            % next rank (only then some other point is
                            % dominating)
                            if min(comparison) == 1 % all ones, so currentPoint is being dominated
                                currentPoint(1,rankColumn) = currentRank+1;
                                % store the current point
                                unsorted(currentPointIndex,:) = currentPoint(1,:);
                                break;
                            end
                        end
                    end
                end
            end
        end
    end
    
    % sort based on rank
    sorted = sortrows(unsorted,rankColumn);
    sorted = unique(sorted,'rows','stable');
    popSize = size(sorted,1);
    
    %% Crowding Distance
    %V+M+1 = rank,  V+M+2 = crowdingDistance
    crowdingDistanceColumn = V+M+2;
    rankEndIndex = popSize;
    rankStartIndex = 1;
    
    for rank=1:nbRanks
        % some administration
        rankEndIndex = popSize;
        for i=rankStartIndex:popSize
            if sorted(i,rankColumn)==rank+1
                rankEndIndex = i-1;
                break
            end
        end
        % rankEndIndex is the position of the last element of this rank
        for i=rankStartIndex:rankEndIndex
            sorted(i,crowdingDistanceColumn) = 0;  %V+M+1 = rank,  V+M+2 = crowdingDistance
        end
        
        % recalculate the crowding distances according to the paper NSGA II
        for m=1:M
            sorted(rankStartIndex:rankEndIndex,:) = ...
                   sortrows(sorted(rankStartIndex:rankEndIndex,:), V+m);
            
            sorted(rankStartIndex(1), crowdingDistanceColumn) = Inf;
            sorted(rankEndIndex(1), crowdingDistanceColumn) = Inf;
            
            f_max = max(sorted(rankStartIndex:rankEndIndex,V+m));
            f_min = min(sorted(rankStartIndex:rankEndIndex,V+m));

            for i=rankStartIndex+1:rankEndIndex-1
                sorted(i,crowdingDistanceColumn) = sorted(i,crowdingDistanceColumn) + ...
                            ( sorted(i+1,V+m) - sorted(i-1,V+m) ) / (f_max - f_min) ;
            end
        end
        
        sorted(rankStartIndex:rankEndIndex,:) = ...
            sortrows(sorted(rankStartIndex:rankEndIndex,:), -crowdingDistanceColumn);
        if rankEndIndex == popSize % no more new ranks
            break;
        end
        rankStartIndex = rankEndIndex + 1;
    end

end
