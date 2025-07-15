% here is a run script using our data, adapted from the bird demo

%% 
basedirectory = '_test_folder';

% note the data 
% %
% datafile = strcat(basedirectory, filesep, 'predictions_34A.mat');
% % 
% datafile_out = strcat(basedirectory, filesep, 'mouseception_struct_34A.mat');
% % 
% % %% preprocesss the data
% mouseception_struct = preprocess_dannce(datafile,datafile_out,'','kylemouse');

%% run CAPTURE_demo
[analysisstruct] = Copy_of_CAPTURE_quickdemo(strcat(basedirectory,filesep,'mouseception_struct_34A.mat'),'','','kylemouse');