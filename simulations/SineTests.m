%% Reproduction of OV data generation

fs = 200;
t = 0: 1/fs : 0.2 - 1/fs;
channels = zeros(6,length(t));
channels(1,:) = sin(2*pi*10*t);
channels(2,:) = channels(1,:);
channels(3,:) = sin(2*pi*10*t - pi/4);
channels(4,:) = sin(2*pi*10*t - pi/3);
channels(5,:) = sin(2*pi*10*t - pi/2);
channels(6,:) = sin(2*pi*10*t - 2*pi/3);
y = {'0ºlag','0º lag','45º lag','60º lag','90º lag','120º lag'};
figure
for i=1:6
subplot(6,1,i)
plot(t,channels(i,:))
set(gca,'fontsize',15);
xlabel('time (s)');
ylabel(y{i})
%set(get(gca,'ylabel'),'rotation',0)
end


%% Reading OV data for the simple Sine Tests
cd D:\UnityNeurofeedback\Tests\sineTests
idMSCoh = fopen('MScoh.csv','rt');
idImC   = fopen('ImC.csv','rt');
idPSI   = fopen('PSI.csv','rt');
idwPLI  = fopen('wPLI.csv','rt');
idciPLV = fopen('ciPLV.csv','rt');
idImC_h = fopen('ImC_h.csv','rt');

fmt = repmat('%f',1,10);
datacell_MSCoh = textscan(idMSCoh, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
datacell_ImC   = textscan(idImC, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
datacell_PSI   = textscan(idPSI, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
datacell_wPLI  = textscan(idwPLI, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
datacell_ciPLV = textscan(idciPLV, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
datacell_ImC_h = textscan(idImC_h, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);


MSCoh = datacell_MSCoh{1};                  
ImC   = datacell_ImC{1};                  
PSI   = datacell_PSI{1};                  
wPLI  = datacell_wPLI{1};
ciPLV = datacell_ciPLV{1};
ImC_h = datacell_ImC_h{1};

MSCoh = MSCoh(:,3:end-3);                  
ImC   = ImC(:,3:end-3);                       
PSI   = PSI(:,3:end-3);                              
wPLI  = wPLI(:,3:end-3);   
ciPLV = ciPLV(:,3:end-3);   
ImC_h = ImC_h(:,3:end-3);   
shifts = [0 45 60 90 120];
figure

%y1 = annotation('textbox', [0.175, 0.9, 0.1, 0.1], 'String', {'Magnitude','Squared','Coherence'},'EdgeColor','none'); y1.FontSize = 20;
%y2 =annotation('textbox', [0.31, 0.9, 0.1, 0.1], 'String', {'Imaginary','Part of','Coherency'},'EdgeColor','none'); y2.FontSize = 20;
%y3 = annotation('textbox', [0.51, 0.9, 0.1, 0.1], 'String', {'Imaginary','Part of','Coherency','(Hilbert)'},'EdgeColor','none'); y3.FontSize = 20;
%y4 =annotation('textbox', [0.815, 0.9, 0.1, 0.1], 'String', {'Weighted','Phase Lag','Index'},'EdgeColor','none'); y4.FontSize = 20; 

%x0 = annotation('textbox', [0.01, 0.9, 0.1, 0.1], 'String', 'phase shift:','EdgeColor','none'); x0.FontSize = 20;
%x1 = annotation('textbox', [0.03, 0.78, 0.1, 0.1], 'String', '0º','EdgeColor','none'); x1.FontSize = 20;
%x2 =annotation('textbox',  [0.03, 0.6, 0.1, 0.1], 'String', '45º','EdgeColor','none'); x2.FontSize = 20;
%x3 = annotation('textbox', [0.03, 0.44, 0.1, 0.1], 'String', '60º','EdgeColor','none'); x3.FontSize = 20;
%x4 =annotation('textbox',  [0.03, 0.27, 0.1, 0.1], 'String', '90º','EdgeColor','none'); x4.FontSize = 20; 
%x5 =annotation('textbox',  [0.03, 0.09, 0.1, 0.1], 'String', '120º','EdgeColor','none'); x5.FontSize = 20; 

for i=1:5:25
    
    subplot(5,5,i)
    plot(t,channels(round(i/5)+2,:))
    xlabel('time (s)');
    ylabel(y{round(i/5)+2})
    if i==1
        title('2nd input')
    end
    
    subplot(5,5,i+1)
    plot(MSCoh(:,round(i/5)+1))
    set(gca,'fontsize',15);
    xlabel('time (s)');
    ylim([-0.25 1.25])
    if i==1
        title('MSCoh')
    end
    %ylabel(['\Delta\theta = ' num2str(shifts(round(i/5)+1)) 'º'])
    ax=gca;
    ax.YGrid='on';

    subplot(5,5,i+2)
    plot(ImC(:,round(i/5)+1))
    set(gca,'fontsize',15);
    xlabel('time (s)');
    ylim([-0.25 1.25])
    if i==1
        title('ImC')
    end
    ax=gca;
    ax.YGrid='on';

    subplot(5,5,i+3)
    plot(ImC_h(:,round(i/5)+1))
    set(gca,'fontsize',15);
    xlabel('time (s)');
    ylim([-0.25 1.25])
    if i==1
        title('ImC(H)')
    end
    ax=gca;
    ax.YGrid='on';

    subplot(5,5,i+4)
    xlabel('time (s)');
    plot(wPLI(:,round(i/5)+1).^2)
    set(gca,'fontsize',15);
    xlabel('time (s)');
    ylim([-0.25 1.25])
    if i==1
        title('wPLI')
    end
    ax=gca;
    ax.YGrid='on';
end
%{
for i=1:5
    subplot(5,5,i+20)
    plot(ciPLV(:,i))
    xlabel('time (s)');
    ylim([0 1.25])
end
for i=1:5
    subplot(5,5,i+25)
    plot(PSI(:,i))
    xlabel('time (s)');
    ylim([-1.25 1.25])
end
%}

