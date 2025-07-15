function scores = gather_channel_values(clustered_values, channel)
    % 这里应该有两层
    % the values should be the 1xcluster_num cell with 1xdata_num cell, and with 1xchannels_num as data
    % of each cell
    % and return the scores, all the data 
    scores = cell(1, numel(clustered_values));
    for c = 1:numel(clustered_values)
        values = clustered_values{c};
        score_list = cell(1, numel(clustered_values));
        for i = 1:numel(values)
            score_list{i} = values{i}(channel);
        end 
        % transfer to array
        the_score = cell2mat(score_list);
        scores{c} = the_score;
    end 
end
