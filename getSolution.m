function [ solution ] = getSolution( subNum, type, label, lowerBound )
%Get the solution for a given subject
% The original solution will be a vector of size (nvoxel, 1), with range [0,10]
% The output solution will set the voxel selected less than N times to 0

    % load the results
    load(['JLP_' type '_' label '.mat'])

    % Determine which iteration to pick
    STOPPING_RULE = 1;
    iterNum = size(result(subNum).used,2) - STOPPING_RULE;

    %% Get voxels 

    % Raw solution
    solution = sum(result(subNum).used{iterNum})';

    % Identify voxels that were being selected more than N times
    logicalFactor = solution >= lowerBound;
    solution = solution .* logicalFactor;

end

