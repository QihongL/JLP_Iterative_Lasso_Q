function [ responseMatrix ] = response( subNum, cv )
%Compute the response matrix for three classifers, on the test set
% This function outputs n * m matrix
% n = test size
% m = number of classifer 
%
% It needs the subject number of cv number 



% Only HF has solvable subjects anyway... let me hard code it 
type = 'HF';

%% Start computing 

% Get a solvable subject
[X,metadata] = loadMRIData('jlp',subNum);

% Get the test set 
holdout = metadata(subNum).CVBLOCKS(:,cv);
Xtest = X(holdout,:);



%% For every label, get response for the test set 

% For FACES
label = 'TrueFaces';
% Load the result
load(['JLP_' type '_' label '.mat']) 
% Get beta vector and intercept 
[beta_f, intercept_f] = getBeta(subNum, cv, label);
% Calculate the 'response'
response_f = Xtest * beta_f + intercept_f;


% For PLACES
label = 'TruePlaces';
% Load the data
load(['JLP_' type '_' label '.mat']) 
% Get beta vector and intercept 
[beta_p, intercept_p] = getBeta(subNum, cv, label);
% Calculate the 'response'
response_p = Xtest * beta_p + intercept_p;


% For Objects
label = 'TrueThings';
% Load the data
load(['JLP_' type '_' label '.mat']) 
% Get beta vector and intercept 
[beta_t, intercept_t] = getBeta(subNum, cv, label);
% Calculate the 'response'
response_t = Xtest * beta_t + intercept_t;


% Concatenate all responses
responseMatrix = [response_f, response_p, response_t];


end

