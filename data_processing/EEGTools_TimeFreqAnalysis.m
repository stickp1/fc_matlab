% Time frequency analysis based on marco's toolbox
% compute convolution of wavelet and signal in time doain
% using the multiplication of signal and wavelet in the frequency domain

function result = EEGTools_TimeFreqAnalysis(Signal,SamplingRate,fmin, fmax, FreqSmpCount, WaveletFactor)

disp('Time frequency analysis...')

yfactor         = (fmax/fmin)^(1/(FreqSmpCount-1)); % factor between logarithmic frequency ticks
vf              = fmin*(yfactor*ones(1,FreqSmpCount)) .^ (0:FreqSmpCount-1); % frequency ticks

SignalFT        = fft(Signal(1,:));
NFT             = length(SignalFT);
result          = zeros(length(vf),NFT);

for n = 1:length(vf) % wavelet transform
    Fwavelet = single(MarcosMorletWavelet(vf(n),WaveletFactor,SamplingRate,NFT));
    result(n,:)  = ifft(SignalFT.*fft(Fwavelet))./NFT;
end


