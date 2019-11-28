clear 
%eeglab
subject = 2;
ALPHA_plot=[]
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
    if session==3
        max_trial = 19;
    else
        max_trial = 30;
    end
    
    for trial=1:max_trial
        trial
        tmp = EEG;
        tmp.data = tmp.data(:,:,trial + start);
        data = [data tmp];
        [s, f] = pop_spectopo(tmp,1,[0 60000],'EEG','percent',100,'freqrange',[1 45]);
        spect = [spect s];
        freqs = [freqs f];
    end

    % IAB

    %iaf = 8.7965; 
    %htf = 12.6152;
    iaf = 8.7965;
    htf = 30;
    
    %iaf = 4;
    %htf = 7;
    
    [iaf_x, index_l] = min(abs(freqs - iaf));
    [htf_x, index_h] = min(abs(freqs - htf));
    [lnorm_x, index_nl] = min(abs(freqs - 4));
    [hnorm_x, index_nh] = min(abs(freqs - 30));
    
    spect = reshape(spect, [32, 513, max_trial]);
    av_alpha = squeeze(mean(spect(24,index_l:index_h,:),2));
    norm = squeeze(mean(spect(24,index_nl:index_nh,:),2));
    
    switch session
        case 3
            alpha3 = (av_alpha./norm)';
        otherwise
            ALPHA_plot = [ALPHA_plot; (av_alpha./norm)'];
    end
            
    
end

%%


ALPHA_plot = reshape(ALPHA_plot, [3,6,5]);
alpha33 = [mean(alpha3)*ones(1,11) alpha3];
alpha33 = reshape(alpha33, [1,6,5]);
%%
means = squeeze(mean(ALPHA_plot,2));


minVal = min(min(min(ALPHA_plot)));
maxVal = max(max(max(ALPHA_plot)));

%Boxplots
figure;
for session=1:4
    if session==3
        subplot(2,2,session)
        boxplot(squeeze(alpha33(1,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        hold on
        plot([1 2 3 4 5],squeeze(mean(alpha33,2)),'*')
        legend('mean')
        ylim([minVal maxVal])
        hold on
        title(strcat('Session',num2str(session)));
    elseif session==4
        subplot(2,2,session)
        boxplot(squeeze(ALPHA_plot(3,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        hold on
        plot([1 2 3 4 5],means(3,:),'*')
        legend('mean')
        ylim([minVal maxVal])
        hold on
        title(strcat('Session',num2str(session)));
    elseif session==1
        subplot(2,2,session)
        boxplot(squeeze(ALPHA_plot(1,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        hold on
        plot([1 2 3 4 5],means(1,:),'*')
        legend('mean')
        ylim([minVal maxVal])
        hold on
        title(strcat('Session',num2str(session)));
    else
         subplot(2,2,session)
         boxplot(squeeze(ALPHA_plot(2,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
         hold on
         plot([1 2 3 4 5],means(2,:),'*')
         legend('mean')
         ylim([minVal maxVal])
         hold on
         title(strcat('Session',num2str(session)));
    end
end