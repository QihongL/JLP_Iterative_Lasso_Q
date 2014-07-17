%% Iterative Lasso -> JLP data set
clear;

%% load the data
load('jlp_metadata.mat');
load(('jlp04.mat'),'X');

%% Set the subject Number
SubNum = 4;

%% Prepration
% Inidices for testing and training set
CVBLOCKS = metadata(SubNum).CVBLOCKS;
% Row labels: 
Y = metadata(SubNum).TrueFaces;


%% Run iterative Lasso
[ hit, final, lasso, ridge, used, USED ] = iterLasso(X,Y,CVBLOCKS,SubNum);



