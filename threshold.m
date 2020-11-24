function B = threshold(D, outliers, opts)
arguments
    D
    outliers
    opts.p = 0.985;
end
% t = table();
% t.th = linspace(0, 1, 1000)';
th = prctile(D(~outliers), opts.p*100);
B = abs(D)>=th;

figure;
tiledlayout("flow");
nexttile();
imshow(abs(D), []);
nexttile();
imshow(double(B).*abs(D), []);
nexttile();
imshow(double(B), []);
% for i=1:size(t,1)
%     t.outliers_above(i) = nnz(D(outliers) >= t.th(i));
%     t.signal_below(i) = nnz(D(~outliers) < t.th(i));
% end
% t.outliers_above = t.outliers_above / nnz(outliers);
% t.signal_below = t.signal_below / nnz(~outliers);
% figure;
% tiledlayout("flow");
% nexttile()
% plot(t.outliers_above, t.signal_below, '.-');
% xlabel("outliers above (want high)");
% ylabel("signal below (want high");
% 
% nexttile();
% plot(t.th, [t.outliers_above, t.signal_below], '.-');
% figure;
% histogram(D(outliers(:)), "Normalization", "probability");
% hold on;
% histogram(D(~outliers(:)), "Normalization", "probability");
% 
% figure;
% cdfplot(abs(D(outliers(:))));
% hold on;
% cdfplot(abs(D(~outliers(:))));

end

