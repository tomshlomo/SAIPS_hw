function M = cluster(B, W, opts)
arguments
    B (:,:) logical
    W (:,:) double
    opts.dbscan_minpts (1,1) = 2;
    opts.dbscan_eps (1,1) = 1.5;
    opts.cluster_min_size = 10;
    opts.cluster_min_weight = 3;
    opts.plot_flag = 1;
end

t = table();
[t.x(:,1), t.x(:,2)] = find(B);
t.w = W(B);
[t.c, t.is_core] = dbscan(t.x, opts.dbscan_eps, opts.dbscan_minpts);
t = t(t.c>0, :);

num_clusters = max(t.c);
c = table();
c.size = accumarray(t.c, ones(size(t,1),1), [num_clusters, 1]);
c.total_weight = accumarray(t.c, t.w, [num_clusters, 1]);
c.avg_weight = accumarray(t.c, t.w, [num_clusters, 1], @mean);
c.med_weight = accumarray(t.c, t.w, [num_clusters, 1], @median);

c.id = (1:num_clusters)';
c = sortrows(c, "size", "descend");

disp(c(1:6,:));
I = find(c.size < opts.cluster_min_size | opts.cluster_min_weight < 3);
t(ismember(t.c, c.id(I)), :) = [];
c(I, :) = [];
[~,t.c] = max(t.c == c.id', [], 2);

M = false(size(B));
M(sub2ind(size(M), t.x(:,1), t.x(:,2))) = true;
    
if opts.plot_flag
    figure("name", "cluster");
    imshow(double(B), []);
    hold on;
    cols = parula(size(c,1));
    scatter(t.x(:,2), t.x(:,1), 100, cols(t.c, :), '.');
end

end

