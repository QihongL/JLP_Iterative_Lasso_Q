%% Get final models - only exclude the last in-sig. iter.
% - Prepration Winner take all analysis 
% Only exclude the last insignificant iteration, in order to make sure
% every subject has at least something to be analyzed. 

clear; 

k = 10;
STOPPING_RULE = 1;


%% Set the type
type = 'ERR';


for i = 1:3

    if i == 1
        label = 'TrueFaces';
        disp('Compute Faces......')
    elseif i == 2
        label = 'TruePlaces';
        disp('Compute Places......')
    elseif i ==3;
        label = 'TrueThings';
        disp('Compute Things......')
    end

    %% Load the result
    load(['JLP_' type '_' label '.mat']);

    for subNum = 1:10
        disp(['Subject : ' num2str(subNum)])
        %% Load the data
        [X,metadata] = loadMRIData('jlp',subNum);

        % Get CV inidices for testing and training set
        CVBLOCKS = metadata(subNum).CVBLOCKS;
        % Get the metadata for the row labels: 
        Y = metadata(subNum).(label);


        %% prep 1

        % Only exclude the last iteration
        iterNum = size(result(subNum).used,2) - STOPPING_RULE;

    %     %  resource preallocation
    %     accuracy = zeros(1,10);
    %     hitRate = zeros(1,10);
    %     falseRate = zeros(1,10);

        textprogressbar(['Fitting final model: '  ])
        for cv = 1:10
            textprogressbar(cv * 10);
            %% prep 2

            % Get indices for all voxels that were being used
            voxel_used = result(subNum).used{iterNum}(cv,:);


            % Fit the final model only when solution exists
            if sum(voxel_used) >= 1

                % Get data for final model
                Xfinal = X(:,voxel_used);

                %% Get CV set & training set
                FINAL_HOLDOUT = CVBLOCKS(:,cv);
                Xtrain = Xfinal(~FINAL_HOLDOUT,:);
                Xtest = Xfinal(FINAL_HOLDOUT,:);
                Ytrain = Y(~FINAL_HOLDOUT);  
                Ytest = Y(FINAL_HOLDOUT); 

                temp = CVBLOCKS(~FINAL_HOLDOUT,(1:k)~=cv); 
                fold_id = sum(bsxfun(@times,double(temp),1:9),2);   

                %% Ridge

                % Use ridge / tune lambda 
                opts = glmnetSet(); 
                opts.alpha = 1;   
                fitObj_cvFinal = cvglmnet (Xtrain ,Ytrain, 'binomial',opts , 'class', k - 1, fold_id');
                % Pick the best lambda 
                opts.lambda = fitObj_cvFinal.lambda_min;

                % Final fit using ridge
                fitObj_Final = glmnet(Xtrain, Ytrain, 'binomial', opts);
                fitTemp(subNum).cv(cv) = fitObj_Final;



        %         %% Predict
        %         
        %         % Compute prediction 
        %         prediction = bsxfun(@plus, Xtest*fitObj_Final.beta, fitObj_Final.a0) > 0;
        % 
        %         % Compute accuracy / hit rate / false alarm rate 
        %         accuracy(cv) = mean(Ytest == prediction);
        %         hitRate(cv) = sum(prediction & Ytest) / sum(Ytest);
        %         falseRate(cv) = sum(prediction & ~Ytest) / sum(Ytest);
            end


        end
        textprogressbar(['Done!'])

    end

    % Store the final model 
        fitStore.(label) = fitTemp;

    
    
end


save(['fitStore_' type '.mat'], 'fitStore');