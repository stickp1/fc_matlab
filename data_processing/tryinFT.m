%clear
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
    freq = [];
    for tr=1:30
        
        trial = data_full.trial{1, start + tr};
        time  = data_full.time {1, start + tr};
        tmp = data_full;
        tmp.trial = {trial};
        tmp.time = {time};
        data = [data tmp];
        a = tmp.trial{1,1};
        a(1,1)
    end
    
    for tr=1:30
        % freq analysis
        cfg         = [];
        cfg.order   = 5;
        cfg.toolbox = 'bsmart';
        mdata       = ft_mvaranalysis(cfg, tmp);
        cfg = [];
        cfg.method = 'mvar';
        cfg.output = 'fourier';        
        freq = [freq ft_freqanalysis(cfg, mdata)];
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
    
    iaf = 10.3958;
    htf = 12.1875;
    [iaf_x, index_l] = min(abs(imc(1).freq - iaf));
    [htf_x, index_h] = min(abs(imc(1).freq - htf));
    wnd = mean(wnd(index_l:index_h,:),1);
    
    WND = [WND; wnd];
end