% Only exclude the last insig.iteration
clear; clc; 

subNum = 10; 
load('withoutFFA/SubjFaceVoxInd.mat')

% Load the data
[X,metadata] = loadMRIData('jlp',subNum);

% Get CV inidices for testing and training set
CVBLOCKS = metadata(subNum).CVBLOCKS;
% Get the metadata for the row labels: 
Y = metadata(subNum).TrueFaces;

% reduce voxels in the face system
Xsubset = X(:, faceVoxelInd{subNum});

% Run Iterative Lasso
[ hit, final, lasso, ridge, USED, HF ] = HFiterLasso_faceOnly(Xsubset,Y,CVBLOCKS,2);


