function [stopFlag, crowdingFlag] =stopCriterion(it,populationRank, population, crowdingDistanceColumn, N) %,oldPopulationObjectives, newPopulationObjectives, notChangingLimit,V,M)
% Return :  1 if the GA must continue 
%           0 if the GA must stop
    crowdingFlag = 0;
    stopFlag=0;
    if it > 10000
        stopFlag=1;
    end

    % all rank 1 -> use inefficient crowding distance
    %               -> each time you remove a point, recalculate scores, so
    %               as not to delete many point close together
    if populationRank == 1
        crowdingFlag = 1;
        % if median of crowding distance < x, most values are well
        % distributed -> we can stop
        cdVector = population( :, crowdingDistanceColumn );
        cdVector = cdVector( cdVector < Inf ); 
        
        % idea 1: avg and mean must be lower than limit
        % problem: different stopLimit for each number of population+
        % often takes very long
%         if (mean(cdVector) > 0.135) && ...
%               (median(cdVector) > 0.135)
%             stopFlag = 1;
%         end
        
        % idea 2: lowest crowding distance has to be x% of the average
        % (without counting Inf of course)
%         if (min(cdVector) > 0.75*median(cdVector )) ...
%             && ( max(cdVector) < 1.25*median(cdVector) )
%             stopFlag = 1;
%         end
        
%         if ( mean(cdVector) / (max(cdVector) - min(cdVector)) > 1.5) 
%             stopFlag = 1;
%             disp(['We re stopping at the ',num2str(it), ' th iteration']);
%         end
        
        % idea 3: don't take the absolute max and min, but 25th percentile from top
        % and bottom
%         if (min(cdVector) > 0.8*mean(cdVector(N/4:end)) ) ...
%             && ( min(cdVector(1:N/4)) < 1.25*mean(cdVector(N/4:end)) )
%             stopFlag = 1;
%         end
        
        % idea 4: values higher than middle of 1 and avg(cdVector) are not
        % considered
        cdVectorReduced = cdVector(cdVector < 0.5*(1+median(cdVector)) );
        
        if (min(cdVectorReduced) > 0.75*median(cdVectorReduced ) ) ...
            && ( max(cdVectorReduced) < 1.25*median(cdVectorReduced) )
            stopFlag = 1;
        end
    end
end

  % USING THE MONTE CARLO METHOD
  % for the old and new population: 
    %   - get bounding box for both (take largest element in each
    %   dimension, doesn't matter if its' in old or new)
    %   - generate K points in this box
    %   - calculate area under both the old and new population:
    %       - point is under area of a population if it's not being dominated 
    %       by any point in the popolation.
    
% oldPopulationObjectives
%     newPopulationObjectives
%     
%     % two rows, M columns (dimensions of objective function). First row = maximum, second row = minium for
%     boundingBox = findBoundingBox([oldPopulationObjectives;newPopulationObjectives])
%     
%     % the dimension of the problem
%     dim = M;
%     % sample size
%     N = 100;
%     % generate the random samples. Use different bounds for each dimension   
%     X = boundingBox(2,:) + (boundingBox(1,:)-boundingBox(2,:)).*rand(N,dim)
%     
%     r1=isDominated(X, oldPopulationObjectives) 
%     r2=isDominated(X, newPopulationObjectives) 
% 
%     areaOld = sum(r1)/N
%     areaNew = sum(r2)/N
%     
%     if abs(areaOld - areaNew) - notChangingLimit >= -eps
%         flag = 0;    
%     end
% 
% % value = 1 if under area, otherwise 0
% function value  = isDominated(testPoints, population)
%     popSize = size(population);
%     popLength = popSize(1);
%     M = popSize(2); %nb of dimensions
% 
%     value = zeros(size(testPoints,1),1)
%         
%     for j=1:size(testPoints(1))
%         currentPoint = testPoints(j,:);
%         for checkPointIndex=1:popLength
%             checkPoint = population(checkPointIndex,:);
%             comparison = currentPoint(1,1:M) - checkPoint(1,1:M) >= -eps ;
%             if (min(currentPoint(1,1:M) == checkPoint(1,1:M))== 0) && min(comparison) == 1
%                 % all ones, so currentPoint is being dominated
%                 value(j) = 1;
%                 break;
%                
%             end
%         end
%     end
% end
% 
% function boundingBox = findBoundingBox(population)
%     M = size(population, 2);
%     boundingBox = zeros(2,M);
%     for i=1:M
%         % max and min edge of both populations in this dimension
%         boundingBox(1,i) = max(population(:,i));
%         boundingBox(2,i) = min(population(:,i));
%     end
% end

