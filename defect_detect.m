function M = defect_detect(I_ins, I_ref, plot_flag)
arguments
    I_ins (:,:) double
    I_ref (:,:) double
    plot_flag (1,1) logical = true
end

% normalization
I_ins = I_ins/max(I_ins(:));
I_ref = I_ref/max(I_ref(:));

% alignement
[I_ins_aligned, I_ref_aligned] = align(I_ins, I_ref, 1);

% simple least-squares color matching
I_ref_aligned = (I_ref_aligned(:)\I_ins_aligned(:)) * I_ref_aligned;

%  denoising
[I_ref_clean, lambda] = tv_denoise(I_ref_aligned, I_ins_aligned);
lambda
[I_ins_clean] = tv_denoise(I_ins_aligned, I_ref_clean, "lambdas", lambda);

% color matching
[f, outliers] = color_correction(I_ref_clean, I_ins_clean);
D = diff_map(f(I_ref_clean), I_ins_aligned);
B = threshold(D, outliers);
% %     figure;
% %     histogram(B1(:));
M = cluster(B, abs(D));

if plot_flag
    figure("name", "results");
    tiledlayout(3,2);
    
    nexttile();
    imshow(imfuse(I_ins, I_ref));
    title("Original images, fused");
    
    nexttile();
    imshow(imfuse(I_ins_aligned, I_ref_aligned));
    title("Aligned images, fused");
    
    nexttile();
    imshow(I_ref_clean, []);
    title("Denoised reference image");
    
    nexttile();
    imshow(I_ins_clean, []);
    title("Denoised inspection image");
    
    nexttile();
    imshow(abs(D), []);
    title("$D_2$");
    
    nexttile();
    imshow(M, []);
    title("Final defect detections");
end
end