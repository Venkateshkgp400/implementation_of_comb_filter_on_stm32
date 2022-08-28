%% MATLAB code for recording voice signal
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
audiowrite('voice.wav', voice, Fs)
[input, Fsi] = audioread('voice.wav');
input = 1.5*input;
%fft of input
nf = 2^(nextpow2(length(input)));
f = Fsi/2*linspace(0,1,nf/2+1);
S = fft(input,nf)/nf;
figure
plot(f,abs(S((1:nf/2+1)))*2);
title('input');
xlim([0 1000])
figure
pwelch(input);
title("input spectral density")