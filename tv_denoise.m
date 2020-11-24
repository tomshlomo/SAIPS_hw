function [I_ref_clean, sigma_noise, lambda] = tv_denoise(I_ref, I_ins, opts)
arguments
    I_ref (:,:) double
    I_ins (:,:) double
    opts.denoiser = 1; % 1, 2 or 3
%     opts.lambdas = logspace(-2, 1, 30);
    opts.lambdas = linspace(1, 1.5, 5);
    opts.plot_flag (1,1) logical = true
end

switch opts.denoiser
    case 1
        denoiser = @(x, lambda) TVL1denoise(x, lambda, 100);
    case 2
        denoiser = @(x, lambda) SB_ATV(x, lambda);
    case 3
        denoiser = @(x, lambda) SB_ITV(x, lambda);
end

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

sigma_noise = median(abs(I_ref - I_ref_clean), "all")*1.48; % 1.48 coverts MAD to STD for normal distribution

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

