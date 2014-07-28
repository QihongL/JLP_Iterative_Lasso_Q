%% Function for picking lambda by (hit rate - false rate)
% The procedure is similat to cvglmnet 
function [ bestLambda ] = HFcvglmnet( Xtrain, Ytrain, K, fold_id )

    % Start cross validation 
    for CV = 1:K
        
        % Creating CV indices
        HF_HOLDOUT = (CV == fold_id);
        
        % Subsetting data
        Ytrain_HF = Ytrain(~HF_HOLDOUT);
        Ytest_HF = Ytrain(HF_HOLDOUT);
        Xtrain_HF = Xtrain(~HF_HOLDOUT);
        Xtest_HF = Xtrain(HF_HOLDOUT);
        
        testSize = size(Ytest_HF,1);
        
        % Use lasso
        opts = glmnetSet();
        opts.alpha = 1;
        
        % Now, do cvglmnet manually
        
        fitObj_HF = glmnet(Xtrain_HF, Ytrain_HF, 'binomial', opts)
        % ***PROBLEM*** lacking lambda?
        
        
        % Calculating the prediction
%         prediction = Xtest_HF * fitObj_HF.beta + repmat(fitObj_HF.a0,[testSize,1]) > 0;
        prediction = bsxfun(@plus, Xtest_HF * fitObj_HF.beta, fitObj_HF.a0) >0;
        
        % Calculating hit rate, false rate, and their difference 
        hitrate = sum(bsxfun(@and, prediction, Ytest)) / sum(Ytest);
        falserate = sum(bsxfun(@and, ~prediction, Ytest)) / sum(~Ytest);                
%         hitrate = sum(prediction & Ytest) / sum(Ytest);
%         falserate = sum(~prediction & Ytest) / sum(~Ytest);
        difference = hitrate - falserate;
        
        % Find the lambda corresponds to the biggest difference
        bestLambda = fitObj_HF.lambda(difference == find(max(difference)));

    end



    % Pick the best lambda 
    % Fit lasso
    % Compute performance
end
