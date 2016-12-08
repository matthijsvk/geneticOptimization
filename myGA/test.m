 V= 6;
a = rand(1,V);
b= randn(1,V);
twoParents = [a;b]

%% SBX take some genes from one parent, some from second parent. Do mutation on all genes afterward.
                a=randi([0 1],1,V); % set some random elements to 1
                b = 1-a;            % if one row has a 1, other one has 0 (you can't get from both parents at the same time
                parentMask = [a;b];  % 1 to select, 0 to not select
                genesMatrix = parentMask .* twoParents; % mask the parents with the binary matrix
                genes = sum(genesMatrix,1)             % merge the two rows. Only one el per col is not 0, so just add rows
                % don't mutate all of them, only some
                child = genes;
                nbMutated = randi([1 V],1,1);
                for i=1:nbMutated
                    mutated = randi([1 nbMutated],1,1)
                    mutation = sd_mut_rec*randn(1,1);
                    child(1,mutated) = genes(1,mutated) + mutation;     % do some mutation
                end
                disp(child)