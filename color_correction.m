function [f, outliers] = color_correction(I_ref, I_ins, opts)
arguments
    I_ref
    I_ins
    opts.sigma = 3;
    opts.plot_flag = 1
end

rng(1);
% I_ref = imgaussfilt(I_ref, opts.sigma);
% I_ins = imfilter(I_ins, opts.sigma);
points = [I_ref(:), I_ins(:)];
sampleSize = 100; % number of points to sample per trial
maxDistance = 0.25^2; % max allowable distance for inliers

% fitLineFcn = @(points) polyfit(points(:,1),points(:,2),1); % fit function using polyfit
fitLineFcn = @(points) [points(:,1), ones(size(points, 1), 1)] \ points(:,2);
evalLineFcn = ...   % distance evaluation function
  @(model, points) sum((points(:, 2) - (points(:,1) * model(1) + model(2))).^ 2, 2);

[modelRANSAC, inlierIdx] = ransac(points,fitLineFcn,evalLineFcn, ...
  sampleSize,maxDistance);

outliers = ~inlierIdx;
% b = robustfit(I_ref(:), I_ins(:), "fair");
% f = @(I) I * b(1) + b(2);
f = @(I) reshape(polyval(modelRANSAC, I(:)), size(I));

if opts.plot_flag
    figure("name", "color correction");
    tiledlayout("flow");
    ax(1) = nexttile();
    scatter(I_ref(:), I_ins(:), 100, inlierIdx, '.');
    hold on;
    plot([0, 1], f([0, 1]), 'r-');
    colormap(lines(2));
end
end

