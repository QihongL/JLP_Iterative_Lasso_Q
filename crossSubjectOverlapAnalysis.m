%% Write out solution for each subject
% Related to txt2nii.sh, blurFMRI.sh, sumFMRI.sh

clc; clear;

% Set label 
label = 'TrueFaces';
% Set the lower bound for CV consistency 
consistency = 0;
% decided if write the data to text files
writeToTextFile = false;

%% For each subject, Get coordinates and heatmap for voxels satisfy CV lower bound

% Preallocate
filteredSSheatmap = cell(10,1);

% loop over all subjects
%textprogressbar('Get coordinates and heatmap for all subjects: ');
for subNum = 1:10
    %textprogressbar(subNum * 10);

    % Get a single subject heat map 
    heatmap = singleSubHeatmap(subNum, label);

    % Get coordinates and heatmap for voxels that satisfy the CV consistency 
    filteredSSheatmap{subNum} = heatmap( heatmap(:,4) >= consistency, : );
    
    
    % Write to text
    if writeToTextFile
        fileName = sprintf('heatmap_sub%.2d_%.2d_%s.txt', subNum, consistency, label);
        heatmap2txt(fileName, filteredSSheatmap{subNum});
    end
end
%textprogressbar('Done.\n') 



%% Transform the coordinate to index space
% 1. indexAll : indices for all solutions from all subjects
% 2. indexSingleSub: indices for the solution for each subject 

% Concatenate coordinates
AllCoordinates = filteredSSheatmap{1}(:,1:3);
for subNum = 2:10
    AllCoordinates = vertcat(AllCoordinates, filteredSSheatmap{subNum}(:,1:3));
end

% TRANSFORMATION - all
% Round each value to the nearest multiple of 3.
AllCoordinatesTo3 = roundto(AllCoordinates,3);
% Find the min value in each column
columnMin = min(AllCoordinatesTo3);
% Subtract those min values from each column in the matrix
indexCoordinates = bsxfun(@minus, AllCoordinatesTo3, columnMin) / 3;
% Find the max value in each column (the dimensions of this space) 
indexDim = max(indexCoordinates);

% Get 1D index for all voxel
indexAll = collapse_grid(indexDim,indexCoordinates);

% TRANSFORMATION - individual
% Get   1. indices for each individual subject
%       2. 1D index to CV consistency correspondence
indexSingleSub = cell(10,1);
index_coordinates_consistency = cell(10,1);
for subNum = 1:10
    % Apply the same transformation for indivisual subject
    temp = roundto(filteredSSheatmap{subNum}(:,1:3),3);
    tempIndexCod = bsxfun(@minus, temp, columnMin) / 3;
    % Get the individual index 
    indexSingleSub{subNum} = collapse_grid(indexDim,tempIndexCod);
    % Establish individual 1D index to CV consistency correspondence
    index_coordinates_consistency{subNum} = horzcat(indexSingleSub{subNum}, tempIndexCod, filteredSSheatmap{subNum}(:,1:4));
end

%% Constuct the full overlap matrix
% row: all possible voxel
% 1st column: 1D indices
% 2 - 4th columns: coordinates in index spaces
% 5 - 7th columns: coordinates in defineCommonGird spaces
% 8 - 11th columns: coordinates in tlrc spaces
% 8 - 18th columns: CV consistency matrix 
% 19th column: overlap heat map
% 20th existence boolean - if the voxel ever exited in any subject

% initialize the data matrix 
overlapMatrix = nan(max(indexAll),20);



