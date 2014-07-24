function [ hit, final, lasso, ridge, USED ] = IterLasso( X, Y, CVBLOCKS, STOPPING_RULE )
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
% The size for the testing set 
test.size = size(X,1)/k;
% Keeping track of the number of iteration
numIter = 0;
% Keeping track of number of significant iteration
numSig = 0;
% Stopping criterion 
% Iterative Lasso stops when t-test insignificant twice
STOPPING_COUNTER = 0;
chance = 2/3 + 1e-4;
% STOPPING_RULE = 2;
% Create a matrix to index voxels that have been used (Chris' method)
used = false(k,nvoxels);

    
    
%% Start iterative Lasso 
    
while true
    numIter = numIter + 1;
    textprogressbar(['Iterative Lasso: ' num2str(numIter) ' -> ' ]);
    for CV = 1:k    
        textprogressbar(CV * 10);

        % Find the holdout set
        FINAL_HOLDOUT = CVBLOCKS(:,CV);
        % CV Indices for cvglmnet
        CV2 = CVBLOCKS(~FINAL_HOLDOUT,(1:k)~=CV); 
        fold_id = sum(bsxfun(@times,double(CV2),1:9),2);    

        % Subset the data, choose only used voxels
        Xiter = X(:,~used(CV,:));
        % Subset Training and testing data 
        Xtrain = Xiter(~FINAL_HOLDOUT,:);
        Xtest = Xiter(FINAL_HOLDOUT,:);
        Ytrain = Y(~FINAL_HOLDOUT);  
        Ytest = Y(FINAL_HOLDOUT);    

        %% Fitting Lasso
        opts = glmnetSet();
        opts.alpha = 1;
        % Fit lasso with cv
        fitObj_cv = cvglmnet(Xtrain,Ytrain,'binomial', opts, 'class',9,fold_id');
        % Pick the best lambda
        opts.lambda = fitObj_cv.lambda_min;
        % Fit lasso
        fitObj = glmnet(Xtrain, Ytrain, 'binomial', opts);
        % Record the classification accuracy
        test.prediction(:,CV) = (Xtest * fitObj.beta + repmat(fitObj.a0, [test.size, 1])) > 0 ;
        lasso.accuracy(numIter,CV) = mean(Ytest == test.prediction(:,CV))';
        
        
        %% Alternative Stopping criterion (hit rate - false alarm rate)
        hit.rate(numIter, CV) = sum(test.prediction(:,CV)  & Ytest) / sum(Ytest);
        hit.falserate(numIter, CV) = sum(~test.prediction(:,CV)  & Ytest) / sum(~Ytest);
        

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
        ridge.prediction(:,CV) = (Xtest(:,(fitObj.beta ~= 0)') * fitObj_ridge.beta + repmat(fitObj_ridge.a0, [test.size, 1])) > 0 ;  
        ridge.accuracy(numIter,CV) = mean(Ytest == ridge.prediction(:,CV))';
        end 
        
        
         % Keeping track of voxels that are being used in the current iteration       
        used( CV, ~used(CV,:) ) = fitObj.beta ~= 0; 
        
               

    end
    textprogressbar('Done.\n') 
   

    % Take a snapshot, find out all voxels were used at this time point
    USED{numIter} = used;

    % Record the results, including           
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
    hit.diffHF(numIter,:) = hit.rate(numIter,:) - hit.falserate(numIter,:); 
    
 

    %% Printing some results 
    % Test classification accuracy aganist chance 
    [t,p] = ttest(lasso.accuracy(numIter,:), chance, 'Tail', 'right');

    if t == 1 % t could be NaN
        numSig = numSig + 1;
        lasso.sig(numIter,:) = 1;
        disp(['T-test for lasso accuracy against chance. Result= ' num2str(t) ',  P = ' num2str(p), ' *']);         
    else
        lasso.sig(numIter,:) = 0;
        disp(['T-test for lasso accuracy against chance. Result= ' num2str(t) ',  P = ' num2str(p)]);
    end
    

    [t2,p2] = ttest(hit.diffHF(numIter,:), 0, 'Tail', 'right');
    
    if t2 == 1 % t could be NaN
        disp(['T-test for (hit rate - false alarm rate) against 0. Result= ' num2str(t) ',  P = ' num2str(p), ' *']);         
    else
        disp(['T-test for (hit rate - false alarm rate) against 0. Result= ' num2str(t) ',  P = ' num2str(p)]);
    end
    
    
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


    %% Stop iterating, if the accuracy is no better than chance N times
    if t ~= 1   %  ~t will rise a bug, when t is NaN
        STOPPING_COUNTER = STOPPING_COUNTER + 1;

        if STOPPING_COUNTER == STOPPING_RULE;
        % stop, if t-test = 0 n times, where n = STOPPING_RULE
            disp(' ')
            disp('* Iterative Lasso was terminated, as the classification accuracy is at chance level.')
            disp('====================================================================')
            disp(' ')
            break
        end

    else
        STOPPING_COUNTER = 0;
    end 

end





%% Plot the feature selection plots
% Plot the hit.all 
figure(1)
subplot(1,2,1)
plot(hit.all,'LineWidth',1.5)
xlabel({'Iterations'; ' ' ;...
    '* Each line indicates a different CV blocks' ;...
    '* the last two iterations were insignificant '},...
    'FontSize',13);
ylabel('Number of voxels', 'FontSize',13);
title ({'Feature selection plot (cumulative)' }, 'FontSize',13);
set(gca,'xtick',1:size(hit.all(:,1),1))

% plot the hit.current
subplot(1,2,2)
plot(hit.current,'LineWidth',1.5)
    xlabel({'Iterations'; ' ' ;...
    '* Each line indicates a different CV blocks' ;...
    '* the last two iterations were insignificant '},...
    'FontSize',13);
title ({'Feature selection plot (non - cumulative)' }, 'FontSize',13);
set(gca,'xtick',1:size(hit.current(:,1),1))


%% Pooling solution and fitting ridge regression

% first, check whether pooling solution is possible
if numIter - STOPPING_RULE <= 0 
    final.accuracy = NaN(1,10);
    disp('* The number of iterations <= the STOPPING_RULE, which suggests the first several iterations are probably all nonsignificant.')
    disp('* So there is no solution to pool, under current stopping rule. ')
    disp(' ');
else
    % Pooling solutions
    textprogressbar('Fitting ridge on pooled solution: ' );
    for CV = 1:k
        textprogressbar(CV * 10)
        % Subsetting: find voxels that were selected 
        Xfinal = X( :, USED{numIter - STOPPING_RULE}(CV,:) );

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

        % Calculating accuracies
        final.prediction(:,CV) = (Xtest * fitObj_Final.beta + repmat(fitObj_Final.a0, [test.size, 1])) > 0 ;  
        final.accuracy(CV) = mean(Ytest == final.prediction(:,CV))';

    end
    textprogressbar('Done.\n')
    
    % Print some results
    disp('Final accuracies: ')
    disp('(row: CV that just performed; colum: CV block from the iterative Lasso)')
    disp(final.accuracy)
    disp('Mean accuracy: ')
    disp(mean(final.accuracy))
    disp(' ');
end

end

