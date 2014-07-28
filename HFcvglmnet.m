%% Function for picking lambda by (hit rate - false rate)
% The procedure is similar to cvglmnet. However, for our purpose, this
% version of cvglmnet is going to tune lambda value with respect to the
% difference between hit rate and false alarm rate. In particular, choose
% the lambda that leads to the biggest postive difference between hit rate
% and false alarm rate. 

function [ bestLambda ] = HFcvglmnet( Xtrain, Ytrain, K, fold_id )

    % Perallocation 
    bestLambda = zeros(K,1);

    % Start cross validation 
    for CV = 1:K

        % Creating CV indices
        HF_HOLDOUT = (CV == fold_id);        
        % Subsetting data
        Ytrain_HF = Ytrain(~HF_HOLDOUT);
        Ytest_HF = Ytrain(HF_HOLDOUT);
        Xtrain_HF = Xtrain(~HF_HOLDOUT,:);
        Xtest_HF = Xtrain(HF_HOLDOUT,:);
        
        % Use lasso
        opts = glmnetSet();
        opts.alpha = 1;      
        fitObj_HF = glmnet(Xtrain_HF, Ytrain_HF, 'binomial', opts);
               
        % Calculating the prediction
        prediction = bsxfun(@plus, Xtest_HF * fitObj_HF.beta, fitObj_HF.a0) >0;        
        % Calculating hit rate, false rate, and their difference 
        hitrate = sum(bsxfun(@and, prediction, Ytest_HF)) / sum(Ytest_HF);
        falserate = sum(bsxfun(@and, ~prediction, Ytest_HF)) / sum(~Ytest_HF);                
        difference = hitrate - falserate;
        
        % Find the lambda corresponds to the biggest difference
        indices = find(difference == max(difference));
        bestLambda(CV,1) = fitObj_HF.lambda(find(difference == max(difference), 1, 'last'));

    end

end
