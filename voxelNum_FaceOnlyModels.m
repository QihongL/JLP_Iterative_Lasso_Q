clear;

faceOnly = load('JLP_HF_onlyFace_TrueFaces.mat');


voxelUsedEveryCV = NaN(9,10);
totalVoxels = NaN(9,1);

for subNum = 1 : 9
    totalVoxels(subNum) = size(faceOnly.result(subNum).used{1},2);
    totalIters = size(faceOnly.result(subNum).used,2);
    voxelUsedEveryCV(subNum,:) = sum(faceOnly.result(subNum).used{totalIters},2)';
    
end

temp = bsxfun(@eq, totalVoxels, voxelUsedEveryCV)

sum(temp,2)