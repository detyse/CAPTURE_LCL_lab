function plot_value_density_5(points, values, numPoints, rangeVals, gammaAlpha, channel)
%PLOT_VALUE_DENSITY_2  Color = average(values), Alpha = point density
%
%   points     : N×2 [x y] coordinates
%   values     : N×1 numeric vector, value associated with each point
%   numPoints  : scalar or [nx ny], grid resolution (odd is best)
%   rangeVals  : [xmin xmax; ymin ymax] or scalar -> symmetric range
%   gammaAlpha : (optional) gamma for alpha contrast, default = 1
%
%   Example
%   --------
%   plot_value_density_2(tsnePts, valueVec, 401, [], 0.6)

% ---------- 参数检查 ----------
if nargin < 5 || isempty(gammaAlpha);  gammaAlpha = 1;     end
if nargin < 4 || isempty(rangeVals)
    % symmetric range around 0, padded 20 %
    maxAbs = max(abs(points(:)));
    range  = round(maxAbs * 1.2);
    rangeVals = [-range range; -range range];
elseif isvector(rangeVals) && numel(rangeVals) == 2
    % 用户只给了 [-range range]，对称处理
    rangeVals = rangeVals(:)';
    rangeVals = [rangeVals; rangeVals];
elseif isequal(size(rangeVals), [1 2])
    rangeVals = [rangeVals; rangeVals];   % 同上
end

if nargin < 3 || isempty(numPoints);  numPoints = 101;  end
if isscalar(numPoints);               numPoints = [numPoints numPoints]; end
% 保证奇数，方便 fftshift/坐标对齐
numPoints = numPoints + mod(numPoints+1,2);

nx = numPoints(1);
ny = numPoints(2);
xmin = rangeVals(1,1);  xmax = rangeVals(1,2);
ymin = rangeVals(2,1);  ymax = rangeVals(2,2);

% ---------- 建立网格 ----------
xx = linspace(xmin, xmax, nx);
yy = linspace(ymin, ymax, ny);

% ---------- 统计每格 value 平均 & 计数 ----------
% Bin edges = mid-points between centers
xedges = [-inf, (xx(1:end-1)+xx(2:end))/2, inf];
yedges = [-inf, (yy(1:end-1)+yy(2:end))/2, inf];

% 找到每点所在 bin
[~,~,binX] = histcounts(points(:,1), xedges);
[~,~,binY] = histcounts(points(:,2), yedges);
valid      = binX>0 & binY>0;

flatInd = sub2ind([ny nx], binY(valid), binX(valid));

sumVal  = accumarray(flatInd, values(valid), [ny*nx 1], @sum, NaN);
count   = accumarray(flatInd, 1,           [ny*nx 1], @sum, NaN);

count(count < 10) = 0;

valAvg  = reshape(sumVal ./ count, ny, nx);    % 每格平均 value
count   = reshape(count, ny, nx);   % 每格计数 (= 密度原型)

% valAvg(valAvg)s

% filter the count < 10
% count(count < 10) = 0;

% ---------- 可选高斯平滑 ----------
% sigmaPx = 1;     % 若需要再打开
% valAvg  = imgaussfilt(valAvg, sigmaPx);
% count   = imgaussfilt(count,  sigmaPx);

% % ---------- 透明度映射 ----------
% alpha = count ./ max(count(:));        % 0–1 归一化
% alpha = alpha .^ gammaAlpha;           % γ 调节对比度
% alpha(isnan(alpha)) = 0;               % 无数据格子透明
alpha = 1;

% ---------- 绘图 ----------
fig = figure;
im  = imagesc(xx, yy, flipud(valAvg));      % 颜色 = value 平均
clim([-2, 2]);

% set(gca, 'YDir','normal', 'DataAspectRatio',[1 1 1], 'CLim',[-2 2])
% set(im,  'AlphaData', flipud(alpha))        % 透明度 = 密度
% colormap(turbo);                             % 主色图
cb1 = colorbar;                              % 数值 colorbar
cb1.Label.String = 'average(value)';

% <-- add : 建一个透明度色条（灰度）----------------------------
hold on                                    % 还在同一坐标系
% 用 2×2 的 dummy 图像驱动第二个 colorbar
% im2 = imagesc([xmin xmax], [ymin ymax], flipud(alpha(1:2,1:2)));
% set(im2, 'Visible','off', 'AlphaData', 1); % 图像本身隐藏，但存在 CData
% colormap(im2, gray);                       % 灰度映射密度
% set(gca,'CLim',[0 1])                      % α 已归一化 0-1
% cb2 = colorbar(im2,'eastoutside');         % 第二根 colorbar
% cb2.Label.String = 'point density (α)';
% 把主图放回最上层
uistack(im,'top');
% ------------------------------------------------------------
tt = compose('Color = average(value),  Channel %s', channel);
title(tt);
xlabel('x'); ylabel('y');


% 可导出带 α 通道的 PNG
save_path = compose('_pngs_storage', filesep, 'value_density_', channel, '.png');
exportgraphics(gca, save_path, 'BackgroundColor','none');

end