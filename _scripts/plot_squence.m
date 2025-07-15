function plot_squence(data_cluster, target_length, channel)
%PLOT_SEQUENCE  画同长多序列并突出平均 ± SEM
%
% data_cluster : 1×M cell，每个元素是 [T × C] 数组或向量
% target_length: 希望的帧长（T）
% channel      : （可选）使用哪一列数据，默认 1
%
% 例：plot_sequence(trials, 120, 3)
    % numel(data_cluster)

    % filter data not long enough
    using_seq = {};
    for i = 1:numel(data_cluster)
        seq = data_cluster{i};
        % 保证按列取；若 seq 是行向量 -> 转列
        % if isrow(seq), seq = seq.'; end

        % size(seq)

        if size(seq, 1) == target_length
            using_seq{end+1,1} = seq(:, channel);   % T × 1
        end
    end

    % plot the data
    N = numel(using_seq);
    if N == 0
        warning('没有任何序列满足 target_length = %d', target_length);
        return
    end

    % N

    %% 2. 整合成 [N × T] 矩阵，方便向量化运算
    data  = cat(2, using_seq{:}).';   % -> N × T

    %% 3. X 轴
    half_length = floor(target_length/2);
    t = (-half_length):(target_length-half_length-1);   % 1 × T

    %% 4. 绘图
    hold on; box off; set(gcf,'color','w');

    % 单条轨迹（半透明灰色）
    plot(t, data', 'Color',[0.6 0.6 0.6 0.25], 'LineWidth',0.5);

    % 平均 & SEM
    m   = mean(data, 1, 'omitnan');                     % 1 × T
    sem = std(data, 0, 1, 'omitnan') ./ sqrt(N);        % 1 × T

    fill([t fliplr(t)], [m+sem fliplr(m-sem)], ...
         [0.3 0.6 1.0], 'FaceAlpha',0.2, 'EdgeColor','none');

    plot(t, m, 'Color',[0.1 0.45 0.9], 'LineWidth',1.8);

    %% 5. 美化
    xlabel('Time (frame)');
    ylabel('\DeltaF/F (%)');
    title(sprintf('Neural signal (%d trials, length=%d)', N, target_length));
    set(gca,'FontSize',10);
    xlim([t(1) t(end)]);
end

