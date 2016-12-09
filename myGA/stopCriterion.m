function [stopFlag, crowdingFlag] =stopCriterion(it,populationRank, population, crowdingDistanceColumn, M) %,oldPopulationObjectives, newPopulationObjectives, notChangingLimit,V,M)
% Return :  1 if the GA must continue 
%           0 if the GA must stop
    crowdingFlag = 0;
    stopFlag=0;
    if it > 500
        stopFlag=1;
    end

    % all rank 1 -> use inefficient crowding distance
    %               -> each time you remove a point, recalculate scores, so
    %               as not to delete many point close together
    if populationRank == 1
        if M>1
            crowdingFlag = 1;
        end
        % if median of crowding distance < x, 
        % most values are well distributed and we can stop
        % lowest crowding distance has to be x% of the average
        % also use Coefficient of Variation: https://en.wikipedia.org/wiki/Coefficient_of_variation
        
        cdVector = population( :, crowdingDistanceColumn );
        % remove infinites of extemities because we want median and average values
        cdVector = cdVector( isfinite(cdVector));
        CV=std(cdVector)/mean(cdVector);
        if (min(cdVector) > 0.75*median(cdVector )) ...
            & ( max(cdVector) < 1.25*median(cdVector) ) || (CV < 0.15)
            stopFlag = 1;
        end
        
        
    end
end

