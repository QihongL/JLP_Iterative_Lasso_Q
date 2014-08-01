function [ output_args ] = featureSelectionPlot( hitAll, hitCurrent )
%This function plots the feature selection process

%% Get a reasonable range for y axis
numIter = size(hitAll,1);
ymax = max(hitAll(numIter,:)) + 50;
ymin = 0;

%% hitAll
subplot(1,2,1)
plot(hitAll,'LineWidth',1.5)
xlabel({'Iterations'; ' ' ;...
    '* Each line indicates a different CV blocks' ;...
    '* the last two iterations were insignificant '},...
    'FontSize',13);
ylabel('Number of voxels', 'FontSize',13);
ylim([ymin ymax]);
title ({'Feature selection plot (cumulative)' }, 'FontSize',13);
set(gca,'xtick',1:size(hitAll(:,1),1));

%% hitCurrent
subplot(1,2,2)
plot(hitCurrent,'LineWidth',1.5)
    xlabel({'Iterations'; ' ' ;...
    '* Each line indicates a different CV blocks' ;...
    '* the last two iterations were insignificant '},...
    'FontSize',13);
title ({'Feature selection plot (non - cumulative)' }, 'FontSize',13);
ylim([ymin ymax]);
set(gca,'xtick',1:size(hitCurrent(:,1),1));

end

