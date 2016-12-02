function sorted=sortPopulationCrowding(unsorted,V,M,N)

if M==1
   % To be written
    sorted = sortrows(unsorted,V+1);
else % Multi-objective case : non-domination sorting
    
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
                        if min(currentPoint(1,V+1:V+M) == checkPoint(1,V+1:V+M))== 0 % check that it doesn't compare against itself
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
    
    % remove everything not rank 1 (= new children that aren't rank 1)
    % if prev it, crowdDistFlag = 1, then we execute this function after
    % adding new childeren, but they can be higher rank, so need to be
    % cropped.
    popSize = size(sorted,1);
    looper = 1;
    while looper<=popSize
        if (sorted(looper,rankColumn) > 1.0)
            sorted = removerows(sorted,looper );
            looper = looper -1;
        end
        looper  = looper +1;
        popSize = size(sorted,1);
    end
    popSize = size(sorted,1);
    
    % remove weird point at the top left 
%     for i=1..5 for each point in top 5
%         top5 = population(1:5,1:V);
%         for j=1..4 %compare to others in top 5
            
            
    %% Crowding Distance
    %V+M+1 = rank,  V+M+2 = crowdingDistance
    crowdingDistanceColumn = V+M+2;
    rankEndIndex = popSize;
    rankStartIndex = 1;
    
    while size(sorted,1) > N
            rankEndIndex = popSize;
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
            
            % remove last element
            sorted = sorted(1:end-1,:);
            popSize = size(sorted,1);
    end
        
end




