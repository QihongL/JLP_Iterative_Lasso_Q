%% Compute the overlap using distance matrix

% load the data matrix X
% 1st column = subject ID
% 2 - 4th colmn = xyz
% 5th column = CV consistency 
load('coord_consistency.mat');

% select voxels that above certian CV consistency threshold
CVConsistency = 9;

% Get the logical index for thresholded voxel
indexThresholded = X(:,5) > CVConsistency;
% Select voxels that above certian consistency
Xthresholded = X(indexThresholded, 1:5);

% compute the distance matrix
D = pdist(Xthresholded(:, 2:4));
D = squareform(D);
% imagesc(D);


