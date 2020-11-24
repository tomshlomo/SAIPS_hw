function [I_ins, I_ref_shift] = align(I_ins, I_ref, plot_flag, trim)
arguments
    I_ins (:,:) double
    I_ref (:,:) double
    plot_flag = 1
    trim = 1;
end
[N_ins, M_ins] = size(I_ins);
[N_ref, M_ref] = size(I_ref);

I_ins_med = medfilt2(I_ins, [4, 4]);
I_ref_med = medfilt2(I_ref, [4, 4]);

method = 'sobel';
% [I_ins, th1] = edge(I_ins, method);
% [I_ref, th2] = edge(I_ref, method);
[Gx_ins,Gy_ins] = imgradientxy(I_ins_med, method);
[Gx_ref,Gy_ref] = imgradientxy(I_ref_med, method);

% th1
% th2

% figure;
% tiledlayout(1,2);
% nexttile()
% imshow(I_ins);
% nexttile();
% imshow(I_ref);


cx = xcorr2(Gx_ins, Gx_ref);
cy = xcorr2(Gy_ins, Gy_ref);
c = cx.^2 + cy.^2;
[~, i] = max(c(:));
[i, j] = ind2sub(size(c), i);
shift = [i, j] - size(I_ref);

I_ref_shift = imtranslate(I_ref, shift([2, 1]), "FillValues", nan);

%% plot
if plot_flag
    figure("name", "grads");
    tiledlayout(2,2);
    nexttile()
    imshow(Gx_ins, []);
    nexttile();
    imshow(Gy_ins, []);
    nexttile()
    imshow(Gx_ref, []);
    nexttile();
    imshow(Gy_ref, []);


    figure("name", "cor");
    x = -M_ref + 1 : M_ins-1;
    y = -N_ref + 1 : N_ins-1;
    
    imagesc(x, y, 10*log10(c));
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

