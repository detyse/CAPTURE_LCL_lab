function [segment] = get_signal_segment(all_data, index, data_points)
    int_index = round(index/10);
    data_length = length(all_data);
    half_data = round(data_points/2);
    start = max(1, int_index-half_data)
    finish = min(data_length, int_index+half_data)
    segment = all_data(start:finish, :);
end
