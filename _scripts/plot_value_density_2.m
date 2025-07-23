function plot_value_density_2(points, values, numPoints, rangeVals)
%PLOT_VALUE_DENSITY 
% numPoints: 采样点个数, 用于 grid 和 fft
% rangeVals: 画图范围, 超出范围的点被忽略

if isempty(rangeVals)
    datamin = min(points(:))      % not sure about the shape
    datamax = max(points(:))
    max_abs = max(abs(datamin), abs(datamax))
    pad = max_abs * 0.2
    range = round(max_abs + pad)
    rangeVals = [-range, range]
end

if isempty(numPoints)
    numPoints = 71;         % use the CAPTURE defualt
end
n = numPoints;

xx = linspace(-range, range, n);
yy = linspace(-range, range, n);
[XX, YY] = meshgrid(xx, yy);        % not used? 

[~,~,binX] = histcounts(points(:,1), [-inf xx(2:end)-diff(xx)/2 inf]);
[~,~,binY] = histcounts(points(:,2), [-inf yy(2:end)-diff(yy)/2 inf]);

valid = binX>0 & binY>0;
indFlat = sub2ind([n n], binY(valid), binX(valid));

sumVal = accumarray(indFlat, values(valid), [n*n, 1], @sum, NaN);
count = accumarray(indFlat, 1, [n*n, 1], @sum, NaN);

avgVal = reshape(sumVal ./ count, n, n);   % n×n 矩阵
avgVal(isnan(avgVal)) = NaN;                        % 没有数据的格子

% 6) 可选：用 imgaussfilt 再做一次轻微平滑
% avgVal = imgaussfilt(avgVal, 1);   % sigma=1 像素

% 7) 画图
imagesc(xx, yy, flipud(avgVal))     % 
axis xy equal tight; colormap turbo; colorbar

end 