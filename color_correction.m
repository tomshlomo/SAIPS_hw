function [f, outliers] = color_correction(I_ref, I_ins, opts)
arguments
    I_ref
    I_ins
    opts.plot_flag = 1
    opts.subset_size = 100;
    opts.max_dist = 0.25;
end

rng(1); % for reproducibility
points = [I_ref(:), I_ins(:)];
fit_func = @(points) [points(:,1), ones(size(points, 1), 1)] \ points(:,2);
err_func =  @(model, points) sum((points(:, 2) - (points(:,1) * model(1) + model(2))).^ 2, 2);

[modelRANSAC, inliers] = ransac(points,fit_func,err_func, opts.subset_size, opts.max_dist^2);

outliers = ~inliers;
f = @(I) reshape(polyval(modelRANSAC, I(:)), size(I));

if opts.plot_flag
    figure("name", "color correction");
    tiledlayout("flow");
    nexttile();
    scatter(I_ref(:), I_ins(:), 100, inliers, '.');
    hold on;
    plot([0, 1], f([0, 1]), 'r-');
    colormap(lines(2));
end

end

