%% Iterative Lasso -> JLP data set
clear;
% 
% %% load the data
% SubNum = 2;
% [X,metadata] = loadMRIData('jlp',SubNum);
% 
% %% Prepration
% % Get CV inidices for testing and training set
% CVBLOCKS = metadata(SubNum).CVBLOCKS;
% %% Choose Row labels: 
% Y = metadata(SubNum).TrueFaces;
% 
% 
% % Run Iterative Lasso
% [ hit, final, lasso, ridge, USED, HF ] = HFiterLasso(X,Y,CVBLOCKS,2);


%% Run all subjects & record the results 
% Thid block of code can automatically run ten subject for one type of label (e.g. Face)

for SubNum = 1:10
    disp(['Calculating for Subject ' num2str(SubNum) '...' ])
    % prep
    [X,metadata] = loadMRIData('jlp',SubNum);
    CVBLOCKS = metadata(SubNum).CVBLOCKS;
    Y = metadata(SubNum).TrueThings;
    % Iterative Lasso
    [ hit, final, lasso, ridge, USED, HF ] = HFiterLasso(X,Y,CVBLOCKS,2);
    
    % Get results
    result(SubNum).finalAccuracy = final.accuracy;
    result(SubNum).hitAll = hit.all;
    result(SubNum).hitCurrent = hit.current;
    result(SubNum).lasso_accuracy = lasso.accuracy;
    result(SubNum).lasso_sig = lasso.sig;
    result(SubNum).HFsig = hit.HFsig;
    result(SubNum).ridgeAccuracy = ridge.accuracy;
    result(SubNum).used = USED;
    result(SubNum).HF_tunning_lambda = HF;
    result(SubNum).lasso_hitRate = hit.hitRate;
    result(SubNum).lasso_falseRate = hit.falseRate;
    result(SubNum).lasso_difference = hit.diffHF;
    result(SubNum).lasso_difference = hit.diffHF;
    result(SubNum).final_hitRate = final.hitrate;
    result(SubNum).final_falseRate = final.falserate;
    result(SubNum).final_difference = final.difference;
    
end



%% Find XYZs for the solutions

% metadata(Sub Num).xyz_tlrc([find(result(Sub Num).used{pool num}(cv num,:) == 1)],:)
% metadata(7).xyz_tlrc([find(result(7).used{4}(1,:) == 1)],:)