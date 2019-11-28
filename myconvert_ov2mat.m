
% converts OV saved data+stim file pair to a .mat file

function myconvert_ov2mat(p,fileinp,fileout)
    inputOvFilename = strcat(p,fileinp);
    outputMatFilename = strcat(p,fileout);
% 	openvibeConvert = '"C:\Program Files (x86)\openvibe-2.0.1\openvibe-convert.cmd"';
	openvibeConvert = 	'"C:\ProgramFiles\openvibe-2.0.1\openvibe-convert.cmd"'; %COMPUTADOR EEGLAB
	csvFn = regexprep(inputOvFilename, '\.ov$', '\.csv');	
	stimFn = regexprep(inputOvFilename, '\.ov$', '\.csv\.stims\.csv');	

	cmd = sprintf('%s %s %s', openvibeConvert, inputOvFilename, csvFn);
    disp(cmd);
	system(cmd);
	
	data=readtable(csvFn,'delimiter',';');
	stims=readtable(stimFn,'delimiter',';');
	
	channelNames = data.Properties.VariableNames;

	data = table2array(data);
	stims = table2array(stims);
	sampleTime = data(:,1);
	samplingFreq = data(1,end);
	samples = data(:,2:end-1);
	channelNames = channelNames(2:end-1);
	
	save(outputMatFilename,'stims','sampleTime', 'samples', 'samplingFreq', 'channelNames');
	
	delete(csvFn);
	delete(stimFn);
   
    fprintf(1, '  Done converting \n');
	
end

