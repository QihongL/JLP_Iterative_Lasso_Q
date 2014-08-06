%% Iterative Lasso -> JLP data set
clear; close all; clc;


%% Run iterative lasso on a single subject


% % Specify the subject number
% subNum = 1;
% 
% % Load the data
% [X,metadata] = loadMRIData('jlp',subNum);
% % Get CV inidices for testing and training set
% CVBLOCKS = metadata(subNum).CVBLOCKS;
% % Get the metadata for the row labels: 
% Y = metadata(subNum).TrueFaces;
% 
% % Run Iterative Lasso
% [ hit, final, lasso, ridge, USED ] = IterLasso(X,Y,CVBLOCKS,2);
% [ hit, final, lasso, ridge, USED, HF ] = HFiterLasso(X,Y,CVBLOCKS,2);




%% Run all subjects with all labels, and save the results 

% % loop over 3 labels
% for i = 1 : 3
% 
%     if i == 1
%         label = 'TrueFaces';
%     else if i == 2
%             label = 'TruePlaces';
%         else if i == 3
%                 label = 'TrueThings';
%             end
%         end
%     end
%     
%      
%     % Loop over 10 subjects
%     for subNum = 1:10
%         disp(['Calculating: ' label ' | Subject: ' num2str(subNum) '...' ])
% 
%         %% prep
%         [X,metadata] = loadMRIData('jlp',subNum);
%         CVBLOCKS = metadata(subNum).CVBLOCKS;
%         Y = metadata(subNum).(label);
% 
% 
%         %% Choose the version of Iterative Lasso
%         [ hit, final, lasso, ridge, USED ] = IterLasso(X,Y,CVBLOCKS,2);
% %         [ hit, final, lasso, ridge, USED, HF ] = HFiterLasso(X,Y,CVBLOCKS,2);
% 
% 
%         %% Get results, and save them
%         result(subNum).finalAccuracy = final.accuracy;
%         result(subNum).hitAll = hit.all;
%         result(subNum).hitCurrent = hit.current;
%         result(subNum).lasso_accuracy = lasso.accuracy;
%         result(subNum).lasso_sig = lasso.sig;
%         result(subNum).ridgeAccuracy = ridge.accuracy;
%         result(subNum).used = USED;
%         result(subNum).lasso_hitRate = hit.hitRate;
%         result(subNum).lasso_falseRate = hit.falseRate;
%         result(subNum).lasso_difference = hit.diffHF;
%         result(subNum).lasso_difference = hit.diffHF;
%         result(subNum).final_hitRate = final.hitrate;
%         result(subNum).final_falseRate = final.falserate;
%         result(subNum).final_difference = final.difference;
%         
%         % specific to cvglmnet
%         result(subNum).lassoBestLambda = lasso.bestLambda;
%         
%         % specific to HFcvglmnet
% %         result(subNum).HFsig = hit.HFsig;    
% %         result(subNum).HF_tunning_lambda = HF;
% 
% 
%     end
%     disp('Save the results!')
%     save(['JLP_ERR_' label '.mat'], 'result');
% end
% disp('Done for all subjects and all labels!')


%% Find XYZs for the solutions
% GENERAL FORMULA: metadata(Sub Num).xyz_tlrc([find(result(Sub Num).used{pool num}(cv num,:) == 1)],:)

subNum = 1;
cvBlock = 1;


% Load the data
[X,metadata] = loadMRIData('jlp',subNum);
% load the results
load('JLP_ERR_TrueFaces.mat')

% Figure out the number of significant iteration 
numSigIter = size(result(subNum).used,2);


% Get the XYZs
cod = metadata(subNum).xyz_tlrc([find(result(subNum).used{numSigIter}(cvBlock,:) == 1)],:)

