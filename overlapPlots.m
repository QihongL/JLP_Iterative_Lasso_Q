%% Outputs voxel overlap plots
clear;


label = 'TrueFaces';

i = 1;


heatVec = cell(1,9);
coordinates = cell(1,9);

[heatVec{i}, coordinates{i}] =  overlapMap(i, label);


%% tlrc


data = load_nii('TT_N27+tlrc.nii.gz');


%% plot 

writeNIFTI('test',[64,64,30], coordinates{i} , heatVec{i}, data.hdr, 'fix');



