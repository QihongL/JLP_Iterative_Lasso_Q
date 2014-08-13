%% Feature consistency analysis
% Analyze the consistency for the voxels
clear; clc; 


%% Group analysis (for all subjects)

% Setting Parameters
type = 'ERR';
STOPPING_RULE = 1;
solvableSub = true;




figure(1)
for ii = 1:3
    if ii == 1
        label = 'TrueFaces';
    else if ii == 2
            label = 'TruePlaces';
        else if ii == 3
                label = 'TrueThings';
            end
        end
    end
    
    % load the data
    load(['JLP_' type '_' label '.mat'])


    yy = NaN(10,10);
    for subNum = 1:10

        % Check input
        if solvableSub == false
            % Find the last significant iteration, according to the stopping rule 
            iterNum = size(result(subNum).used,2) - STOPPING_RULE;
            if iterNum <= 0 
                disp(['WARNING: Subject ' num2str(subNum) ' unsolvable, pick the 1st iteration instead'])
                iterNum = 1;
            end

            for i = 1:10
                yy(subNum, i) = sum(sum(result(subNum).used{iterNum}) == i);
            end


        elseif solvableSub == true
            % Loop over solvable subjects only 
            if size(result(subNum).used,2) > 2
                iterNum = size(result(subNum).used,2) - STOPPING_RULE;
            for i = 1:10
                yy(subNum, i) = sum(sum(result(subNum).used{iterNum}) == i);
            end

            end


        end


    end
    

    

% Get data for cumulative plot
yyy{ii} = yy;    
    
end


%% PLotting the results


    
for j = 1:3
    if j == 1
        label = 'TrueFaces';
    else if j == 2
            label = 'TruePlaces';
        else if j == 3
                label = 'TrueThings';
            end
        end
    end
    
    
    
     xx = 1:10;   
    
    % non cumulative plot 
    subplot(2,3,j)
    % plot porprotion
    plot(xx, bsxfun(@rdivide, yyy{j} , sum(yyy{j},2))', ':')
    hold on
    plot(xx, nanmean(bsxfun(@rdivide, yyy{j} , sum(yyy{j},2))), 'LineWidth',2)
    hold off
    title([ label ], 'FontSize', 14)
    if j == 1
        ylabel(' Non-Cumulative Proportion', 'FontSize', 14)
    end
    ylim([0, 1])
    set(gca,'XTickLabel',1:10)


    
    
    % cumulative plot
    subplot(2,3,j + 3)
    
    yyflip = fliplr(cumsum(fliplr(yyy{j}),2));
    plot(xx, bsxfun(@rdivide, yyflip , yyflip(:,1))', ':')
    hold on
    plot(xx, nanmean(bsxfun(@rdivide, yyflip , yyflip(:,1))), 'LineWidth',2)
    hold off
    ylim([0, 1])
    xlabel('Times', 'FontSize', 14)
    if j == 1
        ylabel('Cumulative Proportion', 'FontSize', 14)
    end

    
    


end


ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 
1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

text(0.5, 1,'\bf HFiterLasso - Feature Consistency Plots','HorizontalAlignment' , ...
    'center','VerticalAlignment', 'top', 'FontSize', 15)







