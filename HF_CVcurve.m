%% Generate cross validation curves for HFcvglmnet
% Results for iterative lasso using HFcvglmnet has to be loaded first!
clear; close all;

%% Load the data
label = 'TrueFaces';
load(['JLP_HF_' label '.mat'])

%% Plot the CV curve for subject i, iteration j

% % specify the parameters
% subNum = 1;
% numIter = 1;
% % Get data 
% hitRate = result(subNum).HF_tunning_lambda{numIter}.hitrate;
% falseRate = result(subNum).HF_tunning_lambda{numIter}.falserate;
% difference = result(subNum).HF_tunning_lambda{numIter}.difference;
% 
% figure(1)
% HFcvglmnetPlot( hitRate, falseRate, difference)



%% Plot the CV curve for iteration j for all subjects

% specify the paratemer
numIter = 1;

% loop over all subjects
for subNum = 1:10 
    if subNum == 1 
        % for the 1st subject, create variables
        hitRate = result(subNum).HF_tunning_lambda{numIter}.hitrate;
        falseRate = result(subNum).HF_tunning_lambda{numIter}.falserate;
        difference = result(subNum).HF_tunning_lambda{numIter}.difference;
    else
        % for the rest of subjects, concatnate the results with the
        % previous results
        tempH = result(subNum).HF_tunning_lambda{numIter}.hitrate;
        tempF = result(subNum).HF_tunning_lambda{numIter}.falserate;
        tempD = result(subNum).HF_tunning_lambda{numIter}.difference;
        hitRate = [ hitRate; tempH ];
        falseRate= [falseRate; tempF];
        difference = [difference; tempD];
    end
end

figure(2)
HFcvglmnetPlot( hitRate, falseRate, difference)



