function [t, c] = cluster(b, w, minpts, eps, only_core)
arguments
    b (:,:) logical
    w (:,:) double
    minpts (1,1) = 2;
    eps = 1.5;
    only_core = 0
end
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
t = table();
[t.x(:,1), t.x(:,2)] = find(b);
t.w = w(b);
[t.c, t.is_core] = dbscan(t.x, eps, minpts);
t = t(t.c>0, :);
if only_core
    t = t(t.is_core, :);
end
num_clusters = max(t.c);
c = table();
c.size = accumarray(t.c, ones(size(t,1),1), [num_clusters, 1]);
c.weight = accumarray(t.c, t.w, [num_clusters, 1]);
c.cores = accumarray(t.c, double(t.is_core), [num_clusters, 1]);
c.id = (1:num_clusters)';
c = sortrows(c, "size", "descend");
I = find(c.size < 15 | c.weight < 3);
t(ismember(t.c, c.id(I)), :) = [];
c(I, :) = [];
% c.new_id = (1:num_clusters)';
[~,t.c] = max(t.c == c.id', [], 2);
% for i=1:num_clusters
%     t.c2(t.c==c
% end
c.id = [];
disp(c);

figure;
imshow(double(b), []);
hold on;
cols = parula(size(c,1));
scatter(t.x(:,2), t.x(:,1), 100, cols(t.c, :), '.');
% imshow(imbinarize(abs(B1), "adaptive", "Sensitivity", 0.01), []);

end

