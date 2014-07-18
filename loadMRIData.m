function [MRIDATA,MRIMETA] = loadMRIData(experiment,subject) 

switch experiment
    case 'jlp'
        DATA_PATH = '../data';
        DATA_FILE = sprintf('jlp%02d.mat',subject);
        load(fullfile(DATA_PATH,'jlp_metadata.mat'));
        load(fullfile(DATA_PATH,DATA_FILE),'X');
        MRIDATA=X;
        MRIMETA = metadata;
end
end