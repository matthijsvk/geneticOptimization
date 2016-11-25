function children=geneticOperators(parents,NC,P,intervalScalar,sd_mut,V,M,f,lb,ub)

    PS=size(parents,1);
    
    children = zeros(NC,V+M+2);
    for j=1:NC
        % select parents randomly
        twoParentsRows = randi([1,PS],2,1);
        twoParents = parents(twoParentsRows,:);
        firstParent = twoParents(1,1:V);
        secondParent = twoParents(2,1:V);

        %% Recombination or mutation?
        if rand() < P  %recombination
            
            t= randi([0,1],1,V);
            %don't interpolate all genes, only some. recombination with
            %probability P
            interval = [firstParent; secondParent];
            intervalCenter = (interval(1,:) + interval (2,:))/2;
            intervalZeroCentered = interval -  intervalCenter;
            intervalZeroCenteredScaled = intervalZeroCentered * intervalScalar;
            intervalScaled = intervalZeroCenteredScaled + intervalCenter;

            child = t .* intervalScaled(1,:) + (1-t) .* intervalScaled(2,:);
            
             %% binary: concatenate parents
%             splitLocation = randi([1,V]);
%             child = [firstParent(1,1:splitLocation-1), secondParent(1,splitLocation:V)];

        else % mutation from parent 1 or parent 2
            if rand() <= 0.5
                child = sd_mut.*randn(1,1) + firstParent;
        	else
                child = sd_mut.*randn(1,1) + secondParent;
            end   
        end
        
        % clip all the values in [0,1]
        child = max(0,child);
        child = min(1,child);

        % rank of the child is 1 to start off
        child(1,V+M+1) = 1;
        % crowding distance of child is 0 to start off
        child(1,V+M+2) = 0;

        % add to children matrix
        children(j,:)= child; 
    end
    % evaluate the children
    children = evaluatePopulation(children,f,V,M,lb,ub);
end
