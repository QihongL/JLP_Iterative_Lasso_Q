%% Cross subjects overlap analysis
% Check voxel overlap across subjects, finding functional anatomical
% consistency

function [heatVec, catCod_u] = overlapMap(lowerBound, label)

%% Set some parameters

% Pick the lower bound (times selected across 10 cv blocks)
% lowerBound = 2;
% label = 'TrueFaces';

type = 'HF';
% load the tlrc coordinates
load('jlp_metadata.mat')
% Get the number of subject
nSub = size({metadata.xyz_tlrc},2);


%% Find voxels that were selected, and their coordinates  

% Get adjusted xyz coordinates and min distance 
[xyz_adj] = defineCommonGrid({metadata.xyz_tlrc});


solution = cell(1,nSub);
selectedCod = cell(1,nSub);
for subNum = 1:nSub
    % load the solution
    solution{subNum} = getSolution(subNum, type, label, lowerBound) > lowerBound;

    % get adjusted coordinates for voxels that were identified 
    selectedCod{subNum} = xyz_adj{subNum}(solution{subNum} == 1, : );
end


% Concatenate the coordinates selected voxels 
for subNum = 1:nSub
    if subNum == 1 
        temp = selectedCod{subNum};
    else
        temp = [temp ; selectedCod{subNum}];
    end
end
catCod = temp;
% Eliminate redundant coordinates
catCod_u = unique(catCod, 'rows');


%% Find overlapping voxels

heatVec = zeros(size(catCod_u,1), 1);
for i = 1 : size(catCod,1)
    [~, idx] = ismember(catCod(i,:), catCod_u, 'rows');
    heatVec(idx) = heatVec(idx) + 1;
end


% %% check some numbers 
% size(catCod,1)
% size(catCod_u,1)
% sum(heatVec)
% size(heatVec,1)
% max(heatVec)
end
