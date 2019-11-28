function P_SW = briefstats()

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

load ALL_FC.mat;

A_1 = [A_1_r(1,:,:); A_1_r(2,:,:); a3; A_1_r(3,:,:)];
FCA_2 = [alpha11; FCA_2_r(1,:,:); alpha33; FCA_2_r(2,:,:)];

ALPHA_total = [ A_1   A_2   A_3   A_4   ];
FC_total    = [ FC_1  FC_2  FC_3  FC_4  ];
FCA_total   = [ FCA_1 FCA_2 FCA_3 FCA_4 ];
FC_ov       = WND_plot;

%% Compute several tests for each subject
H_KS = [];
P_KS = [];
H_T = [];
P_T = [];
H_W = [];
P_W = [];
H_SW = [];
P_SW = [];
H_T2 = [];
P_T2 = [];
H_SWS = [];
P_SWS = [];

for subject=1:4
    
    H_ks = zeros(4,5,4);
    P_ks = zeros(4,5,4);
    r = (subject-1)*6+1:subject*6;
    
    for session=1:4
        for set=1:5
            [H_ks(session,set,1),P_ks(session,set,1)] = kstest(ALPHA_total(session,r,set));
            [H_ks(session,set,2),P_ks(session,set,2)] = kstest(FC_total(session,r,set));
            [H_ks(session,set,3),P_ks(session,set,3)] = kstest(FCA_total(session,r,set));
            [H_ks(session,set,4),P_ks(session,set,4)] = kstest(FC_ov(session,r,set));
        end
    end
    
    isAllNotNormal = all(all(all(H_ks))) && all(all(all(P_ks<=0.05))); % all is indeed normal
    
    H_t = zeros(4,4,4);
    P_t = zeros(4,4,4);
    
    for session=1:4
        for set=2:5
            [H_t(session,set,1),P_t(session,set,1)] = ttest(ALPHA_total(session,r,1),ALPHA_total(session,r,set));
            [H_t(session,set,2),P_t(session,set,2)] = ttest(FC_total(session,r,1),FC_total(session,r,set));
            [H_t(session,set,3),P_t(session,set,3)] = ttest(FCA_total(session,r,1),FCA_total(session,r,set));
            [H_t(session,set,4),P_t(session,set,4)] = ttest(FC_ov(session,r,1),FC_ov(session,r,set));
        end
    end
    
    H_w = zeros(4,4,4);
    P_w = zeros(4,4,4);
    
    for session=1:4
        for set=2:5
            [P_w(session,set,1),H_w(session,set,1)] = ranksum(ALPHA_total(session,r,1),ALPHA_total(session,r,set));
            [P_w(session,set,2),H_w(session,set,2)] = ranksum(FC_total(session,r,1),FC_total(session,r,set));
            [P_w(session,set,3),H_w(session,set,3)] = ranksum(FCA_total(session,r,1),FCA_total(session,r,set));
            [P_w(session,set,4),H_w(session,set,4)] = ranksum(FC_ov(session,r,1),FC_ov(session,r,set));
        end
    end
    
    H_sw = zeros(4,4,4);
    P_sw = zeros(4,4,4);
    
    for session=1:4
        for set=2:5
            [P_sw(session,set,1),H_sw(session,set,1)] = signrank(ALPHA_total(session,r,1),ALPHA_total(session,r,set));
            [P_sw(session,set,2),H_sw(session,set,2)] = signrank(FC_total(session,r,1),FC_total(session,r,set));
            [P_sw(session,set,3),H_sw(session,set,3)] = signrank(FCA_total(session,r,1),FCA_total(session,r,set));
            [P_sw(session,set,4),H_sw(session,set,4)] = signrank(FC_ov(session,r,1),FC_ov(session,r,set));
        end
    end
    
    H_sws = zeros(4,4,2);
    P_sws = zeros(4,4,2);
    
    for session = 1:4
        alphaSess_1 = squeeze(ALPHA_total(session,r,:));
        fcSess_1    = squeeze(FC_total(session,r,:));
        for sess = 1:4
           alphaSess_2 = squeeze(ALPHA_total(sess,r,:));
           fcSess_2    = squeeze(FC_total(sess,r,:));
           [P_sws(session,sess,1),H_sws(session,sess,1)] = signrank(alphaSess_1(:),alphaSess_2(:));
           [P_sws(session,sess,2),H_sws(session,sess,2)] = signrank(fcSess_1(:),fcSess_2(:));
        end
    end
    
    H_t2 = zeros(3,6,4);
    P_t2 = zeros(3,6,4);
    
    for session=2:4
        for set=1:5
            [P_t2(session,set,1),H_t2(session,set,1)] = ranksum(ALPHA_total(1,r,set),ALPHA_total(session,r,set));
            [P_t2(session,set,2),H_t2(session,set,2)] = ranksum(FC_total(1,r,set),FC_total(session,r,set));
            [P_t2(session,set,3),H_t2(session,set,3)] = ranksum(FCA_total(1,r,set),FCA_total(session,r,set));
            [P_t2(session,set,4),H_t2(session,set,4)] = ranksum(FC_ov(1,r,set),FC_ov(session,r,set));
        end
        [P_t2(session,6,1),H_t2(session,6,1)] = ranksum(ALPHA_total(1,r,1),ALPHA_total(session,r,end));
        [P_t2(session,6,2),H_t2(session,6,2)] = ranksum(FC_total(1,r,1),FC_total(session,r,end));
        [P_t2(session,6,3),H_t2(session,6,3)] = ranksum(FCA_total(1,r,1),FCA_total(session,r,end));
        [P_t2(session,6,4),H_t2(session,6,4)] = ranksum(FC_ov(1,r,1),FC_ov(session,r,end));
        
        
    end
    H_KS = [H_KS; H_ks];
    P_KS = [P_KS; P_ks];
    H_T  = [H_T;  H_t ];
    P_T  = [P_T;  P_t ];
    H_W  = [H_W;  H_w ];
    P_W  = [P_W;  P_w ];
    H_SW = [H_SW; H_sw];
    P_SW = [P_SW; P_sw];
    H_SWS= [H_SWS; H_sws];
    P_SWS= [P_SWS; P_sws];
    H_T2 = [H_T2; H_t2];
    P_T2 = [P_T2; P_t2];
    
end
%{
%% Check correlation between Fieldtrip and ov data

s=1;
session1_subject1_ft = FC_total(s,1:6,:);
session1_subject1_ov = [mean(FC_ov(s,1:61,:),2) mean(FC_ov(s,62:122,:),2) mean(FC_ov(s,123:183,:),2) mean(FC_ov(s,184:244,:),2) mean(FC_ov(s,245:305,:),2) mean(FC_ov(s,306:366,:),2)];

[c,p] = corr(session1_subject1_ft(:),session1_subject1_ov(:))


% there is correlation only between first session of ft and ov!

%%
%One-sample Kolmogorov-Smirnov test for normality
[h,p] = kstest(ALPHA_total(1,:,1))
[h,p] = kstest(FC_total(1,:,1))


% since thety are normal, we use ttest
[h,p, ci, stats] = ttest(ALPHA_total(1,:,1), ALPHA_total(1,:,5))
% t(df) = tstat, p
% e.g., t(23) = -3.5484, p < 0.05
% if p > 0.05, then report the p value, e.g. p = 0.15
[h,p, ci, stats] = ttest(FC_total(1,:,1), FC_total(1,:,5))


%non-parametric test instead of ttest
%[p,h,stats] = ranksum(FC_total(1,:,1), FC_total(1,:,5))
%}