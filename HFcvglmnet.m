%% Function for picking lambda by (hit rate - false rate)
% The procedure is similat to cvglmnet 
function [  ] = HFcvglmnet( Xtrain, Ytrain, K, fold_id )

    % Start cross validation 
    for CV = 1:K
        
        % Creating CV indices
        HF_HOLDOUT = ( CV == fold_id);
        
        % Subsetting data
        Ytrain_HF = Ytrain(~HF_HOLDOUT);
        Ytest_HF = Ytrain(HF_HOLDOUT);
        Xtrain_HF = Xtrain(~HF_HOLDOUT);
        Xtest_HF = Xtrain(HF_HOLDOUT);
        
        testSize = size(Ytest_HF,1);
        
        % Use lasso
        opts = glmnetSet();
        opts.alpha = 1;
        
        % Do cvglmnet manually
        fitObj_HF = glmnet(Xtrain_HF, Ytrain_HF, 'binomial', opts)       
        
        prediction = Xtest_HF * fitObj_HF.beta + repmat(fitObj_HF.a0,[testSize,1]) > 0;
        
        
        
        hitrate = sum(prediction & Ytest) / sum(Ytest);
        falserate = sum(~prediction & Ytest) / sum(~Ytest);
        
        difference = hitrate - falserate
        

    end



    % Pick the best lambda 
    % Fit lasso
    % Compute performance
end
