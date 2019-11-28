%% compute alpha from calibration

%eeglab

cd /home/cberhanu/Participants
clear
subject = 3;
ALPHA_cal=[];
for session=1%:3:4
    
    EEG = pop_loadset(strcat(num2str(subject),'_',num2str(session),'.gdf_proc.set'));
    
    % divide into trials
    
    data = [];
    spect = [];
    freqs = [];
    
    for trial=1:4
        tmp = EEG;
        tmp.data = tmp.data(:,:,trial);
        data = [data tmp];
        [s, f] = pop_spectopo(tmp,1,[0 60000],'EEG','percent',100,'freqrange',[4 30]);
        spect = [spect s];
    end
  
    % IAB
    iaf = 13.2762;
    htf = 30;
    
    [iaf_x, index_l] = min(abs(f - iaf));
    [htf_x, index_h] = min(abs(f - htf));
    [lnorm_x, index_nl] = min(abs(f - 4));
    [hnorm_x, index_nh] = min(abs(f - 30));
    
    spect = reshape(spect, [32, 513, 4]);
    av_alpha = squeeze(mean(spect(24,index_l:index_h,:),2));
    norm = squeeze(mean(spect(24,index_nl:index_nh,:),2));
    ALPHA_cal = [ALPHA_cal; (av_alpha./norm)'];
    
end


%% compute alpha for each trial of each session

clear
%eeglab

cd /home/cberhanu/ica
clear
subject = 7;
ALPHA_plot=[];
ALL_ALPHA=[];
ALL_ALL=[];
for session=1:4
    
    EEG = pop_loadset(strcat(num2str(subject),'_',num2str(session),'_pruned.set_ica.set'));
    
    % divide into trials
    
    data = [];
    spect = [];
    freqs = [];
    
    if EEG.trials >= 30
        start = 1;
    else
        start = 0;
    end
    
    for trial=1:30
        tmp = EEG;
        tmp.data = tmp.data(:,:,trial + start);
        data = [data tmp];
        [s, f] = pop_spectopo(tmp,1,[0 60000],'EEG','percent',100,'freqrange',[4 30]);
        spect = [spect s];
    end
    
    % IAB
    %iaf = 8.5966;
    %htf = 13.0141;
    iaf = 4;
    htf = 7;
    
    [iaf_x, index_l] = min(abs(f - iaf));
    [htf_x, index_h] = min(abs(f - htf));
    [lnorm_x, index_nl] = min(abs(f - 4));
    [hnorm_x, index_nh] = min(abs(f - 30));
    
    spect = reshape(spect, [32, 513, 30]);
    av_alpha = squeeze(mean(spect(24,index_l:index_h,:),2));
    all_alpha = squeeze(mean(spect(:,index_l:index_h,:),2));
    all_norm  = squeeze(mean(spect(:,index_nl:index_nh,:),2));
    norm = squeeze(mean(spect(24,index_nl:index_nh,:),2));
    ALPHA_plot = [ALPHA_plot; (av_alpha./norm)'];
    ALL_ALPHA  = [ALL_ALPHA ; (all_alpha./all_norm)];
    ALL_ALL = [ALL_ALL; spect];
    
end

%% all channels

% ALPHA
iaf = 8.5966;
htf = 13.0141;
[iaf_x, index_l] = min(abs(f - iaf));
[htf_x, index_h] = min(abs(f - htf));
all_alpha = squeeze(mean(ALL_ALL(:,index_l:index_h,:),2));
all_norm  = squeeze(mean(ALL_ALL(:,index_nl:index_nh,:),2));
ALL_ALPHA = all_alpha ./ all_norm;
ALPHA_CHANNELS = [];
for i=1:32
    alpha_i = reshape(ALL_ALPHA(i:32:end),[4,6,5]);
    alpha_i = squeeze(mean(alpha_i,2));
    ALPHA_CHANNELS = [ALPHA_CHANNELS; alpha_i(1,:)];
end

% THETA
iaf = 4;
htf = 7;
[iaf_x, index_l] = min(abs(f - iaf));
[htf_x, index_h] = min(abs(f - htf));
all_theta = squeeze(mean(ALL_ALL(:,index_l:index_h,:),2));
ALL_THETA = all_theta ./ all_norm;
THETA_CHANNELS = [];
for i=1:32
    theta_i = reshape(ALL_THETA(i:32:end),[4,6,5]);
    theta_i = squeeze(mean(theta_i,2));
    THETA_CHANNELS = [THETA_CHANNELS; theta_i(1,:)];
end

% BETA
iaf = htf;
htf = 30;
[iaf_x, index_l] = min(abs(f - iaf));
[htf_x, index_h] = min(abs(f - htf));
all_beta = squeeze(mean(ALL_ALL(:,index_l:index_h,:),2));
ALL_BETA = all_beta ./ all_norm;
BETA_CHANNELS = [];
for i=1:32
    beta_i = reshape(ALL_BETA(i:32:end),[4,6,5]);
    beta_i = squeeze(mean(beta_i,2));
    BETA_CHANNELS = [BETA_CHANNELS; beta_i(1,:)];
end



%% boxplots

ALPHA_plot = reshape(ALPHA_plot, [4,6,5]);
means = squeeze(mean(ALPHA_plot,2));


minVal = min(min(min(ALPHA_plot)));
maxVal = max(max(max(ALPHA_plot)));

%Boxplots
figure;
for session=1:4
    subplot(2,2,session)
    boxplot(squeeze(ALPHA_plot(session,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
    hold on
    plot([1 2 3 4 5],means(session,:),'*')
    legend('mean')
    ylim([minVal maxVal])
    hold on
    title(strcat('Session',num2str(session)));
end

%% if alpha for all subjects is available join all data together

load Subject_2_IAB.mat; A_1_raw = ALPHA_plot;
load Subject_4_IAB.mat; A_2 = ALPHA_plot;
load Subject_7_IAB.mat; A_3 = ALPHA_plot;
load Subject_8_IAB.mat; A_4 = ALPHA_plot;

%ALPHA_total = zeros(4,24,5);

%% make median to fill missing values or...
s3_1 = [A_2(3,:,1) A_3(3,:,1) A_4(3,:,1)];
s3_2 = [A_2(3,:,2) A_3(3,:,2) A_4(3,:,2)];
A_1_3(1,:,1) = ones(1,6)*median(s3_1(:));
A_1_3(1,:,2) = ones(1,6)*median(s3_2(:));
A_1_3(1,:,3) = alpha33(1,:,3);
A_1_3(1,:,4) = alpha33(1,:,4);
A_1_3(1,:,5) = alpha33(1,:,5);

A_1 = [A_1_raw(1,:,:); A_1_raw(2,:,:); alpha33; A_1_raw(3,:,:)];
ALPHA_total = [A_1 A_2 A_3 A_4];
%%
% boxplots and slopes one subject at a time

for subject=1:4
    r = (subject-1)*6+1:subject*6;
    means = squeeze(mean(ALPHA_total(:,r,:),2));
    minVal = min(min(min(ALPHA_total(:,r,:))));
    maxVal = max(max(max(ALPHA_total(:,r,:))));
    figure;
    for session=1:4
        subplot(2,2,session)
        boxplot(squeeze(ALPHA_total(session,r,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        hold on
        plot([1 2 3 4 5],means(session,:),'*')
        legend('mean')
        ylim([minVal maxVal])
        hold on
        title(strcat('Session',num2str(session)));
    end
end
%%
for subject=1:4
    r = (subject-1)*6+1:subject*6;
    means = squeeze(mean(ALPHA_total(:,r,:),2));
    minVal = min(min(min(ALPHA_total(:,r,:))));
    maxVal = max(max(max(ALPHA_total(:,r,:))));
    slope_S = [polyfit([1 2 3 4 5],means(1,:),1); polyfit([1 2 3 4 5],means(2,:),1); polyfit([1 2 3 4 5],means(3,:),1); polyfit([1 2 3 4 5],means(4,:),1)];
    figure;
    for session=1:4
        
        subplot(2,2,session)
        x = 1:0.1:5;
        y = slope_S(session,2)+slope_S(session,1)*x;
        plot(x,y)
        title(strcat('Session',num2str(session)))
        theString1 = sprintf('y = %.3f x + %.3f',slope_S(session,1), slope_S(session,2));
        text(mean(x),min(means(session,:))+0.01, theString1, 'FontSize', 7.5);
        hold on
        scatter([1 2 3 4 5],means(session,:))
        ylim([minVal-0.1 maxVal+0.1])
    end
end


%% use only values we have

ALPHA_S1 = squeeze(ALPHA_total(1,:,:));
ALPHA_S2 = squeeze(ALPHA_total(2,:,:));
ALPHA_S3 = squeeze(ALPHA_total(3,:,:));
ALPHA_S4 = squeeze(ALPHA_total(4,:,:));

ALPHA_S1 = ALPHA_S1(:);
ALPHA_S2 = ALPHA_S2(:);
ALPHA_S3 = ALPHA_S3(:);
ALPHA_S4 = ALPHA_S4(:);
sets = [ones(24,1);2*ones(24,1);3*ones(24,1);4*ones(24,1);5*ones(24,1)];
% delete extra values in S3 - Subject2, sets 1 and 2
ALPHA_S3(1:6) = [];
ALPHA_S3(31:35) = [];
sets_3 = sets;
sets_3(1:6) = [];
sets_3(31:35) = [];
ALPHA_S = [];
ALPHA_S(1).sessions = ALPHA_S1;
ALPHA_S(2).sessions = ALPHA_S2;
ALPHA_S(3).sessions = ALPHA_S3;
ALPHA_S(4).sessions = ALPHA_S4;
ALPHA_S(1).sets     = sets;
ALPHA_S(2).sets     = sets;
ALPHA_S(3).sets     = sets_3;
ALPHA_S(4).sets     = sets;

% boxplots
means = squeeze(mean(ALPHA_total,2));
minVal = min(min(min(ALPHA_total)));
maxVal = max(max(max(ALPHA_total)));
figure;
for session=1:4
    subplot(2,2,session)
    boxplot(ALPHA_S(session).sessions,ALPHA_S(session).sets, 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
    hold on
    plot([1 2 3 4 5],means(session,:),'*')
    legend('mean')
    ylim([minVal maxVal])
    hold on
    title(strcat('Session',num2str(session)));
end

%% boxplots all-in-one

minVal = min(min(min(ALPHA_total)));
maxVal = max(max(max(ALPHA_total)));
means = squeeze(mean(ALPHA_total,2));
figure;
boxplot([ squeeze(ALPHA_total(1,:,:)) squeeze(ALPHA_total(2,:,:)) squeeze(ALPHA_total(3,:,:)) squeeze(ALPHA_total(4,:,:)) ])
hold on
plot(1:20,[means(1,:) means(2,:) means(3,:) means(4,:) ],'*')
legend('mean')
ylim([minVal maxVal])
hold on

%% slopes

mean_S = [mean(squeeze(ALPHA_total(1,:,:))); mean(squeeze(ALPHA_total(2,:,:))); mean(squeeze(ALPHA_total(3,:,:))); mean(squeeze(ALPHA_total(4,:,:)))];

slope_S = [polyfit([1 2 3 4 5],mean_S(1,:),1); polyfit([1 2 3 4 5],mean_S(2,:),1); polyfit([1 2 3 4 5],mean_S(3,:),1); polyfit([1 2 3 4 5],mean_S(4,:),1)];

figure
for session=1:4
    
    subplot(2,2,session)
    x = 1:0.1:5;
    y = slope_S(session,2)+slope_S(session,1)*x;
    plot(x,y)
    title(strcat('Session',num2str(session)))
    theString1 = sprintf('y = %.3f x + %.3f',slope_S(session,1), slope_S(session,2));
    text(mean(x),min(mean_S(session,:))+0.01, theString1, 'FontSize', 7.5);
    hold on
    scatter([1 2 3 4 5],mean_S(session,:))
    ylim([min(min(means))-0.1 max(max(means))+0.1])
end

