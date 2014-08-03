%% Iterative Lasso -> JLP data set
clear; close all; clc;

% %% Specify the subject number
% SubNum = 1;
% 
% %% Load the data
% [X,metadata] = loadMRIData('jlp',SubNum);
% % Get CV inidices for testing and training set
% CVBLOCKS = metadata(SubNum).CVBLOCKS;
% % Get the metadata for the row labels: 
% Y = metadata(SubNum).TrueFaces;
% 
% %% Run Iterative Lasso
% 
% [ hit, final, lasso, ridge, USED ] = IterLasso(X,Y,CVBLOCKS,2);
% [ hit, final, lasso, ridge, USED, HF ] = HFiterLasso(X,Y,CVBLOCKS,2);


%% Run all subjects with all labels, and save the results 


for i = 1 : 3
    % loop over 3 labels
    if i == 1
        label = 'TrueFaces';
    else if i == 2
            label = 'TruePlaces';
        else if i == 3
                label = 'TrueThings';
            end
        end
    end
    
     
    % Loop over 10 subjects
    for SubNum = 1:10
        disp(['Calculating: ' label ' | Subject: ' num2str(SubNum) '...' ])

        %% prep
        [X,metadata] = loadMRIData('jlp',SubNum);
        CVBLOCKS = metadata(SubNum).CVBLOCKS;
    %     Y = metadata(SubNum).TrueFaces;
        Y = metadata(SubNum).(label);


        %% Choose the version of Iterative Lasso
%         [ hit, final, lasso, ridge, USED ] = IterLasso(X,Y,CVBLOCKS,2);
        [ hit, final, lasso, ridge, USED, HF ] = HFiterLasso(X,Y,CVBLOCKS,2);


        %% Get results, and save them
        result(SubNum).finalAccuracy = final.accuracy;
        result(SubNum).hitAll = hit.all;
        result(SubNum).hitCurrent = hit.current;
        result(SubNum).lasso_accuracy = lasso.accuracy;
        result(SubNum).lasso_sig = lasso.sig;
        result(SubNum).ridgeAccuracy = ridge.accuracy;
        result(SubNum).used = USED;
        result(SubNum).lasso_hitRate = hit.hitRate;
        result(SubNum).lasso_falseRate = hit.falseRate;
        result(SubNum).lasso_difference = hit.diffHF;
        result(SubNum).lasso_difference = hit.diffHF;
        result(SubNum).final_hitRate = final.hitrate;
        result(SubNum).final_falseRate = final.falserate;
        result(SubNum).final_difference = final.difference;
        result(SubNum).HFsig = hit.HFsig;    
        result(SubNum).HF_tunning_lambda = HF;


    end
    save(['JLP_HF_' label '.mat'], 'result');
end



%% Find XYZs for the solutions
% GENERAL FORMULA: metadata(Sub Num).xyz_tlrc([find(result(Sub Num).used{pool num}(cv num,:) == 1)],:)

% metadata(7).xyz_tlrc([find(result(7).used{4}(1,:) == 1)],:)