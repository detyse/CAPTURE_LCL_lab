function value = get_signal_value(all_data, index)
    int_index = round(index/10);
    if int_index < 1
        int_index = 1;
    end
    value = all_data(int_index, :);
end

