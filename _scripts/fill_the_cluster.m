function fill_the_cluster(clusters, scores, varargin)

% ---------- 0. 解析参数 ----------
p = inputParser;
addParameter(p, 'Boundary',   'boundary'); % convex|boundary|alpha
addParameter(p, 'Alpha',      0.8);       % FaceAlpha
addParameter(p, 'Colormap',   parula(256));
addParameter(p, 'ShowPoints', true);
addParameter(p, 'ShowText',   true);
parse(p, varargin{:});
opt = p.Results;

% ---------- 1. 归一化到颜色索引 ----------
cmap = opt.Colormap;
nC  = size(cmap,1);
vmin = min(scores);
vmax = max(scores);
score2idx = @(v) max(1, min(nC, ...
                 round( 1 + (v - vmin) / (vmax - vmin) * (nC-1) )));

figure; hold on; axis equal; box on;
set(gcf,'Color','w');
set(gca,'FontSize',10);

% ---------- 2. 遍历 cluster ----------
for k = 1:numel(clusters)
    pts = clusters{k};              % the pts number not aligned
    x = pts(:,1);  y = pts(:,2);
    
    % ---- 2.1 求边界顶点索引 ----
    switch lower(opt.Boundary)
        case 'convex'
            idx = convhull(x,y);
        case 'boundary'
            idx = boundary(x,y,0.2);        % shrink factor 可调
        case 'alpha'
            shp = alphaShape(x,y,1.0);      % 1.0 可外传
            [bx,by] = boundaryFacets(shp);  % 多条边可能不连续
            % bx,by 已闭合，下节直接 patch
        otherwise
            error('Unknown Boundary option.');
    end
    
    % ---- 2.2 画区域 ----
    ci = score2idx(scores(k));      % 映射到 colormap 行
    faceColor = cmap(ci,:);
    
    if strcmpi(opt.Boundary,'alpha')
        patch('XData',bx,'YData',by,...
              'FaceColor',faceColor, 'EdgeColor','none', ...
              'FaceAlpha',opt.Alpha);
    else
        patch('XData',x(idx),'YData',y(idx), ...
              'FaceColor',faceColor,'EdgeColor','none', ...
              'FaceAlpha',opt.Alpha);
    end
    % 
    % % ---- 2.3 画散点 / 文本 ----
    % if opt.ShowPoints
    %     scatter(x,y,15,'k','filled','MarkerFaceAlpha',.6);
    % end
    
    if opt.ShowText
        cx = mean(x); cy = mean(y);
        text(cx,cy, sprintf('%.2f', scores(k)), ...
             'HorizontalAlignment','center', ...
             'FontWeight','bold', 'Color','k');
    end
end

% ---------- 3. 颜色条 ----------
colormap(cmap);
cb = colorbar; cb.Label.String = 'Cluster score';
caxis([vmin vmax]);
title('Cluster regions colored by score');

end
