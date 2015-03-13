%% Find Voxel Size
% This script is trying to figure out what is the appropriate resolution for 
% for a voxel, which is needed for doing some basic analysis with the new hand 
% constructed masks  The resolution is obtained based on the XYZs for all subjects
% and all Kanwisher's parcels (face, place, object). 
% 
% related function: test_coordinates()
%
% modified Mar. 6
clear; clc

% get the data path
CORTEX_DATA_PATH = '/Users/lcnl/Documents/MATLAB/JLP/HandConstructedCortex/handmade_mask_xyztlrc';
FFA_DATA_PATH = '/Users/lcnl/Documents/MATLAB/JLP/ParcelAnalysis/face_parcels/afni_tlrc/funcres/coordinateDumps';
OBJ_DATA_PATH = '/Users/lcnl/Documents/MATLAB/JLP/ParcelAnalysis/object_parcels/afni_tlrc/funcres/coordinateDumps';
SCENE_DATA_PATH = '/Users/lcnl/Documents/MATLAB/JLP/ParcelAnalysis/scene_parcels/afni_tlrc/funcres/coordinateDumps';

% get the file names for all voxel files 
cortexFiles = dir(CORTEX_DATA_PATH);
cortexFiles = cortexFiles(~[cortexFiles.isdir]);

ffaFiles = dir(FFA_DATA_PATH);
ffaFiles = ffaFiles(~[ffaFiles.isdir]);

objFiles = dir(OBJ_DATA_PATH);
objFiles = objFiles(~[objFiles.isdir]);

sceneFiles = dir(SCENE_DATA_PATH);
sceneFiles = sceneFiles(~[sceneFiles.isdir]);

% concatenate all file names 
allFiles = [cortexFiles;ffaFiles;sceneFiles;objFiles];

% load all XYZs of interests 
XYZ = cell(length(allFiles),1);
for i = 1:length(allFiles);
    if i <= length(cortexFiles)
        path=fullfile(CORTEX_DATA_PATH,allFiles(i).name);
    elseif i <= length([cortexFiles;ffaFiles])
        path=fullfile(FFA_DATA_PATH,allFiles(i).name);
    elseif i <= length([cortexFiles;ffaFiles;sceneFiles])
        path=fullfile(SCENE_DATA_PATH,allFiles(i).name);
    else
        path=fullfile(OBJ_DATA_PATH,allFiles(i).name);
    end
    xyz = load(path);
    XYZ{i} = xyz(:,1:3);
end

% figure out a good resolution
test_coordinates(XYZ,3,3,3.5)

save('commonGrid_handCort_allParcels', 'XYZ')

%% Conclusion: we decided to choose [X, Y, Z] = [3, 3, 3.5] 
