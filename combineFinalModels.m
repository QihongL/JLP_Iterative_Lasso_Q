%% combine all final models for face system analysis
clear; 

% combine them into one file!
finalModel{1} = load('finalModels_wholeBrain.mat');
finalModel{2} = load('finalModels_noFace.mat');
finalModel{3} = load('finalModels_faceOnly.mat');

