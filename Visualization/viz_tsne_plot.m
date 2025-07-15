function viz_tsne_plot(analysisstruct)
%VIZ_TSNE_PLOT Summary of this function goes here
%Detailed explanation goes herez
zValue = analysisstruct.zValues;

the_size = size(zValue);
middle = round(the_size / 2);

former = zValue(1:middle, :);
later = zValue(middle:end, :);

figure
scatter(former(:, 1), former(:, 2), "yellow")
hold on;
scatter(later(:, 1), later(:, 2), "green")
end
