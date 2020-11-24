p = {[149, 344; 82, 245; 97, 82], [344 265; 105 108; 80 262]}

for i=1:2
    I_ins = double(imread(sprintf("images/defective_examples/case%d_inspected_image.tif", i)));
    I_ins = I_ins/max(I_ins(:));
    I_ref = double(imread(sprintf("images/defective_examples/case%d_reference_image.tif", i)));
    I_ref = I_ref/max(I_ref(:));
    
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
%     nexttile();
% %     hold(ax(2));
%     cols = parula(size(c,1));
%     scatter(ax(2), t.x(:,2), t.x(:,1), 100, cols(t.c, :), '.');
%     imshow(imbinarize(abs(B1), "adaptive", "Sensitivity", 0.01), []);
%     
%     B2 = diffuse(B1, 1000, 0);
%     nexttile();
%     imshow(B2, []);
%     figure;
%     histogram(I_ref(:));
    
%     figure;
%     scatter(I_ins(:), I_ref(:), 100, '.');
%     figure;
%     imshow(abs(I_ins - I_ref), []);
    
%     J_ref = diffuse(I_ref, 100);
% %     J_ins = diffuse(I_ins);
%     sigma = median(abs(I_ref - J_ref), "all");
% %     figure;
% %     imshow(abs(I_ins - I_ref), []);
% %     figure;
% %     imshow(abs(J_ins - J_ref), []);
% %     
%     figure;
%     imshow(abs(I_ins - I_ref)>10*sigma, []);
%     
%     nhoodSize = 3;
%     B = imguidedfilter(d, I_ref, 'NeighborhoodSize',nhoodSize, 'DegreeOfSmoothing', sigma^2 );
%     figure, imshow(B, []), title('Filtered Image')
%     imfilter(
end