%% VOLUME CONDUCTION TESTS ( + comparison with fieldtrip)

%% Some constants

FS = 200;                               % sampling frequency
TEST = 1;                               % choose test
NUMBER = 7;                             
DO = [1 1 0 1 1 1 1];
MIN = [0 0   0   0   0   0 -0.5];
MAX = [1 1 0.5 0.5 0.5 0.5  0.5];
SEGLENGTH = [40 1 1 40 1 1 40];
EPOCH = [4 4 4 4 4 4 4];
DELTA = FS./SEGLENGTH;
DURATION = 100; %seconds
TARGET_FREQ = [40 40 40 40 40 40 40];
TIMES = zeros(1,NUMBER); 
FREQNUMBER = zeros(1,NUMBER);
longestfreqvector =0:min(DELTA):FS/2-1;
matrix = zeros(50,50,length(longestfreqvector),NUMBER,length(TEST));
stdev  = zeros(50,25,50,length(longestfreqvector),NUMBER,length(TEST));
method_name = {'coh','plv','ciplv','imc','imch','wpli','psi'};

%% 

for test=1:length(TEST)
    
    pre= strcat('D:\4Windows\Testes\Vol_peak40\',num2str(TEST(test)),'\',method_name(:),'\channel');
    fmt2 = repmat('%f', 1, 505);% for Phase Locking type, each file has 505 collumns (10 channels * 50 channels + 5)
    disp(strcat({'TEST NR. '},num2str(TEST(test))));
    for method=NUMBER:-1:1
        if DO(method)
            disp(strcat({'Method = '},method_name{method}));
            for c=1:5
                filename = strcat(pre{method},num2str((c-1)*10+1),'-',num2str(c*10),'.csv');
                id = fopen(filename,'rt');
                switch method_name{method}
                    case {'coh' 'imc' 'psi'}
                        FREQNUMBER(method) = TARGET_FREQ(method)/DELTA(method)+1;
                        freqvector = 0:DELTA(method):FS/2-1;
                        fmt = repmat('%f',1,10*50*SEGLENGTH(method)+5);% each cvs file has * collumns (10 channels * 50 channels * x frequencies + 2 time (start&end) + 3 Event (Id, Duration, Date))
                        disp(strcat({'Arranging channels '},num2str((c-1)*10+1),{' to '},num2str(c*10),'...'));
                        datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
                        channel_t = datacell{1};  
                        times = channel_t(:,1);
                        if size(channel_t,1)~=1
                            channel = mean(channel_t);
                        else channel = channel_t;
                        end
                        channel = channel(3:end-3);
                        channel_t = channel_t(:,3:end-3);
                        if mod(SEGLENGTH(method),2)~=0
                            tmp = zeros(1,10*50*length(freqvector));
                            for ch=1:500
                                tmp(length(freqvector)*(ch-1)+1:length(freqvector)*ch) = channel(SEGLENGTH(method)*(ch-1)+1:2:SEGLENGTH(method)*ch);
                            end
                            channel = tmp;
                        else
                            channel = channel(1:2:end); % clear repeated columns
                            channel_t = channel_t(:,1:2:end);
                        end
                        
                        for i=1:length(freqvector)
                            start=0;
                            for j=9:-1:0
                                %size(matrix(10*c-j,:,i,method,test))
                                %size(channel(i+start:length(freqvector):i+start+49*length(freqvector)))
                                matrix(10*c-j,:,i,method,test) = channel(i+start:length(freqvector):i+start+49*length(freqvector));
                                stdev(10*c-j,1:floor(DURATION/EPOCH(method)),:,i,method,test) = channel_t(:,i+start:length(freqvector):i+start+49*length(freqvector));
                                start = start + 50*length(freqvector);
                            end
                        end
                    otherwise
                        FREQNUMBER(method) = 1;
                        datacell = textscan(id, fmt2, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
                        channel_t = datacell{1};
                        times = channel_t(:,1);
                        channel = mean(channel_t);
                        channel = channel(3:end-3);
                        channel_t = channel_t(:,3:end-3);
                        start = 0;
                        for j=9:-1:0
                            matrix(10*c-j,:,1,method,test) = channel(start+1:start+50);
                            stdev(10*c-j,1:DURATION/EPOCH(method),:,1,method,test) = channel_t(:,1+start:start+50);
                            start = start + 50;
                        end
                        
                end
                fclose(id);
            end
        end
    end
end

%%
for method=1:NUMBER
    if DO(method)
        figure;
        plot(matrix(16,:,FREQNUMBER(method),method),'k','linewidth',1); %axis([1 50 0 MAX(method)]);
        ylabel('connectivity','fontsize', 25);
        xlabel('sensor','fontsize', 25);
        set(gca,'fontsize', 25);
        %set(gca,'Xtick',0:10:50,'Ytick',0:0.2:MAX(method),'tickdir','out','fontsize',15);
        title(strcat(method_name{method},': channel 16 - f=',num2str(40)),'fontsize',25);
    end
end

%%
method = 4;
switch method_name{method}
    case{'coh' 'imc' 'psi'}
        %for a=1:length(freqvector)
        figure; hold on;
        imagesc(matrix(:,:,FREQNUMBER(method),method,test));
        plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
        plot([16 35],[16 35],'wo','markerfacecolor','w');
        plot([0.5 50.5],[16 16],'w--','linewidth',2);
        plot([16 35],[16 16],'ws','markerfacecolor','w');
        caxis([0 MAX(method)]);
        axis square; axis tight
        set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
        title(strcat(method_name{method},':f=',num2str((FREQNUMBER(method)-1)*DELTA(method))),'fontsize',25);
        colorbar('fontsize',25);
        %end
    otherwise
        figure; hold on;
        imagesc(matrix(:,:,1,method,test));
        plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
        plot([16 35],[16 35],'wo','markerfacecolor','w');
        plot([0.5 50.5],[16 16],'w--','linewidth',2);
        plot([16 35],[16 16],'ws','markerfacecolor','w');
        caxis([0 MAX(method)]);
        axis square; axis tight
        set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
        title(strcat(method_name{method},':f=',num2str(40)),'fontsize',25);
        colorbar('fontsize',25);
end
%%
figure; hold on;
imagesc(icoh.cohspctrm(:,:,41));
plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
plot([16 35],[16 35],'wo','markerfacecolor','w');
caxis([0 0.5]);
axis square; axis tight
set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
title('imag(coh)','fontsize',25);
colorbar('fontsize',25);

%% PLOTS MATRICES
for test=1:length(TEST)
    for method=1:NUMBER
        if DO(method)
            switch method_name{method}
                case{'coh' 'imc' 'psi'}
                    %for a=1:length(freqvector)
                        subplot(2,3,method)
                        figure; hold on;
                        imagesc(matrix(:,:,FREQNUMBER(method),method,test));
                        plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
                        plot([16 35],[16 35],'wo','markerfacecolor','w');
                        plot([0.5 50.5],[16 16],'w--','linewidth',2);
                        plot([16 35],[16 16],'ws','markerfacecolor','w');
                        caxis([0 MAX(method)]);
                        axis square; axis tight
                        set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
                        title(strcat(method_name{method},':f=',num2str((FREQNUMBER(method)-1)*DELTA(method))),'fontsize',25);
                        colorbar('fontsize',25);
                    %end
                otherwise
                    figure; hold on;
                    imagesc(matrix(:,:,1,method,test));
                    plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
                    plot([16 35],[16 35],'wo','markerfacecolor','w');
                    plot([0.5 50.5],[16 16],'w--','linewidth',2);
                    plot([16 35],[16 16],'ws','markerfacecolor','w');
                    caxis([0 MAX(method)]);
                    axis square; axis tight
                    set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
                    title(strcat(method_name{method},':f=[',num2str(35),',',num2str(45),']'),'fontsize',25);
                    colorbar('fontsize',25);
            end
        end
    end
end

%% PLOT ALL for Thesis --- change subtitles and do sl=40 te=4 for no conn cases!

figure;
% Magnitude Squared Coherence
subplot(2,3,1)
s = pcolor(matrix(:,:,FREQNUMBER(1),1));
s.FaceColor='interp';
s.EdgeColor='none';
hold on;
plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
plot([16 35],[16 35],'wo','markerfacecolor','w');
plot([0.5 50.5],[16 16],'w--','linewidth',2);
plot([16 35],[16 16],'ws','markerfacecolor','w');
caxis([0 MAX(1)]);
axis square; axis tight
set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
%title(['MSCoh','  f=[' num2str(freqvector(FREQNUMBER(1)-1)) ',' num2str(freqvector(FREQNUMBER(1))) '] Hz'],'fontsize',25);
title('MSCoh')
colorbar('fontsize',25);

% Imaginary Part of Coherency
subplot(2,3,2)
s = pcolor(matrix(:,:,FREQNUMBER(4),4));
s.FaceColor='interp';
s.EdgeColor='none';
hold on;
plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
plot([16 35],[16 35],'wo','markerfacecolor','w');
plot([0.5 50.5],[16 16],'w--','linewidth',2);
plot([16 35],[16 16],'ws','markerfacecolor','w');
caxis([0 MAX(4)]);
axis square; axis tight
set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
%title(['ImC','  f=[' num2str(freqvector(FREQNUMBER(4)-1)) ',' num2str(freqvector(FREQNUMBER(4))) '] Hz'],'fontsize',25);
title('ImC')
colorbar('fontsize',25);


% Phase Slope Index
subplot(2,3,3)
s = pcolor(matrix(:,:,FREQNUMBER(7),7));
s.FaceColor='interp';
s.EdgeColor='none';
hold on;
plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
plot([16 35],[16 35],'wo','markerfacecolor','w');
plot([0.5 50.5],[16 16],'w--','linewidth',2);
plot([16 35],[16 16],'ws','markerfacecolor','w');
caxis([MIN(7) MAX(7)]);
axis square; axis tight
set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
%title(['PSI','  f=[' num2str(freqvector(FREQNUMBER(7)-1)) ',' num2str(freqvector(FREQNUMBER(7))) '] Hz'],'fontsize',25);
title('PSI')
colorbar('fontsize',25);

% Phase Locking Value
subplot(2,3,4)
s = pcolor(matrix(:,:,1,2));
s.FaceColor='interp';
s.EdgeColor='none';
hold on;
plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
plot([16 35],[16 35],'wo','markerfacecolor','w');
plot([0.5 50.5],[16 16],'w--','linewidth',2);
plot([16 35],[16 16],'ws','markerfacecolor','w');
caxis([0 MAX(2)]);
axis square; axis tight
set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
%title(['PLV' '  f=[' num2str(35) ',' num2str(40) '] Hz'],'fontsize',25);
title('PLV')
colorbar('fontsize',25);


% Imaginary Part of Coehrency (Hilbert)
subplot(2,3,5)
s = pcolor(matrix(:,:,1,5));
s.FaceColor='interp';
s.EdgeColor='none';
hold on;
plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
plot([16 35],[16 35],'wo','markerfacecolor','w');
plot([0.5 50.5],[16 16],'w--','linewidth',2);
plot([16 35],[16 16],'ws','markerfacecolor','w');
caxis([0 MAX(5)]);
axis square; axis tight
set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
%title(['ImC(H)' '  f=[' num2str(35) ',' num2str(40) '] Hz'],'fontsize',25);
title('ImC(H)')
colorbar('fontsize',25);

% weighted Phase Lag Index
subplot(2,3,6)
s = pcolor(matrix(:,:,1,6).^2);
s.FaceColor='interp';
s.EdgeColor='none';
hold on;
plot([0.5 50.5],[0.5 50.5],'w','linewidth',2);
plot([16 35],[16 35],'wo','markerfacecolor','w');
plot([0.5 50.5],[16 16],'w--','linewidth',2);
plot([16 35],[16 16],'ws','markerfacecolor','w');
caxis([0 MAX(6)]);
axis square; axis tight
set(gca,'fontsize', 25, 'Xtick', 10:10:40, 'Ytick', 10:10:40, 'tickdir', 'out');
%title(['wPLI' '  f=[' num2str(35) ',' num2str(40) '] Hz'],'fontsize',25);
title('wPLI')
colorbar('fontsize',25);


