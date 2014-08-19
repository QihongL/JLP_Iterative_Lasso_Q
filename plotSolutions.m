%% Plot the solutions for iterative lasso
function plotSolutions(subNum, type, label)


%% prep
% % Set some parameters
% type = 'ERR';
% label = 'TrueFaces';
% subNum = 1;

% load the results
load(['JLP_' type '_' label '.mat'])

% Determine which iteration to pick
STOPPING_RULE = 1;
iterNum = size(result(subNum).used,2) - STOPPING_RULE;



%% Get voxels 

% Set the lower boundary for inclusion 
boundary = 0;
% Raw solution
solution = sum(result(subNum).used{iterNum})';
% Select subset 
logicalFactor = solution >= boundary;
solution = solution .* logicalFactor;


%% plot

% load the coordinates
temp = sprintf('ribbon%.2d_funcRes+orig.nii.gz',subNum);
data = load_nii(temp);

% load IJK
temp = sprintf('/Users/lcnl/Documents/MATLAB/JLP/data/jlp%.2d.mat', subNum);
load(temp, 'IJK');


% write to nifti file
temp = sprintf(['sub%.2d_' type '_' label '.nii'], subNum);

writeNIFTI(temp,[64,64,30], IJK , solution, data.hdr, 'fix');


end

