%% Get coordinates for the face system
% face system refers to voxels sets from Kanwishers' parcels
%
% @return - coordinates (n x 3)
% n = number of voxels
% 
% The file that contains the coordinates text files needs to be in the same
% folder. The text files were created with AFNI functions


function FaceCoordinates = GetFFACoords()

% load the metadata
DATA_PATH = '../../data';
load(fullfile(DATA_PATH,'jlp_metadata.mat'));

% get coordinates from the text files
files = ls('coordinateDumps/');
files = strsplit(files);

for i = 1:length(files)
    if isempty(files{i})
        continue
    end
    FaceParcels{i} = dlmread(fullfile('coordinateDumps',files{i}), ' ');
end

% organize the coordinates
FaceCoordinates = cell2mat(FaceParcels');
FaceCoordinates = FaceCoordinates(:,5:7);

% FaceCoordinatesSplat = mat2cell(FaceCoordinates, ...
%     size(FaceCoordinates,1), ...
%     ones(1,size(FaceCoordinates,2)));

% visualize it on the brain, to see if they match 

% SubCortexSplat = mat2cell(metadata(1).xyz_tlrc, ...
%     size(metadata(1).xyz_tlrc,1), ...
%     ones(1,size(metadata(1).xyz_tlrc,2)));


% plotting

% plot3(xyz333Splat{:},'.');
% hold on
% plot3(face333Splat{:},'ro')
% plot3(tempSplat{:},'g+')
% hold off

end