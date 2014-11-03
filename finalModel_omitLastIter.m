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
RESULTS_NAME = {'wholeBrain', 'faceOnly', 'noFace'};
clear wholeBrain; clear faceOnly; clear noFace;


%% Getting voxels for the final model 

i = 3;  % controlling the type (face, noface, wholebrain )


% number of subjects might not be 10, since 1 subject was completely 
% excluded from faceOnly condition (no face voxel) 
numberOfSubjects = size(RESULTS{i},2);

for subNum = 1: numberOfSubjects;

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
        % if all lasso iterations were significant, use all iterations
        if numIter == sum(RESULTS{i}(subNum).HFsig)
            targetIter = numIter;
        else
            targetIter = numIter - NUM_OMIT;
        end
    else % if lasso had only 1 iteration, use it
        targetIter = 1;
    end

    %% Fitting the final model 
    textprogressbar(['Fitting final model: '  ])
    for cv = 1:NUM_FOLDS
        textprogressbar(cv * NUM_FOLDS);

        % get Indices for all voxels that were being used 
        voxelUsedInd = RESULTS{i}(subNum).used{targetIter}(cv,:);

        % if no voxel in the solution
        if sum(voxelUsedInd) <= 0 
            % if no voxel, put some placeholders for the performance
            performance.accuracy(subNum, cv) = NaN;
            performance.hitRate(subNum, cv) = NaN;
            performance.falseRate(subNum, cv) = NaN;
            
            % return some info
            if sum(voxelUsedInd) < 0 
                fprintf('Voxel size smaller than 0, there is something wrong! \n');
            else
                fprintf('There is no voxel in this CV block. \n');
            end
            
        else % there exist some voxels for fitting the final model 

            % subset the X
            Xfinal = X(:,voxelUsedInd);

            % Get CV set & training set
            FINAL_HOLDOUT = CVBLOCKS(:,cv);
            Xtrain = Xfinal(~FINAL_HOLDOUT,:);
            Xtest = Xfinal(FINAL_HOLDOUT,:);
            Ytrain = Y(~FINAL_HOLDOUT);  
            Ytest = Y(FINAL_HOLDOUT); 

            temp = CVBLOCKS(~FINAL_HOLDOUT, (1:NUM_FOLDS) ~= cv); 
            fold_id = sum(bsxfun(@times,double(temp),1:9),2);   

            % tune lambda 
            opts = glmnetSet(); 
            opts.alpha = 1;   
            fitObj_cvFinal = cvglmnet (Xtrain ,Ytrain, 'binomial',opts ,...
                            'class', NUM_FOLDS - 1, fold_id');
            % Pick the best lambda 
            opts.lambda = fitObj_cvFinal.lambda_min;

            % Final fit using ridge
            fitObj_Final = glmnet(Xtrain, Ytrain, 'binomial', opts);
            fitTemp(subNum).CV(cv) = fitObj_Final;
            
            % compute predictions
            prediction = bsxfun(@plus, Xtest * fitObj_Final.beta, fitObj_Final.a0) > 0;
            
            % Compute accuracy / hit rate / false alarm rate 
            finalModels.accuracy(subNum, cv) = mean(Ytest == prediction);
            finalModels.hitRate(subNum, cv) = sum(prediction & Ytest) / sum(Ytest);
            finalModels.falseRate(subNum, cv) = sum(~prediction & Ytest) / sum(~Ytest);

        end
    end
    textprogressbar(['Done!'])

end

finalModels.(RESULTS_NAME{i}) = fitTemp;

% save the results
save(['finalModels_' RESULTS_NAME{i} '.mat'], 'finalModels');
