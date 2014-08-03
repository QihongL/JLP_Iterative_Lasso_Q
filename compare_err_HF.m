%% Analysis: compare two version of iterative lasso
clear;clc;close all;
% Pick a label
label = 'TrueThings';
disp('------------------------------------------------')
disp(['Label = ' label]);



%% Compare number of solvable subject (total)
% Error
load(['JLP_ERR_' label '.mat']);
solv.acc = false(1,10);
for SubNum = 1:10
    i = SubNum;
    % final accuracy is NaN => not solvable
    if ~isnan(result(i).finalAccuracy(1))
        % Get the indices for non-solvable subject
        solv.acc(i) = true;
    end
    % Calculate the number of non-solvable subject
    solv.acc_num = sum(solv.acc);
end


% Hit/False
load(['JLP_HF_' label '.mat'])
solv.HF = false(1,10);
for SubNum = 1:10
    i = SubNum;
    % final accuracy is NaN => not solvable
    if ~isnan(result(i).finalAccuracy(1))
        % Get the indices for non-solvable subject
        solv.HF(i) = true;
    end
    % Calculate the number of non-solvable subject
    solv.HF_num = sum(solv.HF);
end

% Display number of solvable subjects
disp(' ')
disp('------------------------------------------------')
disp('Solvable subjects: ' );
disp(['Error:     ' num2str(solv.acc) '  =  ' num2str(solv.acc_num)])
disp(['Hit/False: ' num2str(solv.HF) '  =  ' num2str(solv.HF_num)])



%% Compare number of voxels selected (total)

% Error
load(['JLP_ERR_' label '.mat']);
% Resource preallocation
voxels_acc.all = zeros(10,10);
% Get data (This version does not exclude unsolvable subjects)
for SubNum = 1:10
    i = SubNum;
    voxels_acc.all(i,:) = result(i).hitAll(end,:);
end

% For hit/false
load(['JLP_HF_' label '.mat'])
% Resource preallocation
voxels_HF.all = zeros(10,10);
% Get data (This version does not exclude unsolvable subjects)
for SubNum = 1:10
    i = SubNum;
    voxels_HF.all(i,:) = result(i).hitAll(end,:);
end

% t test
[t_all, p_all] = ttest(voxels_HF.all(:),voxels_acc.all(:));
 
% exclude non-solvable subjects
voxels_acc.solvable = voxels_acc.all(solv.acc,:);
voxels_HF.solvable = voxels_HF.all(solv.HF,:);
[t_solvable, p_solvable] = ttest( mean(voxels_HF.solvable),mean(voxels_acc.solvable) );

% Display the total number of voxels were being selected (average accross subject)
disp(' ')
disp('------------------------------------------------')
disp('Total number of voxels were being selected (including unsolvable subjects): ' );
fprintf('\t\t Error\t\t Hit/False \t T-test \t P-value \n' );
fprintf('All_Sub %15.2f %16.2f %12d %17.4f \n', mean(voxels_acc.all(:)), mean(voxels_HF.all(:)), t_all, p_all );
fprintf('Solvable %14.2f %16.2f %12d %17.4f \n', mean(voxels_acc.solvable(:)), mean(voxels_HF.solvable(:)), t_solvable, p_solvable );



%% Compare number of iterations 

% Error
load(['JLP_ERR_' label '.mat']);
numIter_acc.all = zeros(1,10);
for SubNum = 1:10
    i = SubNum;
    numIter_acc.all(i) = size(result(i).lasso_sig,1);
end

% For hit/false
load(['JLP_HF_' label '.mat']);
numIter_HF.all = zeros(1,10);
for SubNum = 1:10
    i = SubNum;
    numIter_HF.all(i) = size(result(i).HFsig,1);
end





% Display reuslts
disp(' ')
disp('------------------------------------------------')
disp('Number of iterations(all subjects): ' );
fprintf('Error\t\t')
fprintf('%4d  ', numIter_acc.all)
fprintf(' = %.2f', mean(numIter_acc.all))
fprintf('\n')
fprintf('Hit/False\t')
fprintf('%4d  ', numIter_HF.all)
fprintf(' = %.2f', mean(numIter_HF.all))
fprintf('\n')
disp(' ')

% Change unsolvable subjects to NaN
numIter_acc.solve = numIter_acc.all .* solv.acc;
numIter_HF.solve = numIter_HF.all .* solv.HF;
numIter_acc.solve(numIter_acc.solve == 0) = NaN;
numIter_HF.solve(numIter_HF.solve == 0) = NaN;

disp('Number of iterations(only sovlable subjects): ' );
fprintf('Error\t\t')
fprintf('%4d  ', numIter_acc.solve)
fprintf(' = %.2f', mean(numIter_acc.all(solv.acc)))
fprintf('\n')
fprintf('Hit/False \t')
fprintf('%4d  ', numIter_HF.solve)
fprintf(' = %.2f', mean(numIter_HF.all(solv.HF)))
fprintf('\n')
disp(' ')



%% Compare accuracy, hit & false

