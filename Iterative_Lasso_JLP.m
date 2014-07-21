%% Iterative Lasso -> JLP data set
clear;

%% load the data
SubNum = 9;
[X,metadata] = loadMRIData('jlp',SubNum);

%% Prepration
% Get CV inidices for testing and training set
CVBLOCKS = metadata(SubNum).CVBLOCKS;
%% Choose Row labels: 
Y = metadata(SubNum).TrueFaces;


%% Run Iterative Lasso
[ hit, final, lasso, ridge ] = IterLasso(X,Y,CVBLOCKS,2);



%% Run all subjects and record the results 
% for i = 1:10
% 
% SubNum = i;
% [X,metadata] = loadMRIData('jlp',SubNum);
% CVBLOCKS = metadata(SubNum).CVBLOCKS;
% Y = metadata(SubNum).TrueFaces;
% 
% [ hit, final, lasso, ridge ] = IterLasso(X,Y,CVBLOCKS,2);
% 
% 
% result(SubNum).finalAccuracy = final.accuracy;
% result(SubNum).hitAll = hit.all;
% result(SubNum).hitCurrent = hit.current;
% result(SubNum).lassoAccuracy = lasso.accuracy;
% result(SubNum).lassoSig = lasso.sig;
% result(SubNum).ridgeAccuracy = ridge.accuracy;
% end
