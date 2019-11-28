%% Baseline 1-pre and 4-post

clear
%eeglab

WND = [];
subject = 3;

for session=1:3:4
    EEG = pop_loadset(strcat(num2str(subject),'_',num2str(session),'.gdf_proc.set'));
    data_full = eeglab2fieldtrip(EEG, 'preprocessing');
    
    data = [];
    
    for tr=1:4
        
        trial = data_full.trial{1,tr};
        time  = data_full.time {1,tr};
        tmp = data_full;
        tmp.trial = {trial};
        tmp.time = {time};
        data = [data tmp];
    end
    
    % freq analysis
    cfg = [];
    cfg.method = 'mtmfft';
    cfg.taper = 'dpss';
    cfg.output = 'fourier';
    cfg.tapsmofrq = 2;
    cfg.foi = 0:1:45;
    freq = [];
    for tr = 1:4
        freq = [freq ft_freqanalysis(cfg, data(tr))];
    end
    
    % connectivity
    
    cfg = [];
    cfg.method = 'coh';
    cfg.complex = 'absimag';
    imc = [];
    wnd = [];
    for tr=1:4
        imc = [imc ft_connectivityanalysis(cfg, freq(tr))];
        ch24 = imc(tr).cohspctrm(24, :, :);
        wnd = [wnd squeeze(sum(ch24,2))];
    end
    
    % IAB
    %iaf = 10.3958;
    %htf = 12.248;
    %8.7965:12.6152
    iaf = 12.6152;
    htf = 30;
    
    [iaf_x, index_l] = min(abs(imc(1).freq - iaf));
    [htf_x, index_h] = min(abs(imc(1).freq - htf));
    wnd = mean(wnd(index_l:index_h,:),1);
    
    WND = [WND; wnd];
end

%% Training session
clear
%eeglab

WND = [];
subject = 9;

for session=1:4
    filename = strcat(num2str(subject),'_',num2str(session),'_pruned.set_ica.set');
    EEG = pop_loadset(filename);
    data_full = eeglab2fieldtrip(EEG, 'preprocessing');
    
    % check data
    
    %cfg = [];
    %cfg.method = 'trial';
    %data_clean = ft_rejectvisual(cfg, data_full)
    
    % divide into trials
    
    data = [];
    
    if size(data_full.trial,2) >= 32
        start = 1;
    else
        start = 0;
    end
    
    for tr=1:30
        
        trial = data_full.trial{1, start + tr};
        time  = data_full.time {1, start + tr};
        tmp = data_full;
        tmp.trial = {trial};
        tmp.time = {time};
        data = [data tmp];
    end
    
    % freq analysis
    cfg = [];
    cfg.method = 'mtmfft';
    cfg.taper = 'dpss';
    cfg.output = 'fourier';
    cfg.tapsmofrq = 2;
    cfg.foi = 0:1:45;
    freq = [];
    for tr = 1:30
        freq = [freq ft_freqanalysis(cfg, data(tr))];
    end
    
    % connectivity
    
    cfg = [];
    cfg.method = 'coh';
    cfg.complex = 'absimag';
    imc = [];
    wnd = [];
    for tr=1:30
        imc = [imc ft_connectivityanalysis(cfg, freq(tr))];
        ch24 = imc(tr).cohspctrm(24, :, :);
        wnd = [wnd squeeze(sum(ch24,2))];
    end
    
    % IAB
    
    %iaf = 10.3958;
    %htf = 12.1875;
    iaf = 12.1875;
    htf = 30;
    %iaf = 4;
    %htf = 7;
    [iaf_x, index_l] = min(abs(imc(1).freq - iaf));
    [htf_x, index_h] = min(abs(imc(1).freq - htf));
    wnd = mean(wnd(index_l:index_h,:),1);
    
    WND = [WND; wnd];
end

%% divide sessions & sets

WND_plot = reshape(WND, [4,6,5]);

means = squeeze(mean(WND_plot,2));


minVal = min(min(min(WND_plot)));
maxVal = max(max(max(WND_plot)));

%Boxplots
figure;
for session=1:4
    subplot(2,2,session)
    boxplot(squeeze(WND_plot(session,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
    hold on
    plot([1 2 3 4 5],means(session,:),'*')
    legend('mean')
    ylim([minVal maxVal])
    hold on
    title(strcat('Session',num2str(session)));
end

%% if FC for all subjects is available join all data together

load Subject_3.mat; FC_1 = WND_plot;
load Subject_5.mat; FC_2 = WND_total;
load Subject_6.mat; FC_3 = WND_plot;
load Subject_9.mat; FC_4 = WND_plot;

FC_total = [FC_1 FC_2 FC_3 FC_4];

%% Check alpha for FC subjects

load Subject_3_alpha.mat; A_1 = ALPHA_plot;
load Subject_5_alpha.mat; A_2_raw = ALPHA_plot;
load Subject_6_alpha.mat; A_3 = ALPHA_plot;
load Subject_9_alpha.mat; A_4 = ALPHA_plot;

A_2 = [alpha11; A_2_raw(1,:,:); alpha33; A_2_raw(2,:,:)];
FC_total = [A_1 A_2 A_3 A_4];


%% Original OpenViBE data

load ALL_FC.mat; FC_total = WND_plot;

%% boxplots
%FC_total(:,13:18,:)=[];
n_trials = 6;
for subject=1:4
    minVal = min(min(min(FC_total(:,(subject-1)*n_trials+1:subject*n_trials,:))));
    maxVal = max(max(max(FC_total(:,(subject-1)*n_trials+1:subject*n_trials,:))));
    means = squeeze(mean(FC_total(:,(subject-1)*n_trials+1:subject*n_trials,:),2));
    figure;
    for session=1:4
        subplot(2,2,session)
        boxplot(squeeze(FC_total(session,(subject-1)*n_trials+1:subject*n_trials,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        hold on
        plot([1 2 3 4 5],means(session,:),'*')
        legend('mean')
        ylim([minVal maxVal])
        hold on
        title(strcat('Session',num2str(session)));
    end
end
%% slopes
for subject=1:4
    r = (subject-1)*n_trials+1:subject*n_trials;
    mean_S  = [mean(squeeze(FC_total(1,r,:))); mean(squeeze(FC_total(2,r,:))); mean(squeeze(FC_total(3,r,:))); mean(squeeze(FC_total(4,r,:)))];
    slope_S = [polyfit([1 2 3 4 5],mean_S(1,:),1); polyfit([1 2 3 4 5],mean_S(2,:),1); polyfit([1 2 3 4 5],mean_S(3,:),1); polyfit([1 2 3 4 5],mean_S(4,:),1)];
    minVal = min(min(min(FC_total(:,(subject-1)*n_trials+1:subject*n_trials,:))));
    maxVal = max(max(max(FC_total(:,(subject-1)*n_trials+1:subject*n_trials,:))));
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
        ylim([minVal-0.1 maxVal+0.1])
    end
end
%% boxplot all-in-one

minVal = min(min(min(FC_total)));
maxVal = max(max(max(FC_total)));
means = squeeze(mean(FC_total,2));
figure;
boxplot([ squeeze(FC_total(1,:,:)) squeeze(FC_total(2,:,:)) squeeze(FC_total(3,:,:)) squeeze(FC_total(4,:,:)) ])
hold on
plot(1:20,[means(1,:) means(2,:) means(3,:) means(4,:) ],'*')
legend('mean')
ylim([minVal maxVal])
hold on



%% slopes

mean_S  = [mean(squeeze(FC_total(1,:,:))); mean(squeeze(FC_total(2,:,:))); mean(squeeze(FC_total(3,:,:))); mean(squeeze(FC_total(4,:,:)))];
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



