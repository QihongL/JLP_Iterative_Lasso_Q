%% dPrime 
% This function compute the element-wise d prime measure between 2 matrix
% 
% @param: hitMatrix - the matrix for hit rate
% @param: falseMatrix - the matrix for false alarm rate
% @return: dPrimeMatrix - the matrix contains the d prime measure
% 
% Depedency on other code: NA

function [ dPrimeMatrix ] = dPrime( hitMatrix, falseMatrix )
% A function that computes D prime
% @ param hitMatrix * falseMatrix: m * n matrix, with hit/false rates 
%     each row (m) is a subject, each column (n) is a CV block
% @ return dPrime Matrix

    VERY_SMALL_NUM = 1e-5;
    % change NaN to 0
    hitMatrix(isnan(hitMatrix)) = 0;
    falseMatrix(isnan(falseMatrix)) = 0;
    % change 0 & 1 to small number 
    hitMatrix(hitMatrix == 0 ) = VERY_SMALL_NUM;
    falseMatrix(falseMatrix == 0) = VERY_SMALL_NUM;
    hitMatrix(hitMatrix == 1 ) = 1 - VERY_SMALL_NUM;
    falseMatrix(falseMatrix == 1) = 1 - VERY_SMALL_NUM;

    % compute d prime
    dPrimeMatrix = norminv(hitMatrix) - norminv(falseMatrix);
    % remove NaN (typically because no voxel to fit the final model)
    dPrimeMatrix(isnan(dPrimeMatrix)) = VERY_SMALL_NUM;

end