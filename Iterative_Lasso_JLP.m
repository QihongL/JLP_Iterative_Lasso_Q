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
[ hit, final, lasso, ridge, USED ] = IterLasso(X,Y,CVBLOCKS,2);



% %% Run all subjects & record the results 
% % Thid block of code can automatically run ten subject for one type of label (e.g. Face)
% for i = 1:10
%     % prep
%     SubNum = i;
%     [X,metadata] = loadMRIData('jlp',SubNum);
%     CVBLOCKS = metadata(SubNum).CVBLOCKS;
%     Y = metadata(SubNum).TrueFaces;
%     % Iterative Lasso
%     [ hit, final, lasso, ridge ] = IterLasso(X,Y,CVBLOCKS,2);
% 
%     % Get results
%     result(SubNum).finalAccuracy = final.accuracy;
%     result(SubNum).hitAll = hit.all;
%     result(SubNum).hitCurrent = hit.current;
%     result(SubNum).lassoAccuracy = lasso.accuracy;
%     result(SubNum).lassoSig = lasso.sig;
%     result(SubNum).ridgeAccuracy = ridge.accuracy;
%     result(SubNum).used = USED;
% end
