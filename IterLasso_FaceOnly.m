% Only exclude the last insig.iteration
clear; clc; 

subNum = 1; 
% load('withoutFFA/SubjFaceVoxInd.mat')
load('withoutFFA/faceVoxInd_handCons.mat')

% Load the data
[X,metadata] = loadMRIData('jlp',subNum);

% Get CV inidices for testing and training set
CVBLOCKS = metadata(subNum).CVBLOCKS;
% Get the metadata for the row labels: 
Y = metadata(subNum).TrueFaces;

% reduce voxels in the face system
Xsubset = X(:, faceVoxelInd_handCons{subNum});

% Run Iterative Lasso
% [ hit, final, lasso, ridge, USED, HF ] = HFiterLasso(X,Y,CVBLOCKS,2, faceVoxelInd{subNum});
[ hit, final, lasso, ridge, USED, HF ] = HFiterLasso(X,Y,CVBLOCKS,2, faceVoxelIndex_handCons{subNum});


