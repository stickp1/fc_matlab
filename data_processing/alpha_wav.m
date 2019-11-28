%% compute alpha for each trial of each session

clear
%eeglab
subject = 2;
ALPHA_plot=[];
for session=1:4
    
    EEG = pop_loadset(strcat(num2str(subject),'_',num2str(session),'_pruned.set_ica.set'));
    nTrials = EEG.trials;
    % divide into trials
    
    data  = [];
    spect = [];
    freqs = [];
    
    if EEG.trials > 30
        start = 1;
        nTrials = nTrials-(EEG.trials-30);
    else
        start = 0;
    end
    
    for trial=1:nTrials
        dataa = EEG.data(:,:,trial + start);
        s = EEGTools_TimeFreqAnalysis(dataa(24,:),250,4, nTrials,26, 7);
        f = 1:45;
        %[s, f] = pop_spectopo(tmp,1,[0 60000],'EEG','percent',100,'freqrange',[1 45]);
        spect = [spect abs(s)];
        freqs = [freqs f];
    end
   
    % IAB
    
    iaf = round(8.5966);
    htf = round(13.0141);
    
    [iaf_x, index_l] = min(abs(freqs - iaf));
    [htf_x, index_h] = min(abs(freqs - htf));
    [lnorm_x, index_nl] = min(abs(freqs - 4));
    [hnorm_x, index_nh] = min(abs(freqs - 30));
    
    spect = reshape(spect, [26, 15000, nTrials]);
    av_alpha = mean(spect(iaf:htf,:,:),1);
    norm = mean(spect(:,:,:),1);
    
    if nTrials < 30
        if session == 3
            alpha3 = av_alpha./norm;
        else
            ALPHA_plot = [ALPHA_plot; av_alpha./norm];
        end
    else
        ALPHA_plot = [ALPHA_plot; av_alpha./norm];
    end
end



%%
ALPHA_plot = reshape(abs(ALPHA_plot), [4,90000,5]);

%% boxplots


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
    ylim([minVal 4])
    hold on
    title(strcat('Session',num2str(session)));
end

%% slopes

mean_S = [mean(squeeze(ALPHA_plot(1,:,:))); mean(squeeze(ALPHA_plot(2,:,:))); mean(squeeze(ALPHA_plot(3,:,:))); mean(squeeze(ALPHA_plot(4,:,:)))];

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

%% if subject 2

alpha3 = squeeze(alpha3);
alpha3 = [mean(alpha3(:))*ones(15000,11) alpha3];
alpha3 = reshape(alpha3, [1,90000,5]);
ALPHA_plot = reshape(ALPHA_plot,[3,90000,5]);
ALPHA_plot = [ALPHA_plot(1:2,:,:); alpha3; ALPHA_plot(3,:,:)];