% Generate NIFTI
clear;


data = load_nii('ribbon01_funcRes+orig.nii.gz');

load('/Users/lcnl/Documents/MATLAB/JLP/data/jlp01.mat', 'IJK');

writeNIFTI('testing.nii',[64,64,30],IJK,data.hdr, 'fix');