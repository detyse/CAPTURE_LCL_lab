% run this script before plots

load("_test_folder\34A_zscored.mat");
load("_test_folder\analysisstruct_34A.mat");

signal = data.channel_470;

zValue = analysisstruct.zValues;

frameIdx = analysisstruct.frames_with_good_tracking{1};

% get the index of different clusters, and save them
membership = analysisstruct.annot_reordered{end, end};
clusterIDs = analysisstruct.sorted_clust_ind(:);

clustered = cell(1, numel(clusterIDs));

for k = 1:numel(clusterIDs)
   cid = clusterIDs(k);
   clustered{cid} = frameIdx(membership == k);
end

clustered_z = cell(1, numel(clusterIDs));

for k = 1:numel(clusterIDs)
    cid = clusterIDs(k);
    clustered_z{cid} = zValue(membership == k, :);
end

%% get the single value
clustered_v = cell(1, numel(clusterIDs));
for k = 1:numel(clusterIDs)
    idx_list = clustered{k};
    v_in_cluster = cell(1, numel(idx_list));
    for idx = 1:numel(idx_list)
        v_in_cluster{idx} = get_signal_value(signal, idx_list(idx));
    end 
    clustered_v{k} = v_in_cluster;
end

%% get data and make plots
% data_length = 100;
% clustered_data = cell(1, numel(clusterIDs));
% 
% for k = 1:numel(clusterIDs)
%     idx_list = clustered{k};
%     data_in_cluster = cell(1, numel(idx_list));
%     for idx = 1:numel(idx_list)
%         data_in_cluster{idx} = get_signal_segment(signal, idx_list(idx), 30);
%     end 
%     clustered_data{k} = data_in_cluster;
% end


%% get the single value vec
value_vec = signal(ceil(frameIdx/10), :);
