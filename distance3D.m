%% Calculate amount of voxels within certain radius

function [proportionAll, proportionMean, subjectOverlapHeatMap, selectedCod]...
    = distance3D(lowerBound, r, label)
% proportionAll: number of overlapping voxel across 10 subjects / total
% voxel in each subhect's solution
% proportionMean 


% We are more interested in HF
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
nvoxel = NaN(1,nSub);
for subNum = 1:nSub
    % load the solution
    solution{subNum} = getSolution(subNum, type, label, lowerBound) > lowerBound;

    % get adjusted coordinates for voxels that were identified 
    selectedCod{subNum} = xyz_adj{subNum}(solution{subNum} == 1, : );
    
    % Get the amount of voxels for each subject
    nvoxel(subNum) = size(selectedCod{subNum},1);
end


% Concatenate the coordinates selected voxels 
for subNum = 1:nSub
    if subNum == 1 
        temp = selectedCod{subNum};
    else
        temp = [temp ; selectedCod{subNum}];
    end
end

D = pdist(temp);
D = squareform(D);

%% Get the logical distance matrix, for voxels within radius 
logicalD = NaN(size(D,1),1);
% loop over all voxels
for i = 1: size(D,1);
    for j = 1: size(D,1)
        logicalD(j, i) = sum(D(j,i) <= r);
    end
end



%% Calculate proportion All

% Get convenient indices 
ind = zeros(sum(nvoxel),1);
a = 1;
for i = 1:10
    n = nvoxel(i);
    b = a + n - 1;
    ind(a:b) = i;
    a = b + 1;
end

% Compute the proportion
temp = zeros(9,9);
for j = 0:9
    for i = 1:10
        temp(j+1,i) = sum(sum(logicalD(ind~=i,ind==i))>j) / nvoxel(i);
    end
end

proportionAll = temp;


%% Calculate single-subject-wise proportion 

% proportionMean indicates the average proportion of overlapping voxel for
% a given subject compare to each other subject 
proportionMean = NaN(1,10);

%subjectOverlapHeatMap is the overlap heat map for calculating
%proportionMean, it retain the overlapping times
subjectOverlapHeatMap = cell(1,9);

% loop over 10 subjects 
for subNum = 1: 10;

    sub = 1:10;
    subTemp = sub(sub ~= subNum);
    
    
    p = NaN(1,10);
    subjectOverlapHeatmapTemp = NaN(nvoxel(subNum),10);
    % If this subject has non-empty solution, compute
    if nvoxel(subNum) ~= 0
        for i = subTemp
            temp = logicalD(ind == subNum, ind == i);
            % overlap with each other subject
            overlap = sum(temp,2);
            % proportion of overlap with each other subject
            p(i) = sum(overlap~=0) / nvoxel(subNum);
            subjectOverlapHeatmapTemp(:,i) = overlap;
        end
    end
    
    % Save the results
    subjectOverlapHeatmapTemp = subjectOverlapHeatmapTemp(:, subTemp);
    subjectOverlapHeatMap{subNum} = subjectOverlapHeatmapTemp;
    p = p(subTemp);
    proportionMean(subNum) = nanmean(p);

end

end

