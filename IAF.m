% clc
clear all

% Search for .ov file to be converted to .mat. File has to have
% stimulations in order for the script to run with no errors
[fileinp , p ] = uigetfile({'*.ov'}, 'Choose OV File');
fileout = regexprep(fileinp, '\.ov$', '\.mat'); %Replace .ov with .mat
myconvert_ov2mat(p,fileinp,fileout);

% % PilotIE baseline pre
% total_signal = load(strcat(p,'NF1_calib_EO_EC_PilotIE_S1_2018.06.19_12.15.33_post.mat'));

% Extract variables from converted file
% [fileout , p ] = uigetfile({'*.mat'}, 'Choose .mat File');
total_signal = load(strcat(p,fileout));
samples = (total_signal.samples);
samples = samples(:,24); %Cz channel is number 24
time_vec = total_signal.sampleTime;

%Para usar a data vinda do EEGLAB:
% x=EEG.data;
% x=x(24,:);
% x=x';
% time_vec_2 = EEG.times';
% TF_Decomposition_v2(total_signal.samplingFreq, total_signal.samples', 24, [4 30], 1,start_EO1,start_EO2,start_EC1,start_EC2,time_vec);

% Concatenate EC and EO signals
beep_stims = total_signal.stims(find(total_signal.stims(:,2)==33282 | total_signal.stims(:,2)==33283),1); %find all the beep stimulations (should be 5)

stim_EO1 = beep_stims(1); % moment when the first EO period begins
stim_EC1 = beep_stims(2); % moment when the first EC period begins
stim_EO2 = beep_stims(3); % moment when the second EO period begins
stim_EC2 = beep_stims(4); % moment when the second EC period begins

[~,start_EO1] = min(abs(time_vec-stim_EO1)); % corresponding index on the time vector
[~,start_EC1] = min(abs(time_vec-stim_EC1)); % corresponding index on the time vector
[~,start_EC2] = min(abs(time_vec-stim_EC2)); % corresponding index on the time vector
[~,start_EO2] = min(abs(time_vec-stim_EO2)); % corresponding index on the time vector

EO_raw = [samples(start_EO1 : start_EC1-1); samples( start_EO2 : start_EC2-1)];
EC_raw = [samples(start_EC1 : start_EO2-1); samples(start_EC2 : end);];

% Define pwelch's inputs
fs=total_signal.samplingFreq; % sampling frequency
segmentLength = 5 * fs + 1; % ~5 seconds x 512 samples/second (sampling frequency). +1 because time vector starts at 0
nfft = segmentLength; % number of discrete Fourier transform (DFT) points to use in the PSD estimate. Correct?
noverlap = round(0.1 * segmentLength); % 10% of the window length

% Calculate the PSD fo EC and EO
[pxxEC,fEC] = pwelch(EC_raw,segmentLength,noverlap,nfft,fs);
[pxxEO,fEO] = pwelch(EO_raw,segmentLength,noverlap,nfft,fs);

% find frequencies's indexes (alpha and whole eeg boundaries)
[~,f30] = min(abs(fEO-30));
[~,f8] = min(abs(fEO-8));
[~,f13] = min(abs(fEO-13));

order = 8;
framelen = 11;
% pxxEC = sgolayfilt(pxxEC,order,framelen);
% pxxEO = sgolayfilt(pxxEO,order,framelen);

% Select only the frequency range up until 30 Hz
EO = abs([(fEO(1:f30))';10*log10((pxxEO(1:f30))')]);
EC = abs([(fEC(1:f30))';10*log10((pxxEC(1:f30))')]);

% Calculate the intersections between the EO and the EC curves
P = InterX(EO,EC);

% Determine the Individual Alpha Frequency (IAF), the peak within the
% 8-13Hz range in the EC curve
[iaf, p2] = findPeak(fEC,pxxEC,[8,13]);

% Determine the high and low transition frequencies (nearest intersection points surrounding the IAF)
inter = P(1,:);
dist = inter-iaf;

Left = max (dist(dist<0));
Rigth = min (dist(dist>0));

LTF_ind = find(dist==Left);
HTF_ind = find(dist==Rigth);

LTF = inter(LTF_ind);
HTF = inter(HTF_ind);

% Plot the PSD and IAF, LTF, HTF
figure
plot(EO(1,:),EO(2,:),EC(1,:),EC(2,:),P(1,:),P(2,:),'ro')
legend('EO','EC')

% If none of the values are empty
if ~isempty(HTF) && ~isempty(iaf) && ~isempty(LTF)
    hold on
    iafplot = plot([iaf iaf], ylim); % Plot Vertical Line - IAF
    hold on
    htfplot = plot([HTF HTF], ylim); % Plot Vertical Line - HTF
    hold on
    ltfplot = plot([LTF LTF], ylim); % Plot Vertical Line - LTF
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    htext = text([LTF iaf HTF], [40 45 50], {strcat('\leftarrow LTF = ',num2str(LTF)), strcat('\leftarrow IAF = ',num2str(iaf)),strcat('\leftarrow HTF = ',num2str(HTF))})
    [s,~]=getpts;
    if numel(s)==2
        LTF = s(1);
        HTF = s(2);
        delete(htfplot);
        delete(ltfplot);
        delete(htext);
        hold on
        htfplot = plot([HTF HTF], ylim); % Plot Vertical Line - HTF
        ltfplot = plot([LTF LTF], ylim); % Plot Vertical Line - HTF
        htext = text([LTF iaf HTF], [40 45 50], {strcat('\leftarrow LTF = ',num2str(LTF)), strcat('\leftarrow IAF = ',num2str(iaf)),strcat('\leftarrow HTF = ',num2str(HTF))});
    else
        HTF = s;
        delete(htfplot);
        delete(htext);
        hold on
        htfplot = plot([HTF HTF], ylim); % Plot Vertical Line - HTF
        htext = text([LTF iaf HTF], [40 45 50], {strcat('\leftarrow LTF = ',num2str(LTF)), strcat('\leftarrow IAF = ',num2str(iaf)),strcat('\leftarrow HTF = ',num2str(HTF))});
    end
end

if isempty(HTF) && ~isempty(iaf) && ~isempty(LTF)
    hold on
    iafplot = plot([iaf iaf], ylim); % Plot Vertical Line - IAF
    hold on
    ltfplot = plot([LTF LTF], ylim); % Plot Vertical Line - LTF
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    htext = text([LTF iaf], [40 45], {strcat('\leftarrow LTF = ',num2str(LTF)), strcat('\leftarrow IAF = ',num2str(iaf))});
    [HTF,~]=getpts;
    delete(htext);
    hold on
    htfplot = plot([HTF HTF], ylim); % Plot Vertical Line - HTF
    htext = text([LTF iaf HTF], [40 45 50], {strcat('\leftarrow LTF = ',num2str(LTF)), strcat('\leftarrow IAF = ',num2str(iaf)),strcat('\leftarrow HTF = ',num2str(HTF))})
end

if ~isempty(HTF) && ~isempty(iaf) && isempty(LTF)
    hold on
    iafplot = plot([iaf iaf], ylim); % Plot Vertical Line - IAF
    hold on
    Htfplot = plot([HTF HTF], ylim); % Plot Vertical Line - LTF
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    htext = text([HTF iaf], [40 45], {strcat('\leftarrow LTF = ',num2str(HTF)), strcat('\leftarrow IAF = ',num2str(iaf))});
    [LTF,~]=getpts;
    delete(htext);
    hold on
    htfplot = plot([LTF LTF], ylim); % Plot Vertical Line - HTF
    htext = text([LTF iaf HTF], [40 45 50], {strcat('\leftarrow LTF = ',num2str(LTF)), strcat('\leftarrow IAF = ',num2str(iaf)),strcat('\leftarrow HTF = ',num2str(HTF))})
end

%%
sett1 = strcat('\t<SettingValue>',num2str(iaf),'</SettingValue> \n');
sett2 = strcat('\t<SettingValue>',num2str(HTF),'</SettingValue> \n');
fname = strcat(p,'Temporal_Filter.txt');
ParticipantXX = fopen(fname,'w');
fprintf(ParticipantXX,'<OpenViBE-SettingsOverride> \n');
fprintf(ParticipantXX,'\t<SettingValue>Butterworth</SettingValue> \n');
fprintf(ParticipantXX,'\t<SettingValue>Band Pass</SettingValue> \n');
fprintf(ParticipantXX,'\t<SettingValue>4</SettingValue> \n');
fprintf(ParticipantXX,sett1);
fprintf(ParticipantXX,sett2);
fprintf(ParticipantXX,'\t<SettingValue>0.5</SettingValue> \n');
fprintf(ParticipantXX,'</OpenViBE-SettingsOverride>');
fclose(ParticipantXX);

sett = strcat('\t<SettingValue>',num2str(iaf),':', num2str(HTF),'</SettingValue> \n');
fname = strcat(p,'..\Frequency_Selector.txt');
ParticipantXX = fopen(fname,'w');
fprintf(ParticipantXX,'<OpenViBE-SettingsOverride> \n');
fprintf(ParticipantXX,sett);
fprintf(ParticipantXX,'</OpenViBE-SettingsOverride>');
fclose(ParticipantXX);

% Write LTF, IAF and HTF to file
sett = strcat(' ltf =  ',num2str(LTF),'\n iaf =  ',num2str(iaf),'\n htf =  ',num2str(HTF));
fname = strcat(p,'NF3_info_LTF_IAF_FTF_.txt');
ParticipantXX = fopen(fname,'w');
fprintf(ParticipantXX,sett);
fclose(ParticipantXX);

fullName = strcat(p,fileinp);
fullName(strfind(fullName,'\'))='/';
sett = strcat('\t<SettingValue>',fullName,'</SettingValue>');
fname = strcat(p,'NF1_read_calib.txt');
CalibNameFile = fopen(fname,'w');
fprintf(CalibNameFile,'<OpenViBE-SettingsOverride> \n');
fprintf(CalibNameFile, '%s \n', sett);
fprintf(CalibNameFile,'</OpenViBE-SettingsOverride>');
fclose(CalibNameFile);
