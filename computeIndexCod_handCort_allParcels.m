% This script is trying to get the metadata for hand constructed masks,
% taking the consideration of all coordinates from all subjects and all
% parcels
clear; 

%% prep
% load the data
% this is the 24 XYZ coordinates for all subjects and all Kanwisher's parcels
% they are arrange in "subjects(10) -> face(6) -> place(6) -> object(2)" order
OLD_METADATA_PATH = '/Users/lcnl/Documents/MATLAB/JLP/data';
HANDCONS_XYZ = '/Users/lcnl/Documents/MATLAB/JLP/JLP_Iterative_Lasso_Q';
load(fullfile(OLD_METADATA_PATH, 'jlp_metadata.mat'));
load(fullfile(HANDCONS_XYZ, 'commonGrid_handCort_allParcels.mat'));

% CONSTANTS
% NUMSUBJ = 10;   % number of subjects for JLP data 
% NUMFACE = 6;    % number of face parcels 
% NUMPLACE = 6;   % number of palce parcels
% NUMOBJ = 2;     % number of object parcels 


%% GET IJK
% concatenate all voxels
temp = XYZ{1};
for i = 2: size(XYZ)
    temp = vertcat(temp, XYZ{i});
end
% round all voxels coordinates to 3 and compute the min for each dimension 
allVoxels = roundto(temp,3);
columnMin = min(temp);

% get IJK by transformation 
IJK = cell(size(XYZ,1),1);
for i = 1:size(XYZ)
    IJK{i} = bsxfun(@minus, XYZ{i}, columnMin) / 3;
end


%% re-structing the data
allMetadata = cell(size(XYZ,1), 1);

for i = 1: size(XYZ,1)
    allMetadata{i} = horzcat(XYZ{i},IJK{i});
end


% subjectMetadata = cell(NUMSUBJ,1);
% faceMetadata = cell(NUMFACE,1);
% placeMetadata = cell(NUMPLACE,1);
% objectMetadata = cell(NUMOBJ,1);

save('XYZIJK_handCons_parcels', 'allMetadata')
disp('done')



