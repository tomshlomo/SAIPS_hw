function D2 = diff_map(I_ref, I_ins, opts)
arguments
    I_ref (:,:) double
    I_ins (:,:) double
    opts.plot_flag (1,1) logical = true
    opts.grad_attenuation_factor = 1e1;
end

D1 = I_ins - I_ref;
G_ref = imgradient(I_ref, "sobel");
sigma = median(abs(G_ref(:))) * opts.grad_attenuation_factor;
D2 = D1.*exp(-(G_ref/sigma).^2);

if opts.plot_flag
    figure("name", "diff map");
    tiledlayout("flow");
    ax(1) = nexttile();
    imshow(abs(G_ref), []);
    ax(2) = nexttile();
    imshow(abs(D2), []);
    linkaxes(ax(1:2), "xy");
    nexttile();
    histogram(abs(D2));
end
    
end

