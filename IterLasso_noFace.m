%% Decode face without voxels in the face system
%% Iterative Lasso -> JLP data set
clear; close all; clc;


%% Run iterative lasso on a single subject

load('withoutFFA/SubjFaceVoxInd.mat')

% Specify the subject number
for subNum = 1:10;
fprintf('Subject: %d|\n', subNum);
fprintf('-----------\n');
    
% Load the data
[X,metadata] = loadMRIData('jlp',subNum);

% Get CV inidices for testing and training set
CVBLOCKS = metadata(subNum).CVBLOCKS;
% Get the metadata for the row labels: 
Y = metadata(subNum).TrueFaces;

% reduce voxels in the face system
Xsubset = X(:, faceVoxelInd{subNum});


if size(Xsubset,2) ~= 0
    % Run Iterative Lasso
    % [ hit, final, lasso, ridge, USED, fitStore ] = IterLasso(Xsubset,Y,CVBLOCKS,2);
    % [ hit, final, lasso, ridge, USED, HF, fitStore ] = HFiterLasso(Xsubset,Y,CVBLOCKS,2);

    [ hit, final, lasso, ridge, USED, HF, fitStore ] = HFiterLasso_faceOnly(Xsubset,Y,CVBLOCKS,2);


    %% Get results, and save them
    result(subNum).finalAccuracy = final.accuracy;
    result(subNum).hitAll = hit.all;
    result(subNum).hitCurrent = hit.current;
    result(subNum).lasso_accuracy = lasso.accuracy;
    result(subNum).lasso_sig = lasso.sig;
    result(subNum).ridgeAccuracy = ridge.accuracy;
    result(subNum).used = USED;
    result(subNum).lasso_hitRate = hit.hitRate;
    result(subNum).lasso_falseRate = hit.falseRate;
    result(subNum).lasso_difference = hit.diffHF;
    result(subNum).lasso_difference = hit.diffHF;
    result(subNum).final_hitRate = final.hitrate;
    result(subNum).final_falseRate = final.falserate;
    result(subNum).final_difference = final.difference;
    % result(subNum).fitStore = fitStore;

    % % specific to cvglmnet
    % result(subNum).lassoBestLambda = lasso.bestLambda;

    % specific to HFcvglmnet
    result(subNum).HFsig = hit.HFsig;    
    result(subNum).HF_tunning_lambda = HF;
end

end

disp('Save the results!')
save(['JLP_HF_onlyFace_TrueFaces.mat'], 'result');  
disp('Done for all subjects and all labels!')


