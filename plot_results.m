fs = 4000;
iplen = 446;
hlen = 255;
oplen = 700;
fileID = fopen('input_comb.bin', 'r');
mat1 = fread(fileID);
fclose(fileID);
signalin = zeros(1, iplen);
for i=1:iplen
if mat1(2*i) > 127
signalin(1, i) = mat1(2*i)-256;
signalin(1, i) = signalin(1, i) + mat1(2*i-
1)/256;
else
signalin(1, i) = mat1(2*i);
signalin(1, i) = signalin(1, i) + mat1(2*i-
1)/256;
end
end
fileID = fopen('output_comb.bin', 'r');
mat3 = fread(fileID);
fclose(fileID);
signal = zeros(1, oplen);
for i=1:oplen
if mat3(2*i) > 127
signal(1, i) = mat3(2*i)-256;
signal(1, i) = signal(1, i) + mat3(2*i-1)/256;
else
signal(1, i) = mat3(2*i);
signal(1, i) = signal(1, i) + mat3(2*i-1)/256;
end
end
figure
hold on;
plot(signalin);
title('Input signal');
hold off;
figure
hold on;
plot(signal);
title('Output signal');
hold off;
nf = 2^(nextpow2(length(signalin)));
f = fs/2*linspace(0,1,nf/2+1);
S = fft(signalin,nf)/nf;
figure
subplot(211)
plot(f,abs(S((1:nf/2+1)))*2);
%xlim([0 500])
title('input spectrum')
nf = 2^(nextpow2(length(signal)));
f = fs/2*linspace(0,1,nf/2+1);
YY = fft(signal,nf)/nf;
subplot(212)
plot(f,abs(YY((1:nf/2+1)))*2);
%xlim([0 500])
title('output spectrum')