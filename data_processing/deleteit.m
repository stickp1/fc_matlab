%% if alpha for all subjects is available join all data together

load Subject_2.mat; A_1_raw = ALPHA_plot;
load Subject_4.mat; A_2 = ALPHA_plot;
load Subject_7.mat; A_3 = ALPHA_plot;
load Subject_8.mat; A_4 = ALPHA_plot;

ALPHA_total = zeros(4,24,5);
s3_1 = [A_2(3,:,1) A_3(3,:,1) A_4(3,:,1)];
s3_2 = [A_2(3,:,2) A_3(3,:,2) A_4(3,:,2)];
A_1_3(1,:,1) = ones(1,6)*median(s3_1(:)); 
A_1_3(1,:,2) = ones(1,6)*median(s3_2(:)); 
A_1_3(1,:,3) = alpha33(1,:,3); 
A_1_3(1,:,4) = alpha33(1,:,4);
A_1_3(1,:,5) = alpha33(1,:,5);

A_1 = [A_1_raw(1,:,:); A_1_raw(2,:,:); A_1_3; A_1_raw(3,:,:)]