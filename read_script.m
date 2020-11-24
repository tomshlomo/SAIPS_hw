p = {[149, 344; 82, 245; 97, 82], [344 265; 105 108; 80 262]}
I1_ins = imread("images/defective_examples/case1_inspected_image.tif")
I1_ref = imread("images/defective_examples/case1_reference_image.tif");

figure; 
imshow(I1_ins); 
hold on; 
plot(p{1}(:,1), p{1}(:,2), 'x');


I2_ins = imread("images/defective_examples/case2_inspected_image.tif")
I2_ref = imread("images/defective_examples/case2_reference_image.tif");
figure; 
imshow(I2_ins); 
hold on; 
plot(p{2}(:,1), p{2}(:,2), 'x');

