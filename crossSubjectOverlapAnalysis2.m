%% This overlap analysis trying to incoorperate radius
% Related files: txt2nii.sh, blurFMRI.sh, sumFMRI.sh
clear;clc;


%% Set parameters

% Set label 
label = 'TrueFaces';
% Set a radius
radius = 3;
% Decided if want to write the heatmap to .txt file
writeToTextFile = false;


%% Prepare data, constants, variables

% Get number of voxel for each subject
DATA_PATH = '../data';
load(fullfile(DATA_PATH,'jlp_metadata.mat'));
SUB_VOXEL = NaN(10,1);
for subNum = 1:10
    SUB_VOXEL(subNum) = size(metadata(subNum).xyz_tlrc,1);
end
% Get number of total voxels 
TOTAL_VOXEL = sum(SUB_VOXEL);

% construct the data matrix
X = zeros(TOTAL_VOXEL,5);
% Construct solution matrix for the same size 
SOLUTION = zeros(size(X,1),1);



%% For each subject, Get coordinates and heatmap for all voxels

% Preallocate
disp('Getting coordinates and heatmap for each subject...')
rawHeatmap = cell(10,1);
for subNum = 1:10
    % Get a single subject heat map 
    rawHeatmap{subNum} = singleSubHeatmap(subNum, label);
end


%%  Concatenate coordinates
disp('Combine coordinates...')
rawCoordinates_heatmap = rawHeatmap{1};
for subNum = 2:10
    rawCoordinates_heatmap = vertcat(rawCoordinates_heatmap, rawHeatmap{subNum});
end


%% TRANSFORMATION - all
% 1. SDIndex : indices for all solutions from all subjects

disp('Transform to index space...')

% Round each value to the nearest multiple of 3.
rawCoordinates_heatmap_To3 = roundto(rawCoordinates_heatmap(:,1:3),3);
% Find the min value in each column
columnMin = min(rawCoordinates_heatmap_To3);
% Subtract those min values from each column in the matrix
indexCoordinates = bsxfun(@minus, rawCoordinates_heatmap_To3, columnMin) / 3;
indexCoordinates_heatmap = horzcat(indexCoordinates, rawCoordinates_heatmap(:,4));
% Find the dimension in Index Space
indexDim = max(indexCoordinates);

% Get 1D index for all voxel
SDIndex = collapse_grid(indexDim,indexCoordinates);
All_SDindex_indexCoordinates_heatmap = horzcat(SDIndex, indexCoordinates_heatmap);

%% TRANSFORMATION - individual
% 1. indexSingleSub: indices for the solution for each subject 

indexSingleSub = cell(10,1);
SS_SDindex_indexCoordinates_consistency = cell(10,1);
SS_indexCoordinates_consistency = cell(10,1);
for subNum = 1:10
    % Apply the same transformation for indivisual subject
    temp = roundto(rawHeatmap{subNum}(:,1:3),3);
    tempIndexCod = bsxfun(@minus, temp, columnMin) / 3;
    % Get the individual index 
    indexSingleSub{subNum} = collapse_grid(indexDim,tempIndexCod);
    
    % Establish individual 1D index to CV consistency correspondence
    % Column 1 = 1D index
    % Column 2-4 = coordinates in index space
    % column 5 = CV consistency
    SS_SDindex_indexCoordinates_consistency{subNum} = horzcat(indexSingleSub{subNum}, tempIndexCod, rawHeatmap{subNum}(:,4));
    
end


%% concatenation index
a = 1;
for subNum = 1:10
    % Concatenate
    x = SS_SDindex_indexCoordinates_consistency{subNum}(:,2:5);
    b = a + SUB_VOXEL(subNum) - 1;
    X(a:b,:) = [repmat(subNum,SUB_VOXEL(subNum),1),x];
    a = a + SUB_VOXEL(subNum);
end


%% Eliminate unselected voxels
X_nonzero = X(X(:,5) ~= 0, 1:5 );
SOLUTION_nonzero = zeros(size(X_nonzero,1),1);

% Compute distance matrix 
disp('Compute the distance matrix...');
D = pdistNoCrash(X_nonzero(:,2:4));

%% Overlap analysis 
disp('Finding overlap...');

% loop over 10 threshold for cv consistency
for CVConsistency = 0:9

    % find indices for voxels above certian CV consistency
    voxel_above_threshold = X(:,5) > CVConsistency;
    X_CVConsistency = X(voxel_above_threshold,1:5);
    
    % Get voxels blocks for each subject 
    % voxelBlock = bsxfun(@eq, X(:,1), X(:,1)');
    voxelBlock_nonzero = bsxfun(@eq, X_nonzero(:,1), X_nonzero(:,1)');
    D(voxelBlock_nonzero) = Inf;

    % set the upper triangle to infinity
    D(tril(true(size(D))) == 0) = Inf;
    
    % Overlap voxel = voxel within certian radius...    
    overlapVoxel = any(tril(D) < radius);
    
    % write to solution
    SOLUTION(voxel_above_threshold) = overlapVoxel * CVConsistency;
end