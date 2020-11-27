function [I_ins, I_ref_shift] = align(I_ins, I_ref, plot_flag, trim)
arguments
    I_ins (:,:) double
    I_ref (:,:) double
    plot_flag = 1
    trim = 1;
end
[N_ins, M_ins] = size(I_ins);
[N_ref, M_ref] = size(I_ref);

%% median filter denoiseing
I_ins_med = medfilt2(I_ins, [4, 4]);
I_ref_med = medfilt2(I_ref, [4, 4]);

%% gradient + xcorr in freq domain
N_corr = 2^ceil(log2(N_ins + N_ref - 1)); % determine zero padding to avoid cyclic convolution
M_corr = 2^ceil(log2(M_ins + M_ref - 1));
C = fft2(I_ins_med, N_corr, M_corr) .* conj(fft2(I_ref_med, N_corr, M_corr)); % xcorr in the frequency domain, without gradients
H = abs(fft2(fspecial('sobel'), N_corr, M_corr)).^2; % sobel kernel in the frequency domain
cx = ifft2( C .* H); % grad in x, return to space
cy = ifft2( C .* H'); % grad in y, return to space
c = cx.^2 + cy.^2;
[~, i] = max(c(:));
[i, j] = ind2sub(size(c), i);
if i > N_corr/2
    i = i - N_corr;
end
if j > M_corr/2
    j = j - M_corr;
end

I_ref_shift = imtranslate(I_ref, [j-1, i-1], "FillValues", nan);

%% plot
if plot_flag
    figure("name", "cor");
    x = -M_corr/2 : M_corr/2-1;
    y = -N_corr/2 : N_corr/2-1;
    
    surf(x, y, 10*log10(fftshift(fftshift(c, 1), 2)));
    view(0, 90);
    shading flat;
    colorbar;
    
    figure("name", "align fuse");
    tiledlayout(1,2);
    nexttile();
    imshow(imfuse(I_ref, I_ins));
    nexttile();
    imshow(imfuse(I_ref_shift, I_ins));
    
end

%% trim
if trim
    [r, c] = find(~isnan(I_ref_shift));
    r = min(r) : max(r);
    c = min(c) : max(c);
    I_ref_shift = I_ref_shift(r, c);
    I_ins = I_ins(r, c);
end

end