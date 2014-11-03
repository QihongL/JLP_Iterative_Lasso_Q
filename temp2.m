clear;
faceOnly1 = load('JLP_HF_onlyFace_TrueFaces.mat');

accuracy = zeros(9,10);

for i = 1 : 9 
    accuracy(i,:) =  faceOnly1.result(i).finalAccuracy;
end



rawModels = load('JLP_HF_onlyFace_TrueFaces.mat');
finalModels = load('finalModels_faceOnly.mat');