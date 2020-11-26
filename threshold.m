function B = threshold(D, outliers, opts)
arguments
    D
    outliers
    opts.p = 0.99;
    opts.plot_flag = 1;
end

th = prctile(D(~outliers), opts.p*100);
B = abs(D)>=th;

if opts.plot_flag
    figure("name", "thresholding");
    tiledlayout("flow");
    nexttile();
    imshow(abs(D), []);
    nexttile();
    imshow(double(B).*abs(D), []);
    nexttile();
    imshow(double(B), []);
end

end

