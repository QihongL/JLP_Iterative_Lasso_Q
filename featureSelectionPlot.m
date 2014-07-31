function [ output_args ] = featureSelectionPlot( hit )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
subplot(1,2,1)
plot(hit.all,'LineWidth',1.5)
xlabel({'Iterations'; ' ' ;...
    '* Each line indicates a different CV blocks' ;...
    '* the last two iterations were insignificant '},...
    'FontSize',13);
ylabel('Number of voxels', 'FontSize',13);
title ({'Feature selection plot (cumulative)' }, 'FontSize',13);
set(gca,'xtick',1:size(hit.all(:,1),1))

% plot the hit.current
subplot(1,2,2)
plot(hit.current,'LineWidth',1.5)
    xlabel({'Iterations'; ' ' ;...
    '* Each line indicates a different CV blocks' ;...
    '* the last two iterations were insignificant '},...
    'FontSize',13);
title ({'Feature selection plot (non - cumulative)' }, 'FontSize',13);
set(gca,'xtick',1:size(hit.current(:,1),1))

end

