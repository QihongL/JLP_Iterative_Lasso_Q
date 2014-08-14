%% Generate NIFTI
clear;

% load the coordinates
data = load_nii('ribbon01_funcRes+orig.nii.gz');
% load IJK
load('/Users/lcnl/Documents/MATLAB/JLP/data/jlp01.mat', 'IJK');


%% write to nifti file
writeNIFTI('testing.nii',[64,64,30],IJK, 1, data.hdr, 'fix');