clear;clc;

load('JLP_HF_TrueFaces_newMasks.mat')

numSub = 10;

% preallocate 
newMasks.accuracy = NaN(1,10);
newMasks.iterNum = NaN(1,10);
oldMasks.accuracy = NaN(1,10);
oldMasks.iterNum = NaN(1,10);

fprintf('\n------New results (new masks)------ \n')
fprintf('\t\tAccuracy \tNum Iterations\n')


for subID = 1:numSub;    
    newMasks.accuracy(subID) = mean(result(subID).finalAccuracy);
    newMasks.iterNum(subID) = size(result(subID).hitAll,1);
    fprintf(['Subject ' num2str(subID) '\t' num2str(newMasks.accuracy(subID)) '\t\t' num2str(newMasks.iterNum(subID)) ])
    fprintf('\n')
end
fprintf(['MEAN \t\t' num2str(nanmean(newMasks.accuracy)) '\t\t' num2str(mean(newMasks.iterNum)) '\n'])

fprintf('\n------old results------ \n')

load('JLP_HF_TrueFaces.mat')

fprintf('\t\tAccuracy \tNum Iterations\n')
for subID = 1:numSub;
    oldMasks.accuracy(subID) = mean(result(subID).finalAccuracy);
    oldMasks.iterNum(subID) = size(result(subID).hitAll,1);
    fprintf(['Subject ' num2str(subID) '\t' num2str(oldMasks.accuracy(subID)) '\t\t' num2str(oldMasks.iterNum(subID)) ])
    fprintf('\n')
end
fprintf(['MEAN \t\t' num2str(nanmean(oldMasks.accuracy)) '\t\t' num2str(mean(oldMasks.iterNum)) '\n'])