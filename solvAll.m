%% Find subjects that are solvable for all labels 
function [solveAll] = solvAll( type ) 
% WHAT IT DOES: This function ouputs a logical vector, which indicates
% whether a subject is solvable for all labels.

% WHY: This will be the base for the combined classifer, since if a subject
% is not solvable for one label, it is not possible to combine the 3
% classifiers.

% INSTRUCTION: It takes the input variable 'type'
% There are two choices: 'HF' or 'ERR'


for i = 1 : 3

    if i == 1
        label = 'TrueFaces';
        solvable(i).subID = false(1,10);
    else if i == 2
            label = 'TruePlaces';
            solvable(i).subID = false(1,10);
        else if i == 3
                label = 'TrueThings';
                solvable(i).subID = false(1,10);
            end
        end
    end

    
    load(['JLP_' type '_' label '.mat'])

    for subNum = 1:10
        if size(result(subNum).used,2) > 2
            solvable(i).subID(subNum) = true;
        else
%             disp(['Subject ' num2str(subNum) ' is unsolvable.'])
        end

    end
%     disp(['Solvability vector for ' label ': '])
%     disp(solvable(i).subID);

end


%% Find subjects that are solvable for all labels
solvbilityMatrix = [ solvable(1).subID ; solvable(2).subID ; solvable(3).subID ];
solveAll = sum(solvbilityMatrix) == 3;


end