%% Voxel Overlap analysis 
clear; clc; 

% pick a label
label = 'TrueThings';


lowerBound = [1 3 5 7];
radius = [3 6 9 12];

%% Proportion to all voxels
% loop over all r
for i = 1 : length(radius)
% loop over all lower boundries (# of times selected across 10 cv blocks)
    for j = 1 : length(lowerBound)
        pAll{j,i} = distance3D(lowerBound(j), radius(i), label);
    end
end


% %% plot 
% close all;
% i = 2;
% j = 2;
% 
% % p{lb, r}
% plot(pAll{j,i})
% xlabel ('Number of times selected across 10 subjects', 'FontSize', 14)
% ylabel ('Proportion of overlapping voxels', 'FontSize', 14)
% title(['For voxels that selected >= ' num2str(lowerBound(j)) ' times, label = ' label ', radius = ' num2str(radius(i)) ' mm' ]...
%     , 'FontSize', 14)



%% single sub 
proportionMean = cell(1,4);
for j = 1 : length(radius)
    r = radius(j);
    pm = NaN(10,10);
    for i = 1:10
        [~, pm(:,i)] = distance3D(i,r,label);
    end
    proportionMean{j} = pm; 
end


% %% plot for single r
% figure(2)
% r = 1;
% 
% 
% plot(proportionMean{r})
% xlabel ('Lower Bound (times selected across 10 CV blocks)', 'FontSize', 14)
% ylabel ('Proportion of overlapping voxels (average across 9 comparisons)', 'FontSize', 14)
% title(['label = ' label ', radius = ' num2str(radius(r)) ' mm' ]...
%     , 'FontSize', 14)


%% plot all r

figure(3)

hold on 
lw = 2;
plot(nanmean(proportionMean{1},2), 'k', 'LineWidth',lw)
plot(nanmean(proportionMean{2},2), 'r', 'LineWidth',lw)
plot(nanmean(proportionMean{3},2), 'g', 'LineWidth',lw)
plot(nanmean(proportionMean{4},2), 'b', 'LineWidth',lw)
hold off

legend('radius = 3mm','radius = 6mm', 'radius = 9mm', 'radius = 12mm')
xlabel ('Lower Bound (times selected across 10 CV blocks)', 'FontSize', 15)
ylabel ('Proportion of overlapping voxels (average across 9 comparisons)', 'FontSize', 15)
title(['label = ' label ], 'FontSize', 15)


