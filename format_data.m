function format_data(input_path, save_path)
    
    load_prediction = load(input_path);
    pred = load_prediction.pred;

    % 写死在函数里 and the data must with these joint, in this order
    marker_list = [
        "EarL",
        "EarR",
        "Snout",
        "SpineF",
        "SpineM",
        "tail_base_",
        "Tail_mid_",
        "ForepawL",
        "WristL",
        "ForelimbL",
        "ShoulderL",
        "ForepawR",
        "WristR",
        "ForelimbR",
        "ShoulderR",
        "HindpawL",
        "AnkleL",
        "HindlimbL",
        "HindpawR",
        "AnkleR",
        "HindlimbR" 
    ];

    desired_order = [ ...
        "Snout",      ... %1
        "EarR",       ... %2
        "EarL",       ... %3
        "SpineF",     ... %4
        "SpineM",     ... %5
        "tail_base_", ... %6
        "ForelimbL",  ... %7
        "ShoulderL",  ... %8
        "ForelimbR",  ... %9
        "ShoulderR",  ... %10
        "HindpawL",   ... %11
        "HindlimbL",  ... %12
        "HindpawR",   ... %13
        "HindlimbR",  ... %14
        "WristL",     ... %15    (edge 7–15)
        "ForepawL",   ... %16 ★  (仅占位，links 4–16/16–8/16–10)  % 
        "WristR",     ... %17    (edge 9–17)
        "ForepawR",   ... %18 ★  (edge 4–18)
        "AnkleL",     ... %19    (edge 11–19/19–12)
        "AnkleR",     ... %20    (edge 13–20/20–14)
        "Tail_mid_"   ... %21    (edge 21–6)
    ];

    [~, reorder_idx] = ismember(desired_order, marker_list);

    coords = pred(:, :, reorder_idx);

    marker_num = size(pred, 3);

    predictions = struct();

    for j = 1:marker_num
        marker = desired_order(j);
        marker_data = coords(:, :, j);

        % save the named data
        predictions.(marker) = marker_data;
    end
   
    save(fullfile(save_path, 'predictions.mat'), 'predictions');
end

