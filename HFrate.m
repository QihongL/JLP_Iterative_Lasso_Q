function [ hitRate, falseAlarmRate ] = HFrate( prediction, testset )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

hitRate = sum(prediction & testset) / sum(testset);
falseAlarmRate = sum(prediction & ~testset) / sum(~testset);

end

