% clc
% clear all
% close all

%find the minimum and the maximum
[uni_file , pcsv ] = uigetfile('*.csv');
uni = dlmread(strcat(pcsv,uni_file),',',1,0);

p = prctile(uni(:,3),[1 50 55 60 65 99]);

% uni=[uni(:,1:2) uni(:,26) uni(:,35:37)] %in case all channels were recorded, select only Cz (24 => position 26)

stims=uni(:,4);
beep_stims = find(stims(:,1)==33282); %find all the beep stimulations (should be 5)

stim_EO1 = beep_stims(1,1);
stim_EC1 = beep_stims(2,1);
stim_EO2 = beep_stims(3,1);
stim_EC2 = beep_stims(4,1);

EO_range = [uni(stim_EO1:stim_EC1-1,3); uni(stim_EO2:stim_EC2-1,3)];
EC_range = [uni(stim_EC1:stim_EO2-1,3); uni(stim_EC2:end,3)];

% pEO=5;
pEO = prctile(EO_range,[1 40 45 50 55 60 65 99]);
pEC = prctile(EC_range,[1 40 45 50 55 60 65 99]);

min_EO = min(EO_range);
max_EO = max(EO_range);
mean_EO = mean(EO_range);
std_EO = std(EO_range);
uni_max_EO = mean_EO + 3 * std_EO;

min_EC = min(EC_range);
max_EC = max(EC_range);
mean_EC = mean(EC_range);
std_EC = std(EC_range);
uni_max_EC = mean_EC + 3 * std_EC;

% Upper Alpha's time course
figure
plot(uni(:,1),uni(:,3)) % plot the signal as it is (without concatenating EO and EC signal)
hold on 
%plot(uni(stim_EC2:end,1),uni(stim_EC2:end,3),'r');
xlabel('Time (s)')
xlim([0 260])
hold on
plot([uni(stim_EO1) uni(stim_EO1)], ylim) % Plot Vertical Line - LTF
hold on
plot([uni(stim_EC1) uni(stim_EC1)], ylim) % Plot Vertical Line - LTF
hold on
plot([uni(stim_EO2) uni(stim_EO2)], ylim) % Plot Vertical Line - LTF
hold on
plot([uni(stim_EC2) uni(stim_EC2)], ylim) % Plot Vertical Line - LTF
% plot([uni(stim_ind,1) uni(stim_ind,1)], ylim) % Plot Vertical Line - LTF
pos=2.7;
text([uni(stim_EO1) uni(stim_EC1) uni(stim_EO2) uni(stim_EC2)], [pos pos pos pos], {'\rightarrow EO','\rightarrow EC','\rightarrow EO','\rightarrow EC'})
%title('Relative Upper Alpha timecourse during EO/EC calibration')
title('Feedback measure during EO/EC calibration')
%ylabel('Relative Upper Alpha')
ylabel('Feedback measure');

% Write to file
sett = strcat(' max EO =  ',num2str(pEC(end) + 0.2 * pEC(end)),'\n min EO =  ',num2str(pEO(1)),'\n threshold EO =  ',num2str(min_EC));
fname = strcat(pcsv,'\..\NF4_info_min_max_a.txt');
ParticipantXX = fopen(fname,'w');
fprintf(ParticipantXX,sett);
fclose(ParticipantXX);