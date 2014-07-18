function [ accuracy ] = GLMNET( data, label, choice )
% This function can run cvglmnet and glmnet
% It needs:
% 1) data
% 2) label
% 3) choice between lasso or ridge 

    % Initialize options for glmnet    
    opts = glmnetSet();

    % Choose Lasso or ridge
    switch choice
        case 'lasso'
        opts.alpha = 1;
        case 'ridge'
        opts.alpha = 0;       
    end
    
    

    % Fit lasso with cv
    fitObj_cv = cvglmnet(data,label,'binomial', opts, 'class',9,fold_id');
    % Pick the best lambda
    opts.lambda = fitObj_cv.lambda_min;
    % Fit lasso
    fitObj = glmnet(data, label, 'binomial', opts);
    % Record the classification accuracy
    prediction(:,CV) = (Xtest * fitObj.beta + repmat(fitObj.a0, [test.size, 1])) > 0 ;
    accuracy(numIter,CV) = mean(Ytest == prediction(:,CV))';
        
end

