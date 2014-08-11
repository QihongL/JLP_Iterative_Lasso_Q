%% Get beta vectors
function [beta, intercept] = getBeta( subNum, cv, label ) 
% This is a helper function for the 'winner take all' classifer
% It is going to get the beta vectors for 3 classifers 
    
    %% Load the data and the results
    type = 'HF';
    [X,metadata] = loadMRIData('jlp',subNum);
    load(['JLP_' type '_' label '.mat'])    



    %% Check the inputs
    
    % cv & subNum should be smaller than 10
    if cv > 10
        disp('WARNING: cv cannot be bigger than 10, since there are only 10 cv blocks.')
    else if subNum > 10
            disp('WARNING: subNum cannot be bigger than 10, since there are only 10 subjects.')
        end
    end
    
    % The beta does exist if there is no final ridge 
    if size(result(subNum).used,2) < 3
        disp('The subject was not solvable, so the beta vector does not exist.')
    end



    %% Prepare for some parameters

    % Specify the stopping rule
    STOPPING_RULE = 2;

    % Find the iteration before the last 2 insignificant iteration
    iterNum = size(result(subNum).used,2) - STOPPING_RULE;

    % Find itercept term
    intercept = result(subNum).fitStore(1).finalLasso(cv).a0;

    % Find non zero beta
    nonZeroBeta = result(subNum).fitStore(1).finalLasso(cv).beta;

    
    
    %% Start to compute the beta vector

    % Preallocate resource for beta vector
    nvoxel = size(result(subNum).used{iterNum}(cv,:),2);
    beta = zeros(1,nvoxel);

    i = 1; j = 1;
    % iterate until it run over all voxels
    while i < size(result(subNum).used{iterNum}(cv,:),2)
        % Assertion
        if size(nonZeroBeta,1) ~=  sum(result(subNum).used{iterNum}(cv,:))
            disp('nonZeroBeta != used voxel, there might be a bug!')
            break;
        end

        % loop over all voxels
        for i = 1: size(result(subNum).used{iterNum}(cv,:),2)
            
            % if this voxel is used, assign the corresponding beta value
            if result(subNum).used{iterNum}(cv,i) ~= 0 
                beta(i) = nonZeroBeta(j);
                j = j + 1;
            end

        end

    end


    % Check some assertions 
    if sum(nonZeroBeta) ~= sum(beta)
        disp('The sum for nonZeroBeta and the final beta is not the same, there might be a bug!')
    end

    if size(X,2) ~= size(beta,2)
        disp('The length of the beta vector is not equal to the number of voxels, there might be a bug!')
        disp(['The number of voxels: ' num2str(size(X,2)) ])
        disp(['The length of the beta vector: ' num2str(size(beta,2))])
    end


    % Transpose the beta, which is not necessary
    beta = beta';

end