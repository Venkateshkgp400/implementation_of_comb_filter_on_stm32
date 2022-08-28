%% MATLAB code for recording AC noise
Fs = 16000 ;
nBits = 16 ;
nChannels = 1 ;
ID = -1; % default audio input device
recObj = audiorecorder(Fs,nBits,nChannels,ID);
disp('Start speaking.')
recordblocking(recObj,5);
disp('End of Recording.');
play(recObj);
voice = getaudiodata(recObj);
audiowrite('Ac.wav', voice, Fs)
[noise, Fsn] = audioread('Ac.wav');
%fft of noise
nf = 2^(nextpow2(length(noise)));
f = Fsn/2*linspace(0,1,nf/2+1);
N = fft(noise,nf)/nf;
figure
plot(f,abs(N((1:nf/2+1)))*2);
title('input');
xlim([0 1000])
figure
pwelch(input);
title("noise spectral density")