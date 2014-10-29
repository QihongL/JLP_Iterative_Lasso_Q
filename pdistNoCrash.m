%% This script is trying to split the computation of the distance matrix, in
% order to prevent the computer from crashing, when dimensionality of
% coordinate vector is high

%% Input : coordinates - n x 3 matrix
function [ distanceMatrix ] = pdistNoCrash( coordinates )

% testing coordinate vector
% coordinates = randn(10000,3);

% figure out the number of coordinates
numCoord = size(coordinates,1);

% loop over each coordinate
distance = NaN(1,numCoord);
distanceMatrix = NaN(numCoord);
textprogressbar('Computing ');
for i = 1 : numCoord
    textprogressbar(i);
    for j = 1 : numCoord
        % Compute coordinate-wise Euclidian distance
        distance(j) = sqrt(sum((coordinates(i,:) - coordinates(j,:)).^2));
    end
    distanceMatrix (i,:) = distance;
end 
textprogressbar('end');

%     % test if the result is correct
%     D = squareform(pdist(coordinates));
%     if sum(sum(distanceMatrix == D )) == numCoord ^ 2
%         %disp('the result matches pdist');
%     else
%         fprintf('You are wrong at %d !', x);
%     end

