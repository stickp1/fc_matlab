% Subject 5 has missing data in sessions 1 and 3, for S1 data is 
% from the end segment and for S3 data is for the beginning segment
clear 
%eeglab

WND = [];
FC_1 = [];
FC_3 = []
subject = 5;
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

    if session~=1 && session~=3 && size(data_full.trial,2) >= 32
        start = 1;
    else 
        start = 0;
    end
    
    switch session
        case 1
            ntrials = 23;
        case 3
            ntrials = 28;
        otherwise
            ntrials = 30;
    end

    for tr=1:ntrials
        
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
    cfg.foi = 0:0.1:45;
    freq = [];
    for tr = 1:ntrials
        freq = [freq ft_freqanalysis(cfg, data(tr))];
    end

    % connectivity

    cfg = [];
    cfg.method = 'coh';
    cfg.complex = 'absimag';
    imc = [];
    wnd = [];
    for tr=1:ntrials
        imc = [imc ft_connectivityanalysis(cfg, freq(tr))];
        ch24 = imc(tr).cohspctrm(24, :, :);
        wnd = [wnd squeeze(sum(ch24,2))];
    end

    % IAB
    
    iaf = 12.248;
    htf = 30;
    [iaf_x, index_l] = min(abs(imc(1).freq - iaf));
    [htf_x, index_h] = min(abs(imc(1).freq - htf));
    wnd = mean(wnd(index_l:index_h,:),1);

    switch session
        case 1
            FC_1 = wnd;
        case 3
            FC_3 = wnd;
        otherwise
            WND = [WND; wnd];
    end
           
    
end

%%

WND_plot = reshape(WND, [2,6,5]);
means = squeeze(mean(WND_plot,2));

FC_11 = [median(FC_1)*ones(1,7) FC_1];
FC_33 = [FC_3 median(FC_3)*ones(1,2)];
FC_11 = reshape(FC_11, [1,6,5]);
FC_33 = reshape(FC_33, [1,6,5]);
mean_11 = squeeze(mean(FC_11,2))';
mean_33 = squeeze(mean(FC_33,2))';
means = [mean_11; means(1,:); mean_33; means(2,:)];

WND_total = [FC_11; WND_plot(1,:,:); FC_33; WND_plot(2,:,:)];

minVal = min(min(min(WND_plot)));
maxVal = max(max(max(WND_plot)));

%Boxplots
figure;
for session=1:4
    subplot(2,2,session)
    switch session
        case 2
            boxplot(squeeze(WND_plot(1,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        case 1
             boxplot(squeeze(FC_11(1,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        case 3
             boxplot(squeeze(FC_33(1,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        case 4
            boxplot(squeeze(WND_plot(2,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
    end
    hold on
    plot([1 2 3 4 5],means(session,:),'*')
    legend('mean')
    ylim([minVal maxVal])
    hold on
    title(strcat('Session',num2str(session)));
end
