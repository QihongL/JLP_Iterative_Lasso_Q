%% Iterative Lasso -> JLP data set
clear;

%% load the data
SubNum = 10;
[X,metadata] = loadMRIData('jlp',SubNum);

%% Prepration
% Get CV inidices for testing and training set
CVBLOCKS = metadata(SubNum).CVBLOCKS;
%% Choose Row labels: 
Y = metadata(SubNum).TrueFaces;


%% Run Iterative Lasso
[ hit, final, lasso, ridge ] = IterLasso(X,Y,CVBLOCKS,2);



% %% Run iterative Lasso for all 10 subjects
% for SubNum = 1: 10
% disp('==============================')
% disp(['Subject number: ' num2str(SubNum)])
% disp('==============================')
% 
% [ hit, final, lasso, ridge, used, USED ] = iterLasso(X,Y,CVBLOCKS,SubNum);
% 
% end

