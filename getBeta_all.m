%% Get beta vectors for all subjects
function [beta, intercept] = getBeta_all( subNum, cv, label, type ) 
% This is a helper function for the 'winner take all' classifer
% It is going to get the beta vectors for 3 classifers 
    
    %% Load the data and the results
%     type = 'HF';
    [X,metadata] = loadMRIData('jlp',subNum);
    load(['JLP_' type '_' label '.mat'])    

    
    
    iterNum = 1;
    
    
    % for a given subject in a given cv block...
    % The indices for used voxels
    indices = result(subNum).used{iterNum}(cv,:);
    % Number of voxels
    sum(result(subNum).used{iterNum}(cv,:))
    % The beta corrsepond to these voxels 
    non0beta = result(subNum).fitStore(iterNum).lasso(cv).beta
    % The intercept term
    intercept = result(subNum).fitStore(iterNum).lasso(cv).a0
   
    
    
    
    
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