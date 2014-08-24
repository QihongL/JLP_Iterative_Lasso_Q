%% The winner take all analysis 
function [accuracy, hit, false] = winTakeAll( subNum, type ) 
% Only exclude the last insig.iteration
% clear; clc; 
warning('off','all');

% Set some parameters
% type = 'ERR';
% 
% subNum = 5;


for cv = 1:10


% load the data
[X,metadata] = loadMRIData('jlp',subNum);

% Get the test set 
holdout = metadata(subNum).CVBLOCKS(:,cv);



% Get response matrix for 3 labels
[responseM, nSolution] = responseMatrix(subNum, cv, type);

if nSolution > 1
    % Get max column 
    [~,maxCol] = max(responseM,[],2);

    % For faces... 
    for i = 1:3
        if i == 1;
            label = 'TrueFaces';
        elseif i == 2;
            label = 'TruePlaces';
        elseif i == 3;
            label = 'TrueThings';
        end

        prediction = maxCol == i; 

        % Get test set 
        Y = metadata(subNum).(label);
        Ytest.(label) = Y(holdout);

        [hit.(label)(cv), false.(label)(cv)] = HFrate(prediction, Ytest.(label));
    end
        truth = Ytest.TrueFaces + Ytest.TruePlaces * 2 + Ytest.TrueThings * 3;
        accuracy(cv) = sum(maxCol == truth) / sum(holdout);


else 
    % Make binomial classifier
    classifier = find(sum(responseM) ~= 0);
    prediction = responseM(:, classifier) > 0 ;
    
    % Get test set 
    if classifier == 1;
        label = 'TrueFaces';
    elseif classifier == 2;
        label = 'TruePlaces';
    elseif classifier == 3;
        label = 'TrueThings';
    end
    Y = metadata(subNum).(label);
    Ytest = Y(holdout);
    
    % Compute the accuracy / hit / false
    [hit.(label)(cv), false.(label)(cv)] = HFrate(prediction, Ytest);
    accuracy(cv) = sum(prediction & Ytest) / sum(holdout);
    

    if nSolution ~= 1;
        error('nSolution < 1  ?')
    end
end
    
end



end