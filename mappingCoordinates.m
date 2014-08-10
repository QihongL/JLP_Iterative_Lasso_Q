%% Find XYZs for the solutions
% Specify the subject and the cv block
subNum = 1;
cvBlock = 1;

% Load the data
[X,metadata] = loadMRIData('jlp',subNum);
% load the results
load('JLP_ERR_TrueFaces.mat')

% Figure out the number of significant iteration 
numSigIter = size(result(subNum).used,2);

% Get the XYZs
cod = metadata(subNum).xyz([find(result(subNum).used{numSigIter}(cvBlock,:) == 1)],:);
cod1 = round(cod);


%% TLRC
tlrc = load_nii('01train_pp1+orig.nii');

% Set the origin
% tlrc_min = [-70, -102, -42];
tlrc_min = [tlrc.hdr.hist.srow_x(end),tlrc.hdr.hist.srow_y(end),tlrc.hdr.hist.srow_z(end)];

% Transformation
cod1ijk = bsxfun(@minus, cod1, tlrc_min);

% tlrc_dim = [141, 172, 110];
tlrc_dim = [tlrc.hdr.dime.dim(2),tlrc.hdr.dime.dim(3),tlrc.hdr.dime.dim(4)];

img = zeros(tlrc_dim);

ix = collapse_grid(tlrc_dim, IJK);

img(ix) = 1;

% Make the nii file 
nii = make_nii(img, [3 3 3]);
nii.hdr = tlrc.hdr;
save_nii(nii,'test')


