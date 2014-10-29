%% build final models that only omits the last lasso iteration 
% needed for face - noFace - whole brain contrast
clear;

%% Preparation
% CONSTANTS
NUM_OMIT = 1;
NUM_FOLDS = 10;
LABEL = 'TrueFaces';


% Load the results
wholeBrain = load('JLP_HF_TrueFaces.mat');
faceOnly = load('JLP_HF_onlyFace_TrueFaces.mat');
noFace = load('JLP_HF_noFace_TrueFaces.mat');
RESULTS = {wholeBrain.result, faceOnly.result, noFace.result};
RESULTS_NAME = {'wholBrain', 'faceOnly', 'noFace'};
clear wholeBrain; clear faceOnly; clear noFace;


%% Getting voxels for the final model 

i = 2;  % controlling the type (face, noface, wholebrain )


for subNum = 1: 9;

    % load the metadata for one subject 
    [X,metadata] = loadMRIData('jlp',subNum);
    % Get CV inidices for testing and training set
    CVBLOCKS = metadata(subNum).CVBLOCKS;
    % Get the metadata for the row labels: 
    Y = metadata(subNum).(LABEL);


    % check how many iterations did lasso ran
    numIter = size(RESULTS{i}(subNum).used, 2);

    % if lasso had more than 1 iteration, only omit the last iteration
    if numIter > 1
        targetIter = numIter - NUM_OMIT; 
    else % if lasso had only 1 iteration, use it
        targetIter = 1;
    end

    %% Fitting the final model 
    textprogressbar(['Fitting final model: '  ])
    for cv = 1:10
        textprogressbar(cv * 10);

        % get all voxels that were being used 
        voxelUsed = RESULTS{i}(subNum).used{targetIter}(cv,:);

        % check if there is any voxel in the solution
        if sum(voxelUsed) <= 0 
            if sum(voxelUsed) < 0 
                fprintf('Voxel size smaller than 0, there is something wrong! \n');
            else
                fprintf('There is no voxel can be used to fit the final model\n');
            end
        else % there exist some voxels for fitting the final model 

            % subset the X
            Xfinal = X(:,voxelUsed);

            % Get CV set & training set
            FINAL_HOLDOUT = CVBLOCKS(:,cv);
            Xtrain = Xfinal(~FINAL_HOLDOUT,:);
            Xtest = Xfinal(FINAL_HOLDOUT,:);
            Ytrain = Y(~FINAL_HOLDOUT);  
            Ytest = Y(FINAL_HOLDOUT); 

            temp = CVBLOCKS(~FINAL_HOLDOUT,(1:NUM_FOLDS)~=cv); 
            fold_id = sum(bsxfun(@times,double(temp),1:9),2);   

            % Use ridge / tune lambda 
            opts = glmnetSet(); 
            opts.alpha = 1;   
            fitObj_cvFinal = cvglmnet (Xtrain ,Ytrain, 'binomial',opts ,...
                            'class', NUM_FOLDS - 1, fold_id');
            % Pick the best lambda 
            opts.lambda = fitObj_cvFinal.lambda_min;

            % Final fit using ridge
            fitObj_Final = glmnet(Xtrain, Ytrain, 'binomial', opts);
            fitTemp(subNum).CV(cv) = fitObj_Final;

        end
    end
    textprogressbar(['Done!'])

end

fitStore.(RESULTS_NAME{i}) = fitTemp;

% save the results
save(['finalModels_' RESULTS_NAME{i} '.mat'], 'fitStore');
