%% set env and parameters
basedirectory = 'mydirectory';     % where store 

filename = "";
file_path = fullfile(basedirectory, filename);

% params for preprocess
preprocess_params.coversion_factor = 525;       % 像素 -> 毫米
preprocess_params.repfactor = 5;                % 下采样倍率


%% format the DANNCE data 
format_out = fullfile(basedirectory, "predictions.mat");

pred = load(data_path).pred;
predictions = format_data(data);

%% preprocess data
preprocess_out = fullfile(basedirectory, "mouseception_struct.mat");

mouseception_struct = preprocess_dannce(file_path, preprocess_out, preprocess_params, 'kylemouse');     
% note: use kylemouse, which match our skeleton settings

%% do CAPTURE analysis
[analysisstruct] = Copy_of_CAPTURE_quickdemo(preprocess_out, '', '', 'kylemouse');


%% clustering the points



%% save data



