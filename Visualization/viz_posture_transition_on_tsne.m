function viz_posture_transition_on_tsne(analysisstruct, cmapname, params)
% t-SNE 轨迹动画 + 每个 cluster 独立轮廓
% -------------------------------------------------------------------------

%% 0 — 默认参数
if nargin < 2 || isempty(cmapname), cmapname = 'parula'; end
if nargin < 3, params = struct;                      end
if ~isfield(params,'clusterboundary'), params.clusterboundary = true; end
if ~isfield(params,'watershedboundary'), params.watershedboundary = true; end   % 叠加分水岭边界
if ~isfield(params,'alpha'),           params.alpha = 0.03;           end  % 0.01-0.05
if ~isfield(params,'boundarywidth'),   params.boundarywidth = 1.8;    end  % 线宽
if ~isfield(params,'watershedwidth'),   params.watershedwidth = 1.8;    end  % 线宽

%% 1 — 取播放帧序列
if isfield(analysisstruct,'frames_with_good_tracking') && ...
        ~isempty(analysisstruct.frames_with_good_tracking)
    idx1 = analysisstruct.frames_with_good_tracking{1};
    idx2 = analysisstruct.frames_with_good_tracking{2};
    % 若 {1} 超出 zValues 行数，则用 {2}
    if max(idx1) <= size(analysisstruct.zValues,1)
        idx = idx1;
    else
        idx = idx2;
    end
else
    idx = (1:size(analysisstruct.zValues,1))';
end

Y = analysisstruct.zValues(idx,:);           % N×2
n = size(Y,1);
if n < 2, error('播放序列不足两帧'); end

%% 2 — 渐变色
if ischar(cmapname) || isstring(cmapname)
    cmap = feval(cmapname,n);
elseif isnumeric(cmapname) && size(cmapname,2)==3
    cmap = cmapname(1:n,:);
else
    error('cmapname 应为 colormap 名或 n×3 数组');
end

%% 3 — 建图
fig = figure('Name','t-SNE preview','Color','w');
ax  = axes(fig); hold(ax,'on');
axis(ax,'equal');
xlim(ax,[min(Y(:,1)) max(Y(:,1))]);
ylim(ax,[min(Y(:,2)) max(Y(:,2))]);
title(ax,'t-SNE posture transition');
colormap(ax,cmap); colorbar(ax,'southoutside');

%% 6 — 选画 watershed 边界（Figure 609 的做法）
if params.watershedboundary
    needed = {'sorted_watershed','xx','yy'};
    assert(all(isfield(analysisstruct,needed)), ...
        'analysisstruct 缺少 sorted_watershed / xx / yy 字段');

    mask = analysisstruct.sorted_watershed;
    mask(mask>0) = 1;                           % 二值化
    B = bwboundaries(flipud(mask));             % y 轴已在 tsne 空间翻转过

    hold(ax,'on')
    for kk = 1:numel(B)
        % 将像素坐标映射回 t-SNE 坐标：
        xpts = analysisstruct.xx(B{kk}(:,2));   % 列 → x
        ypts = analysisstruct.yy(B{kk}(:,1));   % 行 → y
        plot(ax,xpts,ypts,'Color',[0 0 0], ...
             'LineWidth',params.watershedwidth);
    end
    hold(ax,'off')
end

%% 4 — 先播放动画（避免盖住轮廓）
curr = scatter(ax,Y(1,1),Y(1,2),60,'filled', ...
               'MarkerFaceColor','r','MarkerEdgeColor','k');

for k = 2:n
    line(ax,Y(k-1:k,1),Y(k-1:k,2), ...
         'Color',cmap(k,:),'LineWidth',1.2);
    curr.XData = Y(k,1); curr.YData = Y(k,2);
    drawnow limitrate
end

%% 5 — 最后叠加 α-shape 轮廓（始终位于最上层）
if params.clusterboundary
    req = {'annot_reordered','sorted_clust_ind'};
    assert(all(isfield(analysisstruct,req)), ...
        'analysisstruct 缺少 annot_reordered 或 sorted_clust_ind');

    clusterIDs = analysisstruct.sorted_clust_ind(:);
    K = numel(clusterIDs);

    % 轮廓颜色
    if isfield(params,'clustercolors') && ...
            isnumeric(params.clustercolors) && ...
            all(size(params.clustercolors)==[K 3])
        cclrs = params.clustercolors;
    else
        cclrs = lines(K);
    end

    membership = analysisstruct.annot_reordered{end,end};
    hold(ax,'on');
    for k = 1:K
        pts = analysisstruct.zValues(membership==clusterIDs(k),:);
        if size(pts,1) < 3, continue, end
        shp = boundary(pts(:,1),pts(:,2),params.alpha);
        plot(ax,pts(shp,1),pts(shp,2), ...
            'Color',cclrs(k,:), ...
            'LineWidth',params.boundarywidth);
    end
    hold(ax,'off');
end

disp('✓  动画 + 轮廓 完成');
end