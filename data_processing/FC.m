clear 
eeglab

WND = [];
subject = 3;
for session=1:4
    filename = strcat(num2str(subject),'_',num2str(session),'_pruned.set_ica.set');
    EEG = pop_loadset(filename);
    data_full = eeglab2fieldtrip(EEG, 'preprocessing');

    % check data

    %cfg = [];
    %cfg.method = 'trial';
    %data_clean = ft_rejectvisual(cfg, data_full)

    % divide into sets

    data = [];

    if size(data_full.trial,2) == 32
        start = 1;
    else 
        start = 0;
    end

    for set=0:4
        trials = {};
        times = {};
        for tr=1:6
            trial = data_full.trial{1, start + set * 6 + tr};
            time  = data_full.time {1, start + set * 6 + tr};
            trials{1,tr} = trial;
            times {1,tr} = time;
        end
        tmp = data_full;
        tmp.trial = trials;
        tmp.time = times;
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
    for set = 1:5
        freq = [freq ft_freqanalysis(cfg, data(set))];
    end

    % connectivity

    cfg = [];
    cfg.method = 'coh';
    cfg.complex = 'absimag';
    imc = [];
    wnd = [];
    for set=1:5
        imc = [imc ft_connectivityanalysis(cfg, freq(set))];
        ch24 = imc(set).cohspctrm(24, :, :);
        wnd = [wnd squeeze(sum(ch24,2))];
    end

    % IAB

    iaf = 8.7965;
    htf = 12.6152;
    [iaf_x, index_l] = min(abs(imc(1).freq - iaf));
    [htf_x, index_h] = min(abs(imc(1).freq - htf));
    wnd = mean(wnd(index_l:index_h,:),1);

    WND = [WND; wnd];
end
%% plot
min = min(min(WND));
max = max(max(WND));
figure;
for session=1:4
    subplot(2,2,session);
    scatter(1:5,WND(session,:),'filled')
    ylim([min max])
end
%%
imagesc(imc.cohspctrm(:,:,101));
caxis([0 1]);
axis square; axis tight
title('ImC')