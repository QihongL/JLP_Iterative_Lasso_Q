%% Compare final models for (i) wholeBrain, (ii) faceOnly (iii) noFace
clear; 

%% declare constant & load data
CHANCE = 2/3;

wholeBrain = load('finalModels_wholeBrain.mat');
noFace = load('finalModels_noFace.mat');
faceOnly = load('finalModels_faceOnly.mat');

% subjects without alignment problem 
subjects = [1 2 3 4 5 6 8 9];
% subjects = [1 2 3 8 9];

%% accuracy

% remove subjects with serious alignment problem 
temp1 = wholeBrain.finalModels.accuracy(subjects,:);
temp2 = noFace.finalModels.accuracy(subjects,:);
temp3 = faceOnly.finalModels.accuracy(subjects,:);

% compute mean accuracies
temp1(isnan(temp1)) = CHANCE;
temp2(isnan(temp2)) = CHANCE;
temp3(isnan(temp3)) = CHANCE;

wholeBrainAcc = mean(temp1(:));
noFaceAcc = mean(temp2(:));
faceOnlyAcc = mean(temp3(:));

fprintf('\t\twholeBrain\t noFace\t\t faceOnly\n');
fprintf('Accuracy \t%f\t %f\t %f \n', wholeBrainAcc,noFaceAcc,faceOnlyAcc);



%% d prime 

% remove subjects with serious alignment problem 
wholeBrainHit = wholeBrain.finalModels.hitRate(subjects,:);
wholeBrainFalse = wholeBrain.finalModels.falseRate(subjects,:);

noFaceHit = noFace.finalModels.hitRate(subjects,:);
noFaceFalse = noFace.finalModels.falseRate(subjects,:);

faceOnlyHit = faceOnly.finalModels.hitRate(subjects,:);
faceOnlyFalse = faceOnly.finalModels.falseRate(subjects,:);

% compute the d prime
d1 = dPrime(wholeBrainHit, wholeBrainFalse);
d2 = dPrime(noFaceHit, noFaceFalse);
d3 = dPrime(faceOnlyHit, faceOnlyFalse);

wholeBrainDP = mean(d1(:));
noFaceDP = mean(d2(:));
faceOnlyDP = mean(d3(:));

fprintf('d prime \t%f\t %f\t %f \n', wholeBrainDP,noFaceDP,faceOnlyDP);