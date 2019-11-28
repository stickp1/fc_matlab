function [MULT_A_1,MULT_FC_1] = anova1_2()

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

load Subject_2_wav.mat; Aw_1_r = ALPHA_plot; aw3 = alpha3;
load Subject_4_wav.mat; Aw_2 = ALPHA_plot;
load Subject_7_wav.mat; Aw_3 = ALPHA_plot;
load Subject_8_wav.mat; Aw_4 = ALPHA_plot;

load ALL_FC.mat;  

A_1 = [A_1_r(1,:,:); A_1_r(2,:,:); a3; A_1_r(3,:,:)];
FCA_2 = [alpha11; FCA_2_r(1,:,:); alpha33; FCA_2_r(2,:,:)];
Aw_1 = [Aw_1_r(1,:,:); Aw_1_r(2,:,:); aw3; Aw_1_r(3,:,:)];

ALPHA_total  = [ A_1   A_2   A_3   A_4   ];
FC_total     = [ FC_1  FC_2  FC_3  FC_4  ];
FCA_total    = [ FCA_1 FCA_2 FCA_3 FCA_4 ];
ALPHAw_total = [ Aw_1  Aw_2  Aw_3  Aw_4  ];
FC_ov        = WND_plot;
%ALPHA_total = ALPHAw_total;
nTrials = 6;
%FC_total = FC_ov;
%% ANOVA1
%% ALPHA
MULT_A_1 = zeros(10,6,4,4);
TABLE_A_1 = [];
for subject=1:4
    for session=1:4
        [~,table,stats] = anova1(squeeze(ALPHA_total(session,(subject-1)*nTrials+1:subject*nTrials,:)),[],'off');
        TABLE_A_1 = [TABLE_A_1; table];
        MULT_A_1(:,:,subject,session) = multcompare(stats);
    end
end 

%%
save('anova1_A.mat','TABLE_A_1','MULT_A_1')

%% FC
MULT_FC_1 = zeros(10,6,4,4);
TABLE_FC_1 = [];
for subject=1:4
    for session=1:4
        [~,table,stats] = anova1(squeeze(FC_total(session,(subject-1)*6+1:subject*6,:)),[],'off');
        TABLE_FC_1 = [TABLE_FC_1; table];
        MULT_FC_1(:,:,subject,session) = multcompare(stats);
    end
end

%%
save('anova1_FC.mat','TABLE_FC_1','MULT_FC_1')

%{
%% ANOVA2
%% ALPHA
MULT_A_2 = zeros(10,6,4);
TABLE_A_2 = [];
for subject=1:4
    ALPHA_plot = ALPHA_total(:,(subject-1)*nTrials+1:subject*nTrials,:);
    ALPHA_plot = [squeeze(ALPHA_plot(1,:,:)); squeeze(ALPHA_plot(2,:,:)); squeeze(ALPHA_plot(3,:,:)); squeeze(ALPHA_plot(4,:,:))];
    [~,table,stats] = anova2(ALPHA_plot,6);
    TABLE_A_2 = [TABLE_A_2; table];
    MULT_A_2(:,:,subject) = multcompare(stats);
end

%%
save('anova2_A.mat','TABLE_A_2','MULT_A_2')

%% FC

MULT_FC_2 = zeros(10,6,4);
TABLE_FC_2 = [];
for subject=1:4
    FC_plot = FC_total(:,(subject-1)*6+1:subject*6,:);
    FC_plot = [squeeze(FC_plot(1,:,:)); squeeze(FC_plot(2,:,:)); squeeze(FC_plot(3,:,:)); squeeze(FC_plot(4,:,:))];
    [~,table,stats] = anova2(FC_plot,6);
    TABLE_FC_2 = [TABLE_FC_2; table];
    MULT_FC_2(:,:,subject) = multcompare(stats);
end

%%
save('anova2_FC.mat','TABLE_FC_2','MULT_FC_2')
%}