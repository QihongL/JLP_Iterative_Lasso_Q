%% Iterative Lasso -> JLP data set
clear;

%% load the data

[X,metadata] = loadMRIData('jlp',1);

%% Prepration
% Inidices for testing and training set
% CVBLOCKS = metadata(SubNum).CVBLOCKS;
% % Row labels: 
% Y = metadata(SubNum).TrueFaces;

% Inidices for testing and training set
CVBLOCKS = metadata.CVBLOCKS;
% Row labels: 
Y = metadata.TrueFaces;

[ hit, final, lasso, ridge, used, USED ] = IterLasso(X,Y,CVBLOCKS,2)


% %% Run iterative Lasso for all 12 subjects
% for SubNum = 1: 12
% disp('==============================')
% disp(['Subject number: ' num2str(SubNum)])
% disp('==============================')
% 
% [ hit, final, lasso, ridge, used, USED ] = iterLasso(X,Y,CVBLOCKS,SubNum);
% 
% end

