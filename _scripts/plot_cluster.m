function plot_cluster(clusters, varargin)
% 画二维聚类结果，每个聚类区域用 colormap 的不同颜色表示
%
% clusters  : 1×K cell，每个元素是 [Ni × 2] 的 (x, y) 点坐标
% 'Boundary': convex | boundary | alpha   （默认 'boundary'）
% 'Alpha'   : patch 透明度                （默认 0.8）
% 'Colormap': 任意 M×3 colormap           （默认 parula(256)）
% 其它参数见下

% ---------- 0. 解析参数 ----------
p = inputParser;
addParameter(p, 'Boundary',   'boundary');
addParameter(p, 'Alpha',      0.8);
addParameter(p, 'Colormap',   turbo);
addParameter(p, 'ShowPoints', true);
addParameter(p, 'ShowText',   true);
parse(p, varargin{:});
opt = p.Results;

% ---------- 1. 基础准备 ----------
cmap = opt.Colormap;
nC   = size(cmap, 1);
nClu = numel(clusters);          % 聚类数

figure; hold on; axis equal; box on;
set(gcf, 'Color', 'w');
set(gca, 'FontSize', 10);

% ---------- 2. 遍历每个 cluster ----------
for k = 1:nClu
    pts = clusters{k};
    x = pts(:, 1);  y = pts(:, 2);

    % ---- 2.1 计算边界索引 ----
    switch lower(opt.Boundary)
        case 'convex'
            idx = convhull(x, y);
        case 'boundary'
            idx = boundary(x, y, 0.2);
        case 'alpha'
            shp = alphaShape(x, y, 1.0);
            [bx, by] = boundaryFacets(shp);
        otherwise
            error('Unknown Boundary option.');
    end

    % ---- 2.2 计算颜色 ----
    % 把 cluster 序号 k 均匀映射到 [1, nC]
    ci = round((k - 1) / max(1, nClu - 1) * (nC - 1)) + 1;
    faceColor = cmap(ci, :);

    % ---- 2.3 绘制区域 ----
    if strcmpi(opt.Boundary, 'alpha')
        patch('XData', bx, 'YData', by, ...
              'FaceColor', faceColor, 'EdgeColor', 'none', ...
              'FaceAlpha', opt.Alpha);
    else
        patch('XData', x(idx), 'YData', y(idx), ...
              'FaceColor', faceColor, 'EdgeColor', 'none', ...
              'FaceAlpha', opt.Alpha);
    end

    % ---- 2.4 可选：散点 / 文本 ----
    % if opt.ShowPoints
    %     scatter(x, y, 10, 'k', 'filled', 'MarkerFaceAlpha', .4);
    % end
    if opt.ShowText
        text(mean(x), mean(y), sprintf('%d', k), ...
             'HorizontalAlignment', 'center', ...
             'FontWeight', 'bold', 'Color', 'k');
    end
end

% ---------- 3. 颜色条 ----------
colormap(cmap);
cb = colorbar;
cb.Label.String = 'Cluster index';
caxis([1, nClu]);                % 用 cluster 序号作为刻度
title('Cluster regions colored by index');
end