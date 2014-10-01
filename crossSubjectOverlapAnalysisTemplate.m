radius = 9;

% Get total number of voxel, construct the data matrix
X = zeros(totalVoxelsOverAllSubjects,5);
% Construct solution matrix for the same size 
SOLUTION = zeros(size(X,1),1);


% loop over 10 threshold for cv consistency
for crit = 0:9
    % concatenation index
    a = 1;
    % 10 subj
    for subj = 1:10
        % Concatenate
        x = SubjData{subj};
        n = size(x,1);
        b = a + n - 1;
        X(a:b,:) = [repmat(subj,n,1),x];
        a = a + n + 1;
    end
    
    % find voxel above certian CV consistency
    z = X(:,5) > crit;
    X_crit = X(:,z);
    % Compute distance matrix 
    D = pdist(X(:,2:4));
    
    % Get voxels blocks for each subject 
    zz = bsxfun(@eq, X(:,1), X(:,1)');
    D(zz) = Inf;
    
    % Overlap voxel = voxel within certian radius...
    ovox = any(tril(D) < radius);
    
    % write to solution
    SOLUTION(z) = ovox * crit;
end

% Concatenate the solution to X
X = [X, SOLUTION];
OUTPUT = X(SOLUTION > 0, [2:4,6]);