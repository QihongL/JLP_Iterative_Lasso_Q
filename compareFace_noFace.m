%% Face system Analysis
clear; 

% CONSTANT
VERY_SMALL_NUM = 0.0000000001;

%% prep 
% load data 
noFace = load('JLP_HF_noFace_TrueFaces.mat');
wholeBrain = load('JLP_HF_TrueFaces.mat');
faceOnly = load('JLP_HF_onlyFace_TrueFaces.mat');

% select qualified subjects
subject = [1 2 3 8 9];
numSub = size(subject,2);



%% Compare face only, no face, whole brain classifiers

% preallocate
noFace.accuracy = zeros(numSub, 10);
noFace.hitRate = zeros(numSub, 10);

faceOnly.accuracy = zeros(numSub, 10);
faceOnly.hitRate = zeros(numSub, 10);

wholeBrain.accuracy = zeros(numSub, 10);
wholeBrain.hitRate = zeros(numSub, 10);

% loop over all subjects
i = 1;
for subNum = subject
    % get classification accuracy
    noFace.accuracy(i, :) = noFace.result(subNum).finalAccuracy;
    wholeBrain.accuracy(i, :) = wholeBrain.result(subNum).finalAccuracy;
    faceOnly.accuracy(i, :) = faceOnly.result(subNum).finalAccuracy;
    
    % get hit rate
    noFace.hit(i,:) = noFace.result(subNum).final_hitRate;
    wholeBrain.hit(i,:) = wholeBrain.result(subNum).final_hitRate;
    faceOnly.hit(i,:) = faceOnly.result(subNum).final_hitRate;
    
    % get false rate
    noFace.false(i,:) = noFace.result(subNum).final_falseRate;
    wholeBrain.false(i,:) = wholeBrain.result(subNum).final_falseRate;
    faceOnly.false(i,:) = faceOnly.result(subNum).final_falseRate;
    

    
    i = i + 1;
end


% printing the data

fprintf('\t\twholeBrain\t noFace\t\t faceOnly\n');

% mean classfication accuracy 
temp1 = mean(wholeBrain.accuracy(:));
temp2 = mean(noFace.accuracy(:));
temp3 = mean(faceOnly.accuracy(:));
fprintf('Accuracy \t%f\t %f\t %f \n', temp1,temp2,temp3);

% % mean hit rate 
% temp1 = mean(wholeBrain.hit(:));
% temp2 = mean(noFace.hit(:));
% temp3 = mean(faceOnly.hit(:));
% fprintf('HitRate \t%f\t %f\t %f \n', temp1,temp2,temp3);
% 
% % mean false alarm rate 
% temp1 = mean(wholeBrain.false(:));
% temp2 = mean(noFace.false(:));
% temp3 = mean(faceOnly.false(:));
% fprintf('FalseRate \t%f\t %f\t %f \n', temp1,temp2,temp3);

% mean d prime 
wholeBrain.hit(wholeBrain.hit == 0) = VERY_SMALL_NUM;
noFace.hit(noFace.hit == 0) = VERY_SMALL_NUM;
faceOnly.hit(faceOnly.hit == 0) = VERY_SMALL_NUM;

wholeBrain.false(wholeBrain.false == 0) = VERY_SMALL_NUM;
noFace.false(noFace.false == 0) = VERY_SMALL_NUM;
faceOnly.false(faceOnly.false == 0) = VERY_SMALL_NUM;

d1 = norminv(wholeBrain.hit) - norminv(wholeBrain.false);
d2 = norminv(noFace.hit) - norminv(noFace.false);
d3 = norminv(faceOnly.hit) - norminv(faceOnly.false);

temp1 = mean(d1(:));
temp2 = mean(d2(:));
temp3 = mean(d3(:));
fprintf('d prime \t%f\t %f\t %f \n', temp1,temp2,temp3);

