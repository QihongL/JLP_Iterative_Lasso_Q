function [ hit, final, lasso, used, USED ] = IterLasso( X, Y, CVBLOCKS, STOPPING_RULE )
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

        % Use Lasso
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
        
        % Releveling 
        
%         if sum(fitObj.beta ~= 0) ~= 0
%             opts = glmnetSet();
%             opts.alpha = 0;
%             % Choose lambda
%             fitObj_cv_ridge = cvglmnet(Xtrain(:,fitObj.beta~=0),Ytrain,'binomial', opts, 'class',9,fold_id');
%             opts.lambda = fitObj_cv_ridge.lambda_min;
%             % Fitting ridge regression
%             fitObj_ridge = glmnet(Xtrain, Ytrain, 'binomial', opts);
%             % Record releveling accuracy
%             ridge.prediction(:,CV) = (Xtest * fitObj_ridge.beta + repmat(fitObj_ridge.a0, [test.size, 1])) > 0 ;  
%             ridge.accuracy(numIter,CV) = mean(Ytest == ridge.prediction(:,CV))';
%         else
%             releveling == 0;
%         end
        
        

        % Keeping track of which set of voxels were used in each cv block
%         if ttest(lasso.accuracy(numIter,:), chance, 'Tail', 'right') == 1
%             used( CV, ~used(CV,:) ) = fitObj.beta ~= 0;
%         end
                
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
    
 

    %% Printing some results 
    % Test classification accuracy aganist chance 
    [t,p] = ttest(lasso.accuracy(numIter,:), chance, 'Tail', 'right');

    if t == 1 % t could be NaN
        numSig = numSig + 1;
        disp(['Result for the t-test: ' num2str(t) ',  P = ' num2str(p), ' *']); 
        lasso.sig(numIter,:) = 1;
    else
        disp(['Result for the t-test: ' num2str(t) ',  P = ' num2str(p)]);
        lasso.sig(numIter,:) = 0;
    end
    disp(' ');
    disp('The accuracy for each CV: ');
    disp(num2str(lasso.accuracy(numIter,:)));
    disp(['The mean classification accuracy: ' num2str(mean(lasso.accuracy(numIter,:)))]);
   
%     disp(['Releveling accuracy using ridge: ' num2str(mean(ridge.accuracy(numIter,:)))]);  
    disp(' ');
    disp('Number of voxels that were selected by Lasso (cumulative):');
    disp(hit.all(numIter,:));   
    disp('Number of voxels that were selected by Lasso in the current iteration:');    
    disp(hit.current(numIter,:));


    %% Stop iteration, when the decoding accuracy is not better than chance
    if t ~= 1   %  ~t will rise a bug, when t is NaN
        STOPPING_COUNTER = STOPPING_COUNTER + 1;

        if STOPPING_COUNTER == STOPPING_RULE;
        % stop, if t-test = 0 n times, where n = STOPPING_RULE
            disp(' ')
            disp('* Iterative Lasso was terminated, as the classification accuracy is at chance level.')
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
    'FontSize',12);
ylabel('Number of voxels', 'FontSize',12);
title ({'Feature selection plot (cumulative)' }, 'FontSize',12);
set(gca,'xtick',1:size(hit.all(:,1),1))

% plot the hit.current
subplot(1,2,2)
plot(hit.current)
    xlabel({'Iterations'; ' ' ;...
    '* Each line indicates a different CV blocks' ;...
    '* the last two iterations were insignificant '},...
    'FontSize',12);
title ({'Feature selection plot (non - cumulative)' }, 'FontSize',12);
set(gca,'xtick',1:size(hit.current(:,1),1))






%% Pooling solution and fitting ridge regression
textprogressbar('Fitting ridge on pooled solution: ' );
for CV = 1:k
    textprogressbar(CV * 10)
    % Subset: find voxels that were selected 
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


disp('Final accuracies: ')
disp('(row: CV that just performed; colum: CV block from the iterative Lasso)')
disp(final.accuracy)
disp('Mean accuracy: ')
disp(mean(final.accuracy))

end

