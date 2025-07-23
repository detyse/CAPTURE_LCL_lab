function plot_value_density_1(points, values)
% values: the value vector
% sigma: the density sigma value
% color: the colormap represent the values 

% if isempty(use_color)
%     use_color = turbo;
% end

figure

if numel(values) ~= size(points,1)
    error('values 的元素数必须与 points 行数一致');
end
values = double(values(:));   % 转成 N×1 double

scatter(points(:, 1), points(:, 2), 10, values, "filled")   % 
colormap turbo
colorbar

box on;
axis equal tight

end

