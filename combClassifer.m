%% Winer take all classifer
% Combining three classifers.
clear; clc;


%% First, Find subjects that are solvable for all labels 
type = 'HF';

solvableSub = find(solvAll(type) == 1);
numSub = size(solvableSub,2);



%% Start computing 

% Get a solvable subject
subNum = solvableSub(1);
cv = 1;
[X,metadata] = loadMRIData('jlp',subNum);




% For FACES
label = 'TrueFaces';
% Load the result
load(['JLP_' type '_' label '.mat']) 

% Get beta vector and intercept 
[beta_f, intercept_f] = getBeta(subNum, cv, label);
% Calculate the 'response'
response_f = X * beta_f + intercept_f;


% For PLACES
label = 'TruePlaces';
% Load the data
load(['JLP_' type '_' label '.mat']) 

% Get beta vector and intercept 
[beta_p, intercept_p] = getBeta(subNum, cv, label);
% Calculate the 'response'
response_p = X * beta_p + intercept_p;


% For Objects
label = 'TrueThings';
% Load the data
load(['JLP_' type '_' label '.mat']) 

% Get beta vector and intercept 
[beta_t, intercept_t] = getBeta(subNum, cv, label);
% Calculate the 'response'
response_t = X * beta_t + intercept_t;



% Concatenate all responses
responseMatrix = [response_f, response_p, response_t];


% Calculate hit and false alarm 
[~,maxCol] = max(responseMatrix,[],2);
prediction = maxCol == 1;
Y = metadata(subNum).TrueFaces;
hit = sum(prediction & Y) / sum(Y);
false = sum(prediction & ~Y) / sum(~Y);




