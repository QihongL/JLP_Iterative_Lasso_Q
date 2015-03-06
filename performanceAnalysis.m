function resultMatrix = performanceAnalysis(result)
numSubjects = size(result,2);

% precllocate
solvable = false(10, 1);
accuracy = NaN(10, 1);
hitRate = NaN(10, 1);
falseRate = NaN(10, 1);
dp = NaN(10, 1);

% loop over all subjects 
for i = 1: numSubjects
    if (size(result(i).HFsig,1 ) > 2)
        solvable(i) = true; 
        accuracy(i) = nanmean(result(i).finalAccuracy);    
        hitRate(i) = nanmean(result(i).final_hitRate);
        falseRate(i) = nanmean(result(i).final_falseRate);
        dp(i) = mean(dPrime(result(i).final_hitRate, result(i).final_falseRate));
end


resultMatrix = [solvable, accuracy, dp];
% fprintf('Solvable    accuracy    dp\n')
% disp(resultMatrix)

end