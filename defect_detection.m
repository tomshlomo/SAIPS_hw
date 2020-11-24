function defect_detection(I_ins, I_ref, plot_flag)

[I_ins, I_ref] = align(I_ins, I_ref, 1);
I_ref = (I_ref(:)\I_ins(:)) * I_ref;
denoiser = 1;
[I_ref_clean, sigma_noise_ref, lambda] = tv_denoise(I_ref, I_ins, "denoiser", denoiser);
[I_ins_clean, sigma_noise_ins] = tv_denoise(I_ins, I_ref_clean, "lambdas", lambda, "denoiser", denoiser);
[f, outliers] = color_correction(I_ref_clean, I_ins_clean);
D = diff_map(f(I_ref_clean), I_ins, sigma_noise_ref, sigma_noise_ref);
B = threshold(D, outliers);
% %     figure;
% %     histogram(B1(:));
[t, c] = cluster(B, abs(D));

end