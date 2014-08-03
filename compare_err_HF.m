%% Analysis: compare two version of iterative lasso
clear;clc;close all;
% Pick a label
label = 'TrueFaces';
disp('------------------------------------------------')
disp(['Label = ' label]);



%% Compare number of solvable subject (total)
% Error
load(['JLP_ERR_' label '.mat']);
ERR.solvable = false(1,10);
for SubNum = 1:10
    i = SubNum;
    % final accuracy is NaN => not solvable
    if ~isnan(result(i).finalAccuracy(1))
        % Get the indices for non-solvable subject
        ERR.solvable(i) = true;
    end
    % Calculate the number of non-solvable subject
    ERR.solvable_num = sum(ERR.solvable);
end


% Hit/False
load(['JLP_HF_' label '.mat'])
HF.solvable = false(1,10);
for SubNum = 1:10
    i = SubNum;
    % final accuracy is NaN => not solvable
    if ~isnan(result(i).finalAccuracy(1))
        % Get the indices for non-solvable subject
        HF.solvable(i) = true;
    end
    % Calculate the number of non-solvable subject
    HF.solvable_num = sum(HF.solvable);
end

% Display number of solvable subjects
disp('------------------------------------------------')
disp('Solvable subjects: ' );
disp(['Error:     ' num2str(ERR.solvable) '  =  ' num2str(ERR.solvable_num)])
disp(['Hit/False: ' num2str(HF.solvable) '  =  ' num2str(HF.solvable_num)])



%% Compare number of voxels selected (total)

% Error
load(['JLP_ERR_' label '.mat']);
% Resource preallocation
ERR.voxels_all = zeros(10,10);
% Get data (This version does not exclude unsolvable subjects)
for SubNum = 1:10
    i = SubNum;
    ERR.voxels_all(i,:) = result(i).hitAll(end,:);
end

% For hit/false
load(['JLP_HF_' label '.mat'])
% Resource preallocation
HF.voxels_all = zeros(10,10);
% Get data (This version does not exclude unsolvable subjects)
for SubNum = 1:10
    i = SubNum;
    HF.voxels_all(i,:) = result(i).hitAll(end,:);
end

% t test
[t_all, p_all] = ttest(HF.voxels_all(:),ERR.voxels_all(:));
 
% exclude non-solvable subjects
ERR.voxels_solvableSub = ERR.voxels_all(ERR.solvable,:);
HF.voxels_solvableSub = HF.voxels_all(HF.solvable,:);
[t_solvable, p_solvable] = ttest( mean(HF.voxels_solvableSub),mean(ERR.voxels_solvableSub) );

% Display the total number of voxels were being selected (average accross subject)
disp(' ')
disp('------------------------------------------------')
disp('Total number of voxels were being selected (including unsolvable subjects): ' );
fprintf('\t\t Error\t\t Hit/False \t T-test \t P-value \n' );
fprintf('All_Sub %15.2f %16.2f %12d %17.4f \n', mean(ERR.voxels_all(:)), mean(HF.voxels_all(:)), t_all, p_all );
fprintf('Solvable %14.2f %16.2f %12d %17.4f \n', mean(ERR.voxels_solvableSub(:)), mean(HF.voxels_solvableSub(:)), t_solvable, p_solvable );



%% Compare number of iterations 

% Error
load(['JLP_ERR_' label '.mat']);
ERR.numIterAll = zeros(1,10);
for SubNum = 1:10
    i = SubNum;
    ERR.numIterAll(i) = size(result(i).lasso_sig,1);
end

% For hit/false
load(['JLP_HF_' label '.mat']);
HF.numIterAll = zeros(1,10);
for SubNum = 1:10
    i = SubNum;
    HF.numIterAll(i) = size(result(i).HFsig,1);
end





% Display reuslts
disp(' ')
disp('------------------------------------------------')
disp('Number of iterations(all subjects): ' );
fprintf('Error\t\t')
fprintf('%4d  ', ERR.numIterAll)
fprintf(' = %.2f', mean(ERR.numIterAll))
fprintf('\n')
fprintf('Hit/False\t')
fprintf('%4d  ', HF.numIterAll)
fprintf(' = %.2f', mean(HF.numIterAll))
fprintf('\n')
disp(' ')

% Change unsolvable subjects to NaN
ERR.numIter_solvableSub = ERR.numIterAll .* ERR.solvable;
HF.numIter_solvableSub = HF.numIterAll .* HF.solvable;
ERR.numIter_solvableSub(ERR.numIter_solvableSub == 0) = NaN;
HF.numIter_solvableSub(HF.numIter_solvableSub == 0) = NaN;

disp('Number of iterations(excluding unsovlable subjects): ' );
fprintf('Error\t\t')
fprintf('%4d  ', ERR.numIter_solvableSub)
fprintf(' = %.2f', mean(ERR.numIterAll(ERR.solvable)))
fprintf('\n')
fprintf('Hit/False \t')
fprintf('%4d  ', HF.numIter_solvableSub)
fprintf(' = %.2f', mean(HF.numIterAll(HF.solvable)))
fprintf('\n')
disp(' ')



%% Compare accuracy
% Error
load(['JLP_ERR_' label '.mat']);
ERR.accuracy = zeros(1,10);
for SubNum = 1:10
    i = SubNum;
    ERR.accuracy(i) = mean(result(i).finalAccuracy);
end

% For hit/false
load(['JLP_HF_' label '.mat']);
HF.accuracy = zeros(1,10);
for SubNum = 1:10
    i = SubNum;
    HF.accuracy(i) = mean(result(i).finalAccuracy);
end


disp('------------------------------------------------')
disp('Final classification accuracy: ')
fprintf('Error:\t  ')
fprintf('%10.4f', ERR.accuracy);
fprintf('  = % 6.4f \n', nanmean(ERR.accuracy));
fprintf('Hit/False:')
fprintf('%10.4f', HF.accuracy);
fprintf('  = % 6.4f \n', nanmean(HF.accuracy));
disp(' ')


%% Compare hit/false rate
% Error
load(['JLP_ERR_' label '.mat']);
HF.hitRate= zeros(1,10);
HF.falseRate = zeros(1,10);
HF.difference = zeros(1,10);
for SubNum = 1:10
    i = SubNum;
    HF.hitRate(i) = mean(result(i).final_hitRate);
    HF.falseRate(i) = mean(result(i).final_falseRate);
    HF.difference(i) = mean(result(i).final_difference);
end

% For hit/false
load(['JLP_HF_' label '.mat']);
ERR.hitRate= zeros(1,10);
ERR.falseRate = zeros(1,10);
ERR.difference = zeros(1,10);
for SubNum = 1:10
    i = SubNum;
    ERR.hitRate(i) = mean(result(i).final_hitRate);
    ERR.falseRate(i) = mean(result(i).final_falseRate);
    ERR.difference(i) = mean(result(i).final_difference);
end


disp('------------------------------------------------')
disp('Final hit rate, false alarm rate and their differences: ')
fprintf('Error:\n')
fprintf('Hit Rate:   ')
fprintf('%10.4f', ERR.hitRate);
fprintf('  = % 6.4f \n', nanmean(ERR.hitRate));
fprintf('False Rate: ')
fprintf('%10.4f', ERR.falseRate);
fprintf('  = % 6.4f \n', nanmean(ERR.falseRate));
fprintf('Difference: ')
fprintf('%10.4f', ERR.difference);
fprintf('  = % 6.4f \n', nanmean(ERR.difference));
fprintf('\n')
fprintf('Hit/False:\n')
fprintf('Hit Rate:   ')
fprintf('%10.4f', HF.hitRate);
fprintf('  = % 6.4f \n', nanmean(HF.hitRate));
fprintf('False Rate: ')
fprintf('%10.4f', HF.falseRate);
fprintf('  = % 6.4f \n', nanmean(HF.falseRate));
fprintf('Difference: ')
fprintf('%10.4f', HF.difference);
fprintf('  = % 6.4f \n', nanmean(HF.difference));

