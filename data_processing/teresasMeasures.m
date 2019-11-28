%% Load Subject data

load Subject_2_IAB.mat; A_1_r = ALPHA_plot; a3 = alpha33;
load Subject_4_IAB.mat; A_2   = ALPHA_plot;
load Subject_7_IAB.mat; A_3   = ALPHA_plot;
load Subject_8_IAB.mat; A_4   = ALPHA_plot;

load Subject_3_IAB.mat; FC_1 = WND_plot;
load Subject_5_IAB.mat; FC_2 = WND_total;
load Subject_6_IAB.mat; FC_3 = WND_plot;
load Subject_9_IAB.mat; FC_4 = WND_plot;

load Subject_3_alpha.mat; FCA_1   = ALPHA_plot;
load Subject_5_alpha.mat; FCA_2_r = ALPHA_plot;
load Subject_6_alpha.mat; FCA_3   = ALPHA_plot;
load Subject_9_alpha.mat; FCA_4   = ALPHA_plot;

load Subject_2_fc.mat; AFC_1 = WND_total;
load Subject_4_fc.mat; AFC_2 = WND_plot;
load Subject_7_fc.mat; AFC_3 = WND_plot;
load Subject_8_fc.mat; AFC_4 = WND_plot;

load Subject_2_theta.mat; AT_1_r = ALPHA_plot; t3 = alpha33;
load Subject_4_theta.mat; AT_2   = ALPHA_plot;
load Subject_7_theta.mat; AT_3   = ALPHA_plot;
load Subject_8_theta.mat; AT_4   = ALPHA_plot;

load Subject_3_theta.mat; FCT_1 = WND_plot;
load Subject_5_theta.mat; FCT_2 = WND_total;
load Subject_6_theta.mat; FCT_3 = WND_plot;
load Subject_9_theta.mat; FCT_4 = WND_plot;

load Subject_2_beta.mat; AB_1_r = ALPHA_plot; b3 = alpha33;
load Subject_4_beta.mat; AB_2   = ALPHA_plot; 
load Subject_7_beta.mat; AB_3   = ALPHA_plot;
load Subject_8_beta.mat; AB_4   = ALPHA_plot;

load Subject_3_beta.mat; FCB_1 = WND_plot;
load Subject_5_beta.mat; FCB_2 = WND_total;
load Subject_6_beta.mat; FCB_3 = WND_plot;
load Subject_9_beta.mat; FCB_4 = WND_plot;


load ALL_FC.mat;

A_1   = [ A_1_r(1,:,:);  A_1_r(2,:,:);   a3;      A_1_r(3,:,:)   ];
FCA_2 = [ alpha11;       FCA_2_r(1,:,:); alpha33; FCA_2_r(2,:,:) ];
AT_1  = [ AT_1_r(1,:,:); AT_1_r(2,:,:);  t3;      AT_1_r(3,:,:)  ];
AB_1  = [ AB_1_r(1,:,:); AB_1_r(2,:,:);  b3;      AB_1_r(3,:,:)  ];

ALPHA_total = [ A_1   A_2   A_3   A_4   ];
FC_total    = [ FC_1  FC_2  FC_3  FC_4  ];
FCA_total   = [ FCA_1 FCA_2 FCA_3 FCA_4 ];
AFC_total   = [ AFC_1 AFC_2 AFC_3 AFC_4 ];
AT_total    = [ AT_1  AT_2  AT_3  AT_4  ];
FCT_total   = [ FCT_1 FCT_2 FCT_3 FCT_4 ];
AB_total    = [ AB_1  AB_2  AB_3  AB_4  ];
FCB_total   = [ FCB_1 FCB_2 FCB_3 FCB_4 ];
FC_ov       = WND_plot;

INTRA1 = [];
INTRA2 = [];
INTRAS = [];
INTER1 = [];
INTER2 = [];
INTERS = [];

ALL_DATA(:,:,:,1) = ALPHA_total;
ALL_DATA(:,:,:,2) = AFC_total;
ALL_DATA(:,:,:,3) = AT_total;
ALL_DATA(:,:,:,4) = AB_total;
ALL_DATA(:,:,:,5) = FCA_total;
ALL_DATA(:,:,:,6) = FC_total;
ALL_DATA(:,:,:,7) = FCT_total;
ALL_DATA(:,:,:,8) = FCB_total;

for type=1:8
    INTRA_A1 = [];
    INTRA_A2 = [];
    INTRA_S  = [];
    INTER_A1 = [];
    INTER_A2 = [];
    INTER_S  = [];
    
    nSess = 4;
    nSets = 5;
    nTrls = 6;
    
    % Analyse ALPHA, or Connectivity
    
    DATA = ALL_DATA(:,:,:,type);
    
    for subject = 1:4
        ia1 = 0;
        ia2 = 0;
        is  = 0;
        r = (subject-1)*nTrls+1:subject*nTrls;
        for session=1:nSess
            set1Mean = mean(DATA(session,r,1),2);
            for set=1:nSets
                ia1 = ia1 + (mean(DATA(session,r,set),2)-set1Mean)/set1Mean;
            end
            ia2 = ia2 + (mean(DATA(session,r,5),2)-set1Mean)/set1Mean;
            %slopes
            S = squeeze(DATA(session,r,:));
            mean_S  = mean(S,1);
            slope_s = polyfit([1 2 3 4 5],mean_S,1);
            is = is + slope_s(1);
        end
        INTRA_A1 = [INTRA_A1 ia1/(nSess*(nSets-1))];
        INTRA_A2 = [INTRA_A2 ia2/nSess];
        INTRA_S  = [INTRA_S  is/nSess];
        S1 = squeeze(DATA(1,r,:));
        S2 = squeeze(DATA(2,r,:));
        S3 = squeeze(DATA(3,r,:));
        S4 = squeeze(DATA(4,r,:));
        s4 = mean(DATA(4,r,4),2) + mean(DATA(4,r,5),2);
        s1 = mean(DATA(1,r,1),2) + mean(DATA(1,r,2),2);
        INTER_A1 = [INTER_A1 (mean(S3(:))+mean(S4(:))-mean(S1(:))-mean(S2(:)))/(mean(S1(:))+mean(S2(:)))];
        INTER_A2 = [INTER_A2 (s4-s1)/s1];
        slope_S = polyfit([1 2 3 4],[mean(S1(:)) mean(S2(:)) mean(S3(:)) mean(S4(:))],1);
        INTER_S = [INTER_S slope_S(1)];
    end
    
    INTRA1 = [INTRA1; INTRA_A1];
    INTRA2 = [INTRA2; INTRA_A2];
    INTRAS = [INTRAS; INTRA_S];
    INTER1 = [INTER1; INTER_A1];
    INTER2 = [INTER2; INTER_A2];
    INTERS = [INTERS; INTER_S];
    
end

%% Statistical tests

P = zeros(8,6);
H = zeros(8,6);
for i=1:8
    [P(i,1),H(i,1)] = signrank(INTRA1(i,:));
    [P(i,2),H(i,2)] = signrank(INTRA2(i,:));
    [P(i,3),H(i,3)] = signrank(INTRAS(i,:));
    [P(i,4),H(i,4)] = signrank(INTER1(i,:));
    [P(i,5),H(i,5)] = signrank(INTER2(i,:));
    [P(i,6),H(i,6)] = signrank(INTERS(i,:));
end

% No null hypothesis rejected...

%% Boxplots

% INTRA1
minVal = min(min(INTRA1(3,:)));
maxVal = max(max(INTRA1(1,:)));
figure()
title('INTRA1')
subplot(1,2,1)
boxplot([INTRA1(1,:); INTRA1(3,:); INTRA1(4,:)]','Labels',{'Alpha','Theta','Beta'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTRA1 - Alpha group')
minVal = min(min(INTRA1(7,:)));
maxVal = max(max(INTRA1(6,:)));
subplot(1,2,2)
boxplot([INTRA1(6,:); INTRA1(7,:,:); INTRA1(8,:,:)]','Labels',{'Connectivity','FC(Theta)','FC(Beta)'})
ylim([minVal-0.1 maxVal+0.1])
title('INTRA1 - Connectivity group')

minVal = min(min(min(INTRA1(1:2,:))),min(min(INTRA1(5:6,:))));
maxVal = max(max(max(INTRA1(1:2,:))),max(max(INTRA1(5:6,:))));
figure()
title('INTRA1')
subplot(1,2,1)
boxplot([INTRA1(1,:); INTRA1(2,:)]','Labels',{'Alpha','Connectivity'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTRA1 - Alpha group')
subplot(1,2,2)
boxplot([INTRA1(5,:); INTRA1(6,:)]','Labels',{'Alpha','Connectivity'})
ylim([minVal-0.1 maxVal+0.1])
title('INTRA1 - Connectivity group')
%%
% INTRA2
minVal = min(min(INTRA2(3,:)));
maxVal = max(max(INTRA2(1,:)));
figure()
title('INTRA2')
subplot(1,2,1)
boxplot([INTRA2(1,:); INTRA2(3,:); INTRA2(4,:)]','Labels',{'Alpha','Theta','Beta'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTRA2 - Alpha group')
minVal = min(min(INTRA2(7,:)));
maxVal = max(max(INTRA2(6,:)));
subplot(1,2,2)
boxplot([INTRA2(6,:); INTRA2(7,:); INTRA2(8,:)]','Labels',{'FC(Alpha)','FC(Theta)','FC(Beta)'})
ylim([minVal-0.1 maxVal+0.1])
title('INTRA2 - Connectivity group')

minVal = min(min(min(INTRA2(1:2,:))),min(min(INTRA2(5:6,:))));
maxVal = max(max(max(INTRA2(1:2,:))),max(max(INTRA2(5:6,:))));
figure()
title('INTRA2')
subplot(1,2,1)
boxplot([INTRA2(1,:); INTRA2(2,:)]','Labels',{'Alpha','Connectivity'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTRA2 - Alpha group')
subplot(1,2,2)
boxplot([INTRA2(5,:); INTRA2(6,:,:)]','Labels',{'Alpha','Connectivity'})
ylim([minVal-0.1 maxVal+0.1])
title('INTRA2 - Connectivity group')
%%
% INTRAS
minVal = min(min(INTRAS(3,:)));
maxVal = max(max(INTRAS(1,:)));
figure()
title('INTRAS')
subplot(1,2,1)
boxplot([INTRAS(1,:); INTRAS(3,:); INTRAS(4,:)]','Labels',{'Alpha','Theta','Beta'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTRAS - Alpha group')
minVal = min(min(INTRAS(7,:)));
maxVal = max(max(INTRAS(6,:)));
subplot(1,2,2)
boxplot([INTRAS(6,:); INTRAS(7,:);INTRAS(8,:)]','Labels',{'FC(Alpha)','FC(Theta)','FC(Beta)'})
ylim([minVal-0.1 maxVal+0.1])
title('INTRAS - Connectivity group')

minVal = min(min(min(INTRAS(1:2,:))),min(min(INTRAS(5:6,:))));
maxVal = max(max(max(INTRAS(1:2,:))),max(max(INTRAS(5:6,:))));
figure()
title('INTRAS')
subplot(1,2,1)
boxplot([INTRAS(1,:); INTRAS(2,:)]','Labels',{'Alpha','Connectivity'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTRAS - Alpha group')
subplot(1,2,2)
boxplot([INTRAS(5,:); INTRAS(6,:,:)]','Labels',{'Alpha','Connectivity'})
ylim([minVal-0.1 maxVal+0.1])
title('INTRAS - Connectivity group')
%%
% INTER1
minVal = min(min(INTER1(3,:)));
maxVal = max(max(INTER1(3,:)));
figure()
title('INTER1')
subplot(1,2,1)
boxplot([INTER1(1,:); INTER1(3,:); INTER1(4,:)]','Labels',{'Alpha','Theta','Beta'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTER1 - Alpha group')
minVal = min(min(INTER1(7,:)));
maxVal = max(max(INTER1(6,:)));
subplot(1,2,2)
boxplot([INTER1(6,:); INTER1(7,:); INTER1(8,:)]','Labels',{'FC(Alpha)','FC(Theta)','FC(Beta)'})
ylim([minVal-0.1 maxVal+0.1])
title('INTER1 - Connectivity group')

minVal = min(min(min(INTER1(1:2,:))),min(min(INTER1(5:6,:))));
maxVal = max(max(max(INTER1(1:2,:))),max(max(INTER1(5:6,:))));
figure()
title('INTER1')
subplot(1,2,1)
boxplot([INTER1(1,:); INTER1(2,:)]','Labels',{'Alpha','Connectivity'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTER1 - Alpha group')
subplot(1,2,2)
boxplot([INTER1(5,:); INTER1(6,:,:)]','Labels',{'Alpha','Connectivity'})
ylim([minVal-0.1 maxVal+0.1])
title('INTER1 - Connectivity group')
%%
% INTER2
minVal = min(min(INTER2(4,:)));
maxVal = max(max(INTER2(3,:)));
figure()
title('INTER2')
subplot(1,2,1)
boxplot([INTER2(1,:); INTER2(3,:); INTER2(4,:)]','Labels',{'Alpha','Theta','Beta'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTER2 - Alpha group')
minVal = min(min(INTER2(8,:)));
maxVal = max(max(INTER2(6,:)));
subplot(1,2,2)
boxplot([INTER2(6,:); INTER2(7,:); INTER2(8,:)]','Labels',{'FC(Alpha)','FC(Theta)','FC(Beta)'})
ylim([minVal-0.1 maxVal+0.1])
title('INTER2 - Connectivity group')

minVal = min(min(min(INTER2(1:2,:))),min(min(INTER2(5:6,:))));
maxVal = max(max(max(INTER2(1:2,:))),max(max(INTER2(5:6,:))));
figure()
title('INTER2')
subplot(1,2,1)
boxplot([INTER2(1,:); INTER2(2,:)]','Labels',{'Alpha','Connectivity'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTER2 - Alpha group')
subplot(1,2,2)
boxplot([INTER2(5,:); INTER2(6,:)]','Labels',{'Alpha','Connectivity'})
ylim([minVal-0.1 maxVal+0.1])
title('INTER2 - Connectivity group')
%%
% INTERS
minVal = min(min(INTERS(3,:)));
maxVal = max(max(INTERS(3,:)));
figure()
title('INTERS')
subplot(1,2,1)
boxplot([INTERS(1,:); INTERS(3,:); INTERS(4,:)]','Labels',{'Alpha','Theta','Beta'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTERS - Alpha group')
minVal = min(min(INTERS(8,:)));
maxVal = max(max(INTERS(6,:)));
subplot(1,2,2)
boxplot([INTERS(6,:); INTERS(7,:); INTERS(8,:)]','Labels',{'FC(Alpha)','FC(Theta)','FC(Beta)'})
ylim([minVal-0.1 maxVal+0.1])
title('INTERS - Connectivity group')

minVal = min(min(min(INTERS(1:2,:))),min(min(INTERS(5:6,:))));
maxVal = max(max(max(INTERS(1:2,:))),max(max(INTERS(5:6,:))));
figure()
title('INTERS')
subplot(1,2,1)
boxplot([INTERS(1,:); INTERS(2,:)]','Labels',{'Alpha','Connectivity'}) 
ylim([minVal-0.1 maxVal+0.1])
title('INTERS - Alpha group')
subplot(1,2,2)
boxplot([INTERS(5,:); INTERS(6,:)]','Labels',{'Alpha','Connectivity'})
ylim([minVal-0.1 maxVal+0.1])
title('INTERS - Connectivity group')
%% 
