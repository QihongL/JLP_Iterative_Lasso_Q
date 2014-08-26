%% Consistency analysi using Kanwisher's ROI
% Trying to replicate the histogram analysis in MANGO
clc;clear;

% specify label / subject number
label = 'TrueFaces';
subNum = 1;


% % load Kanwisher's ROIs
% ROI = load_nii(['Users/lcnl/Documents/MATLAB/JLP/ParcelAnalysis/tlrc_' label '_all_roi.nii.gz'])

% Load the data for a subject 
temp = sprintf(['sub%.2d_HF_' label '.nii'], subNum);
data = load_nii(['/Users/lcnl/Documents/MATLAB/JLP/Iterlasso_plots/' temp],subNum)

