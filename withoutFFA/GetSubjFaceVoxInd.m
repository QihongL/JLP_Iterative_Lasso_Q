%% Get voxels that belongs to the face system

clear; clc; 

%% Load data, declare constants

% load the metadata 
METADATA_PATH = '../../data';
load(fullfile(METADATA_PATH,'jlp_metadata.mat'));
% load the coordinates face system
load('FaceCoordinates.mat')
NUM_FACE_VOXELS = size(FaceCoordinates,1);

% get the number of voxels for each subjects
SUB_VOXEL = NaN(10,1); 
for subNum = 1:10
    SUB_VOXEL(subNum) = size(metadata(subNum).xyz_tlrc,1);
end

%% Find intersection with the face system 
faceVoxelInd = cell(1,10);
for subNum = 1:10
    faceVoxelInd{subNum} = FindFaceVoxel(subNum);
end

