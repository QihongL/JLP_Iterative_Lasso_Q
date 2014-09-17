%% Get solution for a single subject
% The solution includes
% 1. the coordinates
% 2. the heat map -> cross validation consistency 

function [heatmap] = singleSubHeatmap(subNum, label)


%% prep 

% load the data
load('jlp_metadata.mat')

% set the parameters 
%subNum = 1;
%label = 'TrueFaces';
type = 'HF'; % only looking at HF solution 
lowerBound = 0; % we want all voxels


%% Compute heat map

% Get adjusted xyz coordinates and min distance 
[xyz_adj] = defineCommonGrid({metadata.xyz_tlrc});

% Get consistency for each voxel 
solution = getSolution(subNum,type,label,lowerBound);

% Get the xyz_adj for each subject
xyz_temp = xyz_adj{subNum};

% Combine the coordinates with the XYZ_adjs
heatmap = [xyz_temp, solution];

end