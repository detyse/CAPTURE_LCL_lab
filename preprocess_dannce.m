%[fList,pList] = matlab.codetools.requiredFilesAndProducts('preprocess_dannce.m');

% File Here to preprocess
function ratception_struct = preprocess_dannce(filein,fileoutput,animalname,input_params)

% Inputs: filein: a .mat file containing a predictions.mat DANNCE struct, with a
%                 struct containing each markers x-y-z prediction 
%
%         fileoutput: a .mat file 
%
%         animalname: the name of the animal (default - "kylemouse") that
%             defines the number of links and markers to use for a given
%             dataset in load_link_files.m. Other pre-defined options
%             include: 'mouse' (14 marker) kyle_mouse (20 marker)
%
%         input_params: a struct containing experiment specific
%                       information: the markers to use as
%                       SpineF (SpineF_marker) and SpineM (SpineM_marker)
%                       to align the animal, the relative framerate to 300
%                       Hz (repfactor = 300/experiment framerate),
%                       conversion factor (to scale the outputs)


%% check the input -- no input means run with defaults
if isempty(filein)
datahere = load('D:\YL_Wang\CAPTURE_LCL_lab\_demo_data\predictions.mat');
else
    datahere = load(filein);
end

if isempty(fileoutput)
    fileoutput = '_demo_data\test_mouse_ceptionstruct.mat';
end

if isempty(animalname)
animalname = 'kylemouse';
end

% rename the SpineF_marker -> SpineF
% 没用
if ~isempty(input_params)   
if isfield(input_params,'SpineF_marker')   
       f = fieldnames(datahere.predictions);
    v = struct2cell(datahere.predictions);
    f{strmatch(input_params.SpineF_marker,f,'exact')} = 'SpineF';
    f{strmatch(input_params.SpineM_marker,f,'exact')} = 'SpineM';
    a = cell2struct(v,f);
    disp(a)
    datahere.predictions=a;    
end
end


%do some surgery on names -- important for 
% will not have these
if isfield(datahere.predictions,'sampleID')
    datahere.sampleID = datahere.predictions.sampleID;
    datahere.predictions =rmfield(datahere.predictions,'sampleID');
end


if ~isempty(input_params)
if isfield(input_params,'conversion_factor') 
    markernames = fieldnames(datahere.predictions);
for lk=1:numel(markernames)
    datahere.predictions.(markernames{lk}) =  ...
        input_params.conversion_factor.*datahere.predictions.(markernames{lk});
    
end
end
end

if isempty(input_params) || ~isfield(input_params,'repfactor') 
params.repfactor=2;
else
   params.repfactor = input_params.repfactor;
end
    
    
% file specific changes in names
% not for us
if isfield(datahere.predictions,'HeadBR')
    f = fieldnames(datahere.predictions);
    v = struct2cell(datahere.predictions);
    f{strmatch('HeadBR',f,'exact')} = 'HeadB';
    f{strmatch('HeadBL',f,'exact')} = 'HeadL';
    a = cell2struct(v,f);
    disp(a)
    datahere.predictions=a;
end

% parameters for preprocessing
preprocessing_parameters = struct();
preprocessing_parameters.median_filt_length = 5;
preprocessing_parameters.bad_frame_vel_thresh = 150; %this effectively turns the velocity criteria off
preprocessing_parameters.bad_frame_surround_flag = 0;
preprocessing_parameters.bad_frame_surround_number = 1;
preprocessing_parameters.interpolation_max_length = 5;
preprocessing_parameters.meanvelocity_lowpass = 60;
preprocessing_parameters.meanvelocity_lowpass = 60;
preprocessing_parameters.fastvelocity_threshold = 0.01;% 0.1;
preprocessing_parameters.moving_threshold = 0.00001;%0.015;
preprocessing_parameters.moving_framewindow = 600;

% the difference in framerate between the video and the canonical motion capture
% datasets

ratception_struct = preprocess_ratception_struct_demo(datahere,preprocessing_parameters,params);

%% load
[links,colors] = load_link_files(animalname);
ratception_struct.links = links;
ratception_struct.markercolor = colors;
ratception_struct.markercolor = colors;

%% save
save(fileoutput,'ratception_struct','-v7.3')


