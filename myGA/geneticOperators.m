function children=geneticOperators(parents,NC,P,intervalScalar,sd_mut,sd_mut_rec,V,M,f,lb,ub)

    PS=size(parents,1);
    
    children = zeros(NC,V+M+2);
    for j=1:NC
        % select parents randomly
        twoParentsRows = randi([1,PS],2,1);
        twoParents = parents(twoParentsRows,1:V);
        firstParent = twoParents(1,1:V);
        secondParent = twoParents(2,1:V);
       
        %% Recombination or mutation?
        if rand() < P  %recombination
             if intervalScalar ~=0.0  %use interval algorithm
%             disp('recomb')
                t= randi([0,1],1,V);
                %don't interpolate all genes, only some. recombination with
                %probability P
                interval = [firstParent; secondParent];
                intervalCenter = (interval(1,:) + interval (2,:))/2;
                intervalZeroCentered = interval -  intervalCenter;
                intervalZeroCenteredScaled = intervalZeroCentered * intervalScalar;
                intervalScaled = intervalZeroCenteredScaled + intervalCenter;

                child = t .* intervalScaled(1,:) + (1-t) .* intervalScaled(2,:);
             else
%                  disp('SBX')
             %% binary: concatenate parents
%                 splitLocation = randi([1,V]);
%                 child = [firstParent(1,1:splitLocation-1), secondParent(1,splitLocation:V)];

                %% RCU takes some genes from one parent, some from second parent. Do mutation on all genes afterward.
                a=randi([0 1],1,V); % set some random elements to 1
                b = 1-a;            % if one row has a 1, other one has 0 (you can't get from both parents at the same time
                parentMask = [a;b];  % 1 to select, 0 to not select
                genesMatrix = parentMask .* twoParents; % mask the parents with the binary matrix
                child = sum(genesMatrix,1);            % merge the two rows. Only one el per col is not 0, so just add rows
                % don't mutate all of them, only some
                nbMutated = randi([1 V],1,1);
                for i=1:nbMutated
                    mutated = randi([1 nbMutated],1,1);
                    mutation = sd_mut_rec*randn(1,1);
                    child(1,mutated) = child(1,mutated) + mutation;     % do some mutation
                end
             end
            
        else % mutation from parent 1 or parent 2
            if rand() <= 0.5
                child = sd_mut.*randn(1,V) + firstParent;
        	else
                child = sd_mut.*randn(1,V) + secondParent;
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
