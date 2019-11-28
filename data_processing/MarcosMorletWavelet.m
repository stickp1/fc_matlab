% adapted function from marcos toolbox
% create the morlet wavelet

function GfT=MorletWavelet(F,R,Fs,TL)
% Computes the morlet wavelet with frequency F, 6*Tsigma length and 
% "wavelet factor" R, centered at time t. 
% Example: R = 7;

Sf	= F/R;
St  = 1/(2*pi*Sf);
if mod(TL,2)
    T   = [(0 : 1/Fs : TL/2/Fs) (-TL/2/Fs : 1/Fs : -1/Fs)];
else
    T   = [(0 : 1/Fs : TL/2/Fs) (-TL/2/Fs+1/Fs : 1/Fs : -1/Fs)];
end
A   = 1/sqrt(St*sqrt(pi));
GfT = A*exp(-T.^2./(2*St^2)).*exp(2*1i*pi*F*T);
end