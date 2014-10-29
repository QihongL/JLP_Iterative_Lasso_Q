function [ hit, final, lasso, ridge, USED, HF, fitStore ]...
            = HFiterLasso_faceOnly( X, Y, CVBLOCKS, STOPPING_RULE )
%% Iterative Lasso
% This function preform iterative Lasso
% It needs the following inputs: 
% % % X: The data set
% % % Y: The row labels
% % % CVBLOCKS: The cv indices
% % % STOPPING_RULE: Stop after n non-significant iteration. 


%% Prepare for iterative lasso
% The number of voxels
nvoxels = size(X,2);
% The number of CV blocks
k = size(CVBLOCKS,2);
% Keeping track of the number of iteration
numIter = 0;
% Keeping track of number of significant iteration
numSig = 0;
% Stopping criterion 
% Iterative Lasso stops when t-test insignificant twice
STOPPING_COUNTER = 0;
CHANCE = 2/3 + 1e-4;
% STOPPING_RULE = 2;
% Create a matrix to index voxels that have been used (Chris' method)
used = false(k,nvoxels);

% some new stuff for faceOnly analysis 
voxelRunOut = false;

    
%% Start iterative Lasso 
 
while true
    

    
    
    numIter = numIter + 1;
    textprogressbar(['Iterative Lasso: ' num2str(numIter) ' -> ' ]);
    % Preallocation
    prediction = zeros(size(CVBLOCKS,1)/10, k);
    
    for CV = 1:k    
        textprogressbar(CV * 10);

        % Find the holdout set
        FINAL_HOLDOUT = CVBLOCKS(:,CV);
        % CV Indices for cvglmnet
        CV2 = CVBLOCKS(~FINAL_HOLDOUT,(1:k)~=CV); 
        fold_id = sum(bsxfun(@times,double(CV2),1:9),2);    

        % Subset the data, choose only voxels that haven't been used
        Xiter = X(:,~used(CV,:));
        % Subset Training and testing data 
        Xtrain = Xiter(~FINAL_HOLDOUT,:);
        Xtest = Xiter(FINAL_HOLDOUT,:);
        Ytrain = Y(~FINAL_HOLDOUT);  
        Ytest = Y(FINAL_HOLDOUT);    

        %% Fitting Lasso
        
        % use lasso
        opts = glmnetSet();
        opts.alpha = 1;
        
        % Tuning lambda
        HFfit(CV) = HFcvglmnet( Xtrain, Ytrain, k - 1, fold_id );
        opts.lambda = HFfit(CV).bestLambda;

        % Fit lasso
        fitObj = glmnet(Xtrain, Ytrain, 'binomial', opts);
        
        % Record the fit information 
        fitStore(numIter).lasso(CV) = fitObj;
        
        % Record the classification accuracy
        test.prediction(:,CV) = bsxfun(@plus, Xtest * fitObj.beta, fitObj.a0) > 0 ;
        lasso.accuracy(numIter,CV) = mean(Ytest == test.prediction(:,CV))';
        
        
        %% Alternative Stopping criterion (hit rate - false alarm rate)
        hit.hitRate(numIter, CV) = sum(bsxfun(@and, test.prediction(:,CV),  Ytest)) / sum(Ytest);
        hit.falseRate(numIter, CV) = sum(bsxfun(@and, test.prediction(:,CV), ~Ytest)) / sum(~Ytest);
        

        %% Releveling 
        if sum(fitObj.beta ~= 0) == 0
            % Lasso could select nothing, in this case, there is no
            % accuracy
            ridge.accuracy(numIter,CV) = NaN;
        else
            opts = glmnetSet();
            opts.alpha = 0;
            % Choose lambda
            fitObj_cv_ridge = cvglmnet(Xtrain(:,(fitObj.beta ~= 0)'),Ytrain,'binomial', opts, 'class',9,fold_id');
            opts.lambda = fitObj_cv_ridge.lambda_min;
            % Fitting ridge regression
            fitObj_ridge = glmnet(Xtrain(:,(fitObj.beta ~= 0)'), Ytrain, 'binomial', opts);
            % Record releveling accuracy
            prediction(:,CV) = bsxfun( @plus, Xtest(:,(fitObj.beta ~= 0)') * fitObj_ridge.beta, fitObj_ridge.a0) > 0;
            ridge.accuracy(numIter,CV) = mean(Ytest == prediction(:,CV))';
        end 
        
        
         %% Keeping track of voxels that are being used in the current iteration       
        used( CV, ~used(CV,:) ) = fitObj.beta ~= 0; 
        
    end
    textprogressbar('Done.\n') 
   

    %% Take a snapshot, find out all voxels were used at this time point
    USED{numIter} = used;
    HF{numIter} = HFfit;

    %% Record the results     
    % 1) hit.all : how many voxels have been selected        
    hit.all(numIter, :) = sum(used,2);
    % 2) hit.current: how many voxels have been selected in current
    % iteration
    if numIter == 1
        hit.current(1,:) = hit.all(1,:);
    else
        hit.current(numIter,:) = hit.all(numIter,: ) - hit.all(numIter - 1,:) ;
    end
    % 3) difference between hit rate and false alarm rate
    hit.diffHF(numIter,:) = hit.hitRate(numIter,:) - hit.falseRate(numIter,:); 
    
 

    %% T test
    % T test: classification accuracy > CHANCE 
    [t,p] = ttest(lasso.accuracy(numIter,:), CHANCE, 'Tail', 'right');

    if t == 1 % t could be NaN
%         numSig = numSig + 1;
        lasso.sig(numIter,:) = 1;
        disp(['T-test for lasso accuracy > CHANCE. Result= ' num2str(t) ',  P = ' num2str(p), ' *']);         
    else
        lasso.sig(numIter,:) = 0;
        disp(['T-test for lasso accuracy > CHANCE. Result= ' num2str(t) ',  P = ' num2str(p)]);
    end
    
    % T test: (hit rate - false alarm rate) > 0
    [t2,p2] = ttest(hit.diffHF(numIter,:), 0, 'Tail', 'right');
    
    if t2 == 1 % t could be NaN
        numSig = numSig + 1;
        hit.HFsig(numIter,:) = 1;
        disp(['T-test : (hit rate - false alarm rate) > 0. Result= ' num2str(t) ',  P = ' num2str(p2), ' *']);         
    else
        hit.HFsig(numIter,:) = 0;
        disp(['T-test : (hit rate - false alarm rate) > 0. Result= ' num2str(t) ',  P = ' num2str(p2)]);
    end
    
    %% Print some results
    disp('Difference between hit rate and false alarm rate: ');
    disp(num2str(hit.diffHF(numIter,:)));
    disp(['Average difference between hit are and false alarm rate: ' num2str(mean(hit.diffHF(numIter,:))) ]);
    disp(' ')
    disp('The Lasso accuracy for each CV: ');
    disp(num2str(lasso.accuracy(numIter,:)));
    disp('The releveling accuracy for each CV using ridge: ');
    disp(num2str(ridge.accuracy(numIter,:)));
    disp(' ')
    disp(['The mean classification accuracy using Lasso: ' num2str(mean(lasso.accuracy(numIter,:)))]);
    disp(['The mean releveling accuracy using ridge: ' num2str(nanmean(ridge.accuracy(numIter,:)))]);  
    disp(' ');
    
    disp('Number of voxels that were selected by Lasso (cumulative):');
    disp(num2str(hit.all(numIter,:)));   
    disp('Number of voxels that were selected by Lasso in the current iteration:');    
    disp(num2str(hit.current(numIter,:)));
    disp('--------------------------------------------------------------------')


    %% Stop iterating, if the accuracy is no better than CHANCE N times
    if t2 ~= 1   %  ~t will rise a bug, when t is NaN
        STOPPING_COUNTER = STOPPING_COUNTER + 1;

        if STOPPING_COUNTER == STOPPING_RULE;
        % stop, if t-test = 0 n times, where n = STOPPING_RULE
            disp(' ')
%             disp('* Iterative Lasso was terminated, as the classification accuracy is at CHANCE level.')
            disp('* Iterative Lasso was terminated, as the (hit - false) is about 0.')
            disp('====================================================================')
            disp(' ')
            break
        end

    else
        STOPPING_COUNTER = 0;
    end 

    
    
    % break if run out of voxel
    if sum((sum(USED{numIter},2) == nvoxels)) >= 1
        voxelRunOut = true;
        disp(' ')
        disp('* Run out of voxels!')
        disp('====================================================================')
        disp(' ')
        break
    else
        voxelRunOut = false;
    end
        
        
    
end



    



%% Plot the feature selection process
% figure(1);
% featureSelectionPlot(hit.all, hit.current);


%% Pooling solution and fitting ridge regression

% if run out of voxels
% implies (1) the process is not stopped by unsolvability
%         (2) every voxel is useful

if voxelRunOut
    numExclude = 0;
else
    numExclude = STOPPING_RULE;
end 



% first, check whether pooling solution is possible
if numSig == 0 
    % In order to let the process continute, assign some values if it is
    % going to be terminated
    final.accuracy = NaN(1,10);
    final.hitrate = NaN(1,10);
    final.falserate = NaN(1,10);
    final.difference = NaN(1,10);
    disp('* The number of iterations <= the STOPPING_RULE, which suggests the first several iterations are probably all nonsignificant.')
    disp('* So there is no solution to pool, under current stopping rule. ')
    disp(' ');
else
    fprintf('Number of trials excluded: %d \n', numExclude);
    
    % Pooling solutions
    textprogressbar('Fitting ridge on pooled solution: ' );

    % Resource preallocation
    final.hitrate = zeros(1,10);
    final.falserate = zeros(1,10);
    
    for CV = 1:k
        textprogressbar(CV * 10)
        % Subsetting: find voxels that were selected 

        Xfinal = X( :, USED{numIter - numExclude}(CV,:) );

        % Split the final data set to testing set and training set 
        FINAL_HOLDOUT = CVBLOCKS(:,CV);
        Xtrain = Xfinal(~FINAL_HOLDOUT,:);
        Xtest = Xfinal(FINAL_HOLDOUT,:);
        Ytrain = Y(~FINAL_HOLDOUT);  
        Ytest = Y(FINAL_HOLDOUT);  

        % Fit cvglmnet using ridge (find the best lambda)
        opts = glmnetSet(); 
        opts.alpha = 0;    
        fitObj_cvFinal = cvglmnet (Xtrain,Ytrain,'binomial', opts, 'class',9,fold_id');

        % Use the best lambda value
    %     opts.lambda = fitObj_cvFinal.lambda_min;
        opts.lambda = fitObj_cvFinal.lambda_1se;

        % Fit glmnet 
        fitObj_Final = glmnet(Xtrain, Ytrain, 'binomial', opts);
        
        % Store the fit information 
        fitStore(1).finalLasso(CV) = fitObj_Final;         

        % Calculating accuracies
        final.prediction(:,CV) = bsxfun(@plus, Xtest * fitObj_Final.beta, fitObj_Final.a0) > 0;
        final.accuracy(CV) = mean(Ytest == final.prediction(:,CV))';
        
        % Calculating hit/false rate
        final.hitrate(CV) = sum(final.prediction(:,CV)  & Ytest) / sum(Ytest);
        final.falserate(CV) = sum(final.prediction(:,CV)  & ~Ytest) / sum(~Ytest);
        

    end
    textprogressbar('Done.\n')
    
    % Calculate the difference between hit rate and false alarm rate
    final.difference = final.hitrate - final.falserate;
    
    % Print some results
    disp('Final accuracies: ')
    disp('(row: CV that just performed; colum: CV block from the iterative Lasso)')
    disp(final.accuracy)
    disp('Mean accuracy: ')
    disp(mean(final.accuracy))
    disp(' ');
end

end

