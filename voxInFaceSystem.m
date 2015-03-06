%% voxels in Face system analysis
clear; clc;

%% prep data

% CONSTANTS 
NUM_SUBJECTS = 10;
NUM_CVBLOCKS = 10;
NUM_ITER_OMIT = 2;

useNewMasks = true;
if useNewMasks
    filename = 'JLP_HF_TrueFaces_newMasks.mat';  
    voxelIndexFile = 'withoutFFA/faceVoxelIndex_handCons.mat';   
else 
    filename = 'JLP_HF_TrueFaces.mat';              
    voxelIndexFile = 'withoutFFA/SubjFaceVoxInd.mat';       
end

load(filename);  
load(voxelIndexFile);  


% preallocate
voxelUsed = cell(NUM_SUBJECTS,1);
iterSig = cell(NUM_SUBJECTS,1);
targetIter = NaN(10,1);

for subNum = 1 : NUM_SUBJECTS
    % get voxel selection data
    voxelUsed{subNum} = result(subNum).used;
    % the number of iterations occured 
    numIter = size(voxelUsed{subNum},2);
    % the ending iteration for each subject 
    targetIter(subNum) = numIter - NUM_ITER_OMIT; 
end
clear result; % no longer need the data set



%% "voxel-in-face" analysis 

for subNum = 1:10

    % get numbers of cortex voxel and face voxel 
    numFaceVox = sum(faceVoxelInd{subNum});
    numTotalVox = sum(size(voxelUsed{subNum}{1},2));

    % preallocate resources 
    totalVoxSelected = NaN(NUM_CVBLOCKS, targetIter(subNum));
    faceVoxSelected = NaN(NUM_CVBLOCKS, targetIter(subNum));

    for iter = 1: targetIter(subNum);
        
        % get num of total voxel selected in each iters 
        temp = voxelUsed{subNum}{iter};
        totalVoxSelected(:,iter) = sum(temp, 2);
        % get num of face voxel selected in each iters 
        temp = bsxfun(@and, voxelUsed{subNum}{iter}, faceVoxelInd{subNum}');
        faceVoxSelected(:,iter) = sum(temp, 2);
    end

    % store the results
    voxInFaceStats(subNum).numFaceVox = numFaceVox;
    voxInFaceStats(subNum).numTotalVox = numTotalVox;
    voxInFaceStats(subNum).totalVoxSelected = totalVoxSelected;
    voxInFaceStats(subNum).faceVoxSelected = faceVoxSelected;
end



%% Print some stats
fprintf('subID \tnumFaceVox \tnumTotalVox \tfaceVoxSelected \tTotalSelected\n')
for subNum = 1:10
    fprintf('%d \t', subNum )
    
    if isempty(voxInFaceStats(subNum).faceVoxSelected)
        meanFaceVoxSelected = 0;
    else
        meanFaceVoxSelected = mean(voxInFaceStats(subNum).faceVoxSelected(:,end));
    end
    
    if isempty(voxInFaceStats(subNum).totalVoxSelected)
        meanTotalVox = 0;
    else
        meanTotalVox = mean(voxInFaceStats(subNum).totalVoxSelected(:,end));
    end
    
    por = meanFaceVoxSelected / meanTotalVox;
    if isnan(por)
        por = 0;
    end
    
    
    fprintf('%d \t\t %d \t\t %.1f (%.2f%%) \t\t %.1f  \n',...
        voxInFaceStats(subNum).numFaceVox, voxInFaceStats(subNum).numTotalVox, ...
        meanFaceVoxSelected, por * 100, meanTotalVox)

    
end

