%% Write out solution for each subject
% Related to txt2nii.sh, blurFMRI.sh, sumFMRI.sh

% Set label 
label = 'TrueFaces';
% Set the lower bound for CV consistency 
consistency = 9;

%% Get all voxels satisfy CV lower bound

% Preallocate
filteredSSheatmap = cell(10,1);

% loop over all subjects
textprogressbar(['Get coordinates and heatmap for all subjects: ']);
for subNum = 1:10;
    textprogressbar(subNum * 10);

    % Get a single subject heat map 
    SingleSubHeatmap = singleSubHeatmap(subNum, label);

    % Get voxels that above CV consistency 
    filteredSSheatmap{subNum} = SingleSubHeatmap( SingleSubHeatmap(:,4) >= consistency, : );

end
textprogressbar('Done.\n') 





% % Write to text
% fileName = sprintf('heatmap_subt%.2d_%.2d_%s.txt', subNum, consistency, label);
% fileName
% %heatmap2txt('Testing', filteredSSheatmap);


