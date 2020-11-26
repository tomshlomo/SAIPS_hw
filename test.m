% just some graphic defaults...
set(0, 'DefaultLineLineWidth', 2);
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaultAxesFontSize',16)

files_ref = ["images/defective_examples/case1_reference_image.tif", ...
             "images/defective_examples/case2_reference_image.tif", ...
             "images/non_defective_examples/case3_reference_image.tif"];
files_ins = ["images/defective_examples/case1_inspected_image.tif", ...
             "images/defective_examples/case2_inspected_image.tif", ...
             "images/non_defective_examples/case3_inspected_image.tif"];
         
for i=1:3
    I_ref = imread(files_ref(i));
    I_ins = imread(files_ins(i));
    M = defect_detect(I_ins, I_ref, 1);
end