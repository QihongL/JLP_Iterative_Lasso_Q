%% Function for picking lambda by (hit rate - false rate)
% The procedure is similar to cvglmnet. However, for our purpose, this
% version of cvglmnet is going to tune lambda value with respect to the
% difference between hit rate and false alarm rate. In particular, choose
% the lambda that leads to the biggest postive difference between hit rate
% and false alarm rate. 

function [ HF ] = HFcvglmnet( Xtrain, Ytrain, K, fold_id )

    % Resource perallocation 
	%HF.hitrate = zeros(K,100);
    %HF.falserate = zeros(K,100);
    
    % Use lasso (alpha = 1)
    opts = glmnetSet();
    opts.alpha = 1;      

    % Choose 100 lambda values for all 9 folds CV
    fit = glmnet(Xtrain,Ytrain);
    opts.lambda = fit.lambda;
    

    % Start cross validation 
    for CV = 1:K

        % Creating CV indices
        HF_HOLDOUT = (CV == fold_id);        
        % Subsetting data
        Ytrain_HF = Ytrain(~HF_HOLDOUT);
        Ytest_HF = Ytrain(HF_HOLDOUT);
        Xtrain_HF = Xtrain(~HF_HOLDOUT,:);
        Xtest_HF = Xtrain(HF_HOLDOUT,:);
        
        % Fit lasso
        fitObj_HF = glmnet(Xtrain_HF, Ytrain_HF, 'binomial', opts);
        % Calculating the prediction
        prediction = bsxfun(@plus, Xtest_HF * fitObj_HF.beta, fitObj_HF.a0) >0;        
        % Calculating hit rate, false rate, and their difference 
        HF.hitrate(CV,:) = sum(bsxfun(@and, prediction, Ytest_HF)) / sum(Ytest_HF);
        HF.falserate(CV,:) = sum(bsxfun(@and, prediction, ~Ytest_HF)) / sum(~Ytest_HF);                

    end

    %% Calculate the difference
    HF.difference = HF.hitrate - HF.falserate;
    
    %% Plot the hit rate, false rate and difference
    figure(99);
    HFcvglmnetPlot(HF.hitrate,HF.falserate,HF.difference);
    
    %% Find the lambda corresponds to the biggest difference
    % Note: when there are more than one lambda have the biggest
    % difference, choose the least sparse solution. 
    indice = find(mean(HF.difference,1) == max(mean(HF.difference,1)) ,1 ,'first');
    HF.bestLambda = fitObj_HF.lambda(indice);
   
end
