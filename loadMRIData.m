% This function loads fMRI data for a project


function [MRIDATA,MRIMETA] = loadMRIData(experiment,subject) 
    switch experiment
        % load the jlp data (with old mask)
        case 'jlp'
            DATA_PATH = '../data';
            DATA_FILE = sprintf('jlp%02d.mat',subject);
            load(fullfile(DATA_PATH,'jlp_metadata.mat'));
            load(fullfile(DATA_PATH,DATA_FILE),'X');
            MRIDATA=X;
            MRIMETA = metadata;
            
        % load the jlp data (with new mask)
        case 'jlp_newmasks'
            DATA_PATH = '../data';
            DATA_FILE = sprintf('selectedFunctionalData/jlp%02d_hc_X_conds.mat',subject);
            load(fullfile(DATA_PATH,'jlp_metadata.mat'));
            load(fullfile(DATA_PATH,DATA_FILE),'X');
            MRIDATA=X;
            MRIMETA = metadata;
    end
end