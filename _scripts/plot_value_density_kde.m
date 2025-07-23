function plot_value_density_kde(points, values, sigma, numPoints, rangeVals, gammaAlpha)
%PLOT_VALUE_DENSITY_KDE  Color = smoothed E[value|x,y], Alpha = density
%
% points     : N×2  [x y] 坐标
% values     : N×1  每点的 value
% sigma      : 高斯核 σ
% numPoints  : 标量或 [nx ny] → 输出分辨率 (自动调成奇数)
% rangeVals  : [] 或 [-r r] 或 [xmin xmax; ymin ymax]
% gammaAlpha : 透明度对比度 γ，默认 1
%
% 例:
%   plot_value_density_kde(tsnePts, valVec, 5, 501, [], 0.7)

% ---------- 参数 ----------
if nargin < 6 || isempty(gammaAlpha), gammaAlpha = 1; end
if nargin < 5 || isempty(rangeVals)
    maxAbs = max(abs(points(:)));
    pad    = 0.2 * maxAbs;
    rangeVals = [-maxAbs-pad  maxAbs+pad;  -maxAbs-pad  maxAbs+pad];
elseif isvector(rangeVals) && numel(rangeVals)==2
    rangeVals = [rangeVals; rangeVals];
end
if nargin < 4 || isempty(numPoints), numPoints = 401; end
if isscalar(numPoints),               numPoints = [numPoints numPoints]; end
numPoints = numPoints + mod(numPoints+1,2);   % → 奇数

nx = numPoints(1); ny = numPoints(2);
xmin = rangeVals(1,1); xmax = rangeVals(1,2);
ymin = rangeVals(2,1); ymax = rangeVals(2,2);

% ---------- 网格与边界 ----------
xx = linspace(xmin, xmax, nx);
yy = linspace(ymin, ymax, ny);
[XX,YY] = meshgrid(xx, yy);                      % ny × nx

% edges 必须单调递增
xedges = [-inf, (xx(1:end-1)+xx(2:end))/2,  inf];
yedges = [-inf, (yy(1:end-1)+yy(2:end))/2,  inf];

% ---------- 直方图索引 ----------
binX = discretize(points(:,1), xedges);   % 1..nx or NaN
binY = discretize(points(:,2), yedges);   % 1..ny or NaN
valid = ~isnan(binX) & ~isnan(binY);

ind   = sub2ind([ny nx], binY(valid), binX(valid));

% ---------- 分母：计数直方图 ----------
Z_den_vec = accumarray(ind, 1, [ny*nx 1], @sum, 0);
Z_den     = reshape(Z_den_vec, ny, nx);
Z_den     = Z_den ./ sum(Z_den(:));        % 归一化 (积分=1)

% ---------- 分子：加权直方图 (value 求和) ----------
Z_num_vec = accumarray(ind, values(valid), [ny*nx 1], @sum, 0);
Z_num     = reshape(Z_num_vec, ny, nx);
Z_num     = Z_num ./ sum(Z_num(:));        % 同样归一化

% ---------- 高斯核 & FFT 卷积 ----------
G    = exp(-0.5*(XX.^2 + YY.^2)/sigma^2) / (2*pi*sigma^2);
F_G  = fft2(G);

den  = real(ifft2( F_G .* fft2(Z_den) ));
num  = real(ifft2( F_G .* fft2(Z_num) ));

den  = fftshift(den);
num  = fftshift(num);

% ---------- 期望与透明度 ----------
map   = num ./ den;          % E[value | x,y]
mask  = den < 1e-10;              % 稀疏区掩码

map(mask) = 0;                    % <- changed   NaN 改 0
% （若你想让这些格子保持透明但数值=0，下面 alpha 已处理）

alpha = den ./ max(den(:));
alpha = alpha .^ gammaAlpha;
alpha(mask) = 0;                  % 保持完全透明

% ---------- 绘图 ----------
figure;
im = imagesc(xx, yy, flipud(map));        % 颜色 = 期望值
set(gca, 'YDir','normal', 'DataAspectRatio',[1 1 1])
set(im,  'AlphaData', flipud(alpha))      % 透明度 = 密度
colormap(turbo); colorbar
title(sprintf('σ = %.3g  |  Color = E[value|x,y]  | Transparency = density', sigma));

% 可导出 PNG (带 α 通道)
% exportgraphics(gca,'value_density_kde.png','BackgroundColor','none');
end