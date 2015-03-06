clear; clc 


load('JLP_HF_TrueFaces.mat')
old.face = performanceAnalysis(result);
load('JLP_HF_TruePlaces.mat')
old.place = performanceAnalysis(result);
load('JLP_HF_TrueThings.mat')
old.object = performanceAnalysis(result);

load('JLP_HF_TrueFaces_newMasks.mat')
new.face = performanceAnalysis(result);
load('JLP_HF_TruePlaces_newMasks.mat')
new.place = performanceAnalysis(result);
load('JLP_HF_TrueThings_newMasks.mat')
new.object = performanceAnalysis(result);


%% 

disp('Old masks')
disp('Face')
disp(old.face)
disp('Place')
disp(old.place)
disp('Object')
disp(old.object)

disp('New masks')
disp('Face')
disp(new.face)
disp('Place')
disp(new.place)
disp('Object')
disp(new.object)


%% 
fprintf('\n')
fprintf('Accuracy\n')
fprintf('\told masks \t new masks\n')
fprintf('Face\t%f\t%f\n', nanmean(old.face(:,2)), nanmean(new.face(:,2)))
fprintf('Place\t%f\t%f\n', nanmean(old.place(:,2)), nanmean(new.place(:,2))) 
fprintf('Object\t%f\t%f\n', nanmean(old.object(:,2)), nanmean(new.object(:,2)))

fprintf('\n')
fprintf('Dprime\n')
fprintf('\told masks \t new masks\n')
fprintf('Face\t%f\t%f\n', nanmean(old.face(:,3)), nanmean(new.face(:,3)))
fprintf('Place\t%f\t%f\n', nanmean(old.place(:,3)), nanmean(new.place(:,3))) 
fprintf('Object\t%f\t%f\n', nanmean(old.object(:,3)), nanmean(new.object(:,3)))