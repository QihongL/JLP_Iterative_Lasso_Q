%% Function for picking lambda by (hit rate - false rate)
% The procedure is similar to cvglmnet. However, for our purpose, this
% version of cvglmnet is going to tune lambda value with respect to the
% difference between hit rate and false alarm rate. In particular, choose
% the lambda that leads to the biggest postive difference between hit rate
% and false alarm rate. 

function [ bestLambda ] = ERRcvglmnet( Xtrain, Ytrain, K, fold_id )

    % Use lasso (alpha = 1)
    opts = glmnetSet();
    opts.alpha = 1;      

    % Choose 100 lambda values for all 9 folds CV
    fit = glmnet(Xtrain,Ytrain);
    opts.lambda = fit.lambda;
    
    % Resource preallocation
    accuracy = zeros(K,100);
    
    % Start cross validation 
    for CV = 1:K
        % Creating CV indices
        ERR_HOLDOUT = (CV == fold_id);        
        % Subsetting data
        Ytrain_ERR = Ytrain(~ERR_HOLDOUT);
        Ytest_ERR = Ytrain(ERR_HOLDOUT);
        Xtrain_ERR = Xtrain(~ERR_HOLDOUT,:);
        Xtest_ERR = Xtrain(ERR_HOLDOUT,:);
        
        % Fit lasso
        fitObj_ERR = glmnet(Xtrain_ERR, Ytrain_ERR, 'binomial', opts);
        % Calculating the prediction
        prediction = bsxfun(@plus, Xtest_ERR * fitObj_ERR.beta, fitObj_ERR.a0) >0;     
        accuracy(CV,:) = mean(bsxfun(@eq, prediction, Ytest_ERR));

    end

    % Calculate mean accuracy for each lambda value
    meanAccuracy = mean(accuracy);
    
    % Get the best lambda value
    indice = find(meanAccuracy == max(meanAccuracy), 1, 'first');
    bestLambda = fitObj_ERR.lambda(indice);

end
