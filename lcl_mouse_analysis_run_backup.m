% here is a run script using our data, adapted from the bird demo

%% 
basedirectory = '_test_folder';
%
% datafile = strcat(basedirectory, filesep, 'predictions_34A_repeats.mat');
datafile = strcat(basedirectory, filesep, 'predictions_34A_concat.mat');

datafile_out = strcat(basedirectory, filesep, 'mouseception_struct_34A_concat.mat');

%% preprocesss the data
mouseception_struct = preprocess_dannce(datafile,datafile_out,'','kylemouse');

%% run CAPTURE_demo
[analysisstruct_concat] = Copy_of_CAPTURE_quickdemo(strcat(basedirectory,filesep,'mouseception_struct_34A_concat.mat'),'','','kylemouse');