close all;
for i=1:2
    I_ins = double(imread(sprintf("images/defective_examples/case%d_inspected_image.tif", i)));
    I_ref = double(imread(sprintf("images/defective_examples/case%d_reference_image.tif", i)));
    I_ref = I_ref/max(I_ref(:));
    figure;
    tiledlayout(1,2);
    nexttile();
    imshow(I_ref);

    outim=TVL1denoise(I_ref, 1.0, 100);
    nexttile();
    imshow(outim, []);
    
    I_ins = I_ins/max(I_ins(:));
    figure;
    tiledlayout(1,2);
    nexttile();
    imshow(I_ins);

    outim=TVL1denoise(I_ins, 1.0, 100);
    nexttile();
    imshow(outim, []);
end