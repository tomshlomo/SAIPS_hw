function [I_ref_clean, lambda] = tv_denoise(I_ref, I_ins, opts)
arguments
    I_ref (:,:) double
    I_ins (:,:) double
    opts.lambdas = logspace(-1, 1, 50);
    opts.plot_flag (1,1) logical = true
end

denoiser = @(x, lambda) TVL1denoise(x, lambda, 100);
L = length(opts.lambdas);
err = inf(L, 1);
for i = 1:L
    I_ref_clean_tmp = denoiser(I_ref, opts.lambdas(i));
    err(i) = median(abs(I_ref_clean_tmp - I_ins), "all");
    if all(err(i) <=  err)
        I_ref_clean = I_ref_clean_tmp;
    end
end
[~,i] = min(err);
lambda = opts.lambdas(i);

if opts.plot_flag
    figure("name", "TV denoise");
    tiledlayout(2,2);
    ax(1) = nexttile();
    imshow(I_ref, []);
    ax(2) = nexttile();
    imshow(I_ref_clean, []);
    ax(3) = nexttile();
    imshow(imfuse(I_ref_clean, I_ins));
    ax(4) = nexttile();
    loglog(opts.lambdas, err, '.-');
    xlabel("$\lambda$");
    ylabel("Error");
    linkaxes(ax(1:3), "xy");
end

end

