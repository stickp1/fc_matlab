function data = gdf_OV_generate(spec, category)

% GDF generator for OpenVibe
%
% Generate gdf file for OpenVibe. Two parameters required (spec and category)
%
% The category should be a string of the following:
%   category        = 'volume_conduction'
%                     'sample_size_bias'
%                     'common_reference'
%                     'common input'
%
% If category = 'sample_size_bias', spec should contain:
%   spec.ntrials     = 5, 10, 50, 100, 500
%   spec.save        = true, false (true saves the file in .gdf)
%       spec.name    = name of .gdf to be saved
%
% If category = 'common_reference', spec should contain:
%   spec.conn        = 0, 1 (1 for connectivity, 0 for no connectivity)
%   spec.save        = true, false (true saves the file in .gdf)
%       spec.name    = name of .gdf to be saved
%
% If category = 'common_input', spec should contain:
%   spec.case        = 1, 2, 3 (corresponding to 3 cases of Bastos & Schoffelen 2016)*
%   spec.save        = true, false (true saves the file in .gdf)
%       spec.name    = name of .gdf to be saved
%
%
% * case 1 is 3 observed nodes where 3->1 and 3->2 at lags 1 and 2
%   case 2 is 2 observed nodes (1, 2) where 3->1 at lag 1 and 3->2 at lag 2
%   case 3 is case 2 but all nodes are observed
%
% If category = 'volume conduction', spec should contain:
%   spec.save       = true, false (true saves the file in .gdf)
%       spec.name   = name of .gdf to be saved
%
%
%
%

switch category
    case 'sample_size_bias'
        cfg = [];
        cfg.method = 'ar';
        cfg.ntrials = spec.ntrials;
        cfg.triallength = 0.5;
        cfg.fsample = 200;
        cfg.nsignal = 2;
        cfg.bpfilter = 'no';
        cfg.blc = 'yes';
        cfg.params(:,:,1) = [0.55 0.025;
            0.025 0.55];
        cfg.params(:,:,2) = [-0.8 -0.1;
            -0.1 -0.8];
        cfg.noisecov = [1 0.3;
            0.3 1];
        data = ft_connectivitysimulation(cfg);
        %name = strcat('sample_size_bias_n',num2str(spec.ntrials),'.gdf');
    case 'common_reference'
        cfg = [];
        cfg.method = 'linear_mix'; %apply a linear mixture of various components into data
        cfg.ntrials = 1000; %simulate 1000 trials
        cfg.triallength = 1; %each trial is 1 second
        cfg.fsample = 1000; %sampling rate is 1000 Hz
        cfg.nsignal = 2; %simulate 2 unipolar channels
        cfg.bpfilter = 'yes';
        cfg.bpfreq = [35 55 ]; %apply a band-pass filter between 35 and 55 Hz to the white noise
        cfg.blc = 'yes'; %remove the mean of each trial
        if spec.conn
            a = [4 1;2 3];
        else
            a = [0 0; 0 0];
        end
        cfg.mix = [[0 1 1; 1 0 1] a];
        cfg.delay = [0 0 0 0 0; 0 0 0 0 0] ;
        cfg.absnoise = 1; %the variance that will be added to each channel after linear mixing
        data = ft_connectivitysimulation(cfg);
    case 'common_input'
        cfg = [];
        cfg.method = 'ar';
        cfg.triallength = 1;
        cfg.fsample = 200;
        cfg.nsignal = 3;
        cfg.noisecov = [1 0 0; 0 1 0; 0 0 1];
        switch spec.case
            case 1
                cfg.ntrials = 200;
                cfg.params(:,:,1) = [0.55 0 0.25;
                    0 0.55 0.25;
                    0 0 0.55]; %off-diagonal entries simulate 3->1 and 3->2 influence at the first time delay
                cfg.params(:,:,2) = [-0.8 0 -0.1;
                    0 -0.8 -0.1;
                    0 0 -0.8]; %off-diagonal entries simulate 3->1 and 3->2 influence at the second time delay
                data = ft_connectivitysimulation(cfg);
            case 2
                cfg.ntrials = 500;
                cfg.params(:,:,1) = [0.55 0 0.25;
                    0 0.55 0;
                    0 0 0.55]; %off-diagonal entry simulates 3->1 at the first time delay
                cfg.params(:,:,2) = [-0.8 0 0;
                    0 -0.8 -0.1;
                    0 0 -0.8];
                cfg.absnoise = 0;
                data = ft_connectivitysimulation(cfg);
                cfg.nsignal = 2;
                %Remove the third node from the data to simulate a situation where we do
                %not observe the source of common input (Figure 9 D-F)
                cfg2 = [];
                cfg2.channel = data.label(1:2);
                data = ft_selectdata(cfg2, data);
            case 3
                cfg.ntrials = 200;
                cfg.params(:,:,1) = [0.55 0 0.25;
                    0 0.55 0;
                    0 0 0.55]; %this simulates 3->1 at the first time delay
                cfg.params(:,:,2) = [-0.8 0 0;
                    0 -0.8 -0.1;
                    0 0 -0.8]; %this simulates 3->2 at the second time delay
                data = ft_connectivitysimulation(cfg);
        end
    case 'volume-conduction'
        cfg = [];
        cfg.method = 'ar';
        cfg.ntrials = 500;
        cfg.triallength = 1;
        cfg.fsample = 200;
        cfg.nsignal = 50;
        cfg.params(:,:,1) = diag(0.55*ones(cfg.nsignal,1));
        cfg.params(:,:,2) = diag(-0.8*ones(cfg.nsignal,1));
        cfg.noisecov = diag(0.05*ones(cfg.nsignal,1));
        cfg.noisecov(16,16) = 1;
        cfg.noisecov(35,35) = 1;
        data = ft_connectivitysimulation(cfg);
        montage = [];
        montage.labelorg = data.label;
        montage.labelnew = data.label;
        montage.tra = convn(eye(50),hanning(31),'same');
        data = ft_apply_montage(data, montage);
end

if spec.save
    hdr.Fs = cfg.fsample;
    hdr.nChans = cfg.nsignal;
    hdr.label = data.label;
    matrix3D = cat(2,data.trial{:});
    ft_write_data(spec.name, matrix3D, 'header',hdr,'dataformat', 'gdf');
end
