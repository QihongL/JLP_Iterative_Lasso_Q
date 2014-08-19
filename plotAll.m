%% Generate all the plots

% Loop over 2 types of iterative lasso methods
for j = 1:2
    if j == 1
        type = 'ERR';
    elseif j == 2
        type = 'HF';
    end

    %loop over 3 labels
    for i = 1 : 3
        if i == 1
            label = 'TrueFaces';
        elseif i == 2
            label = 'TruePlaces';
        elseif i == 3
            label = 'TrueThings';
        end

        % loop over 10 subjects
        for subNum = 1:10        
            plotSolutions(subNum, type, label)
        end
    end
end
