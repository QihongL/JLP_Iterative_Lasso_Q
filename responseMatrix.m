function [ response_total, nSolution ] = responseMatrix( subNum, cv, type )
% Get response matrix
% This version works with getBeta, which only exclude the last iteration 


% load the results
load(['fitStore_' type '.mat'])


% load the data
[X,metadata] = loadMRIData('jlp',subNum);

% Get the test set 
holdout = metadata(subNum).CVBLOCKS(:,cv);
Xtest = X(holdout,:);

nSolution = 3;

% Loop over 3 labels
for i = 1:3
    if i == 1
        label = 'TrueFaces';
    elseif i == 2
        label = 'TruePlaces';
    elseif i == 3
        label = 'TrueThings';
    end 

    % Get beta vector
    [b,a] = getBeta(subNum, cv, label, type);
    if sum(b) == 0 
        response.(label) = zeros(45,1);
%         disp('no voxel was being selected')
        nSolution = nSolution - 1;
    else
        response.(label) = Xtest * b + a;
    end

end

response_total = [response.TrueFaces, response.TruePlaces, response.TrueThings];

end