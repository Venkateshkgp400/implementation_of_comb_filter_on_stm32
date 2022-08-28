Fs=4000;
dt = 1/Fs;
t = 0:dt:0.1115-dt;
f1 = 100; f2 = 500; f3 = 1000; f4 = 1500;
x =
sin(2*pi*f1*t)+sin(2*pi*f2*t)+sin(2*pi*f3*t)+sin(2*pi*f4*
t);
%%
%notch filter design
Ts=1/Fs;
M=256;%order
N=M/2+1;%no of filter coefficients
%notch width
alfa=5*2*pi*Ts;
notch_freq = [100 1000 1500];
notch_w = notch_freq * 2*pi*Ts;
num_of_freq = length(notch_freq);
interval_len = 2+ 2*length(notch_w);
interval = [];
interval(1) = 0;
flag = 1;
for m = 2:2:(interval_len-1)
a = notch_w(flag) - alfa/2;
interval(m) = a;
b = notch_w(flag) + alfa/2;
interval(m+1) = b;
flag = flag + 1;
end
interval(interval_len) = pi;
%FInd the P matrix
P=zeros(N);
q=zeros(N,1);
for i = 1:2:(2*num_of_freq)
%part1
dw=pi/300;%freq domain sampling
w=[interval(i):dw:interval(i+1)]';
nM=[0:N-1]';
U=cos(nM*w');
for n1=1:N
for n2=1:N
P(n1,n2)=P(n1,n2)+trapz(U(n1,:).*U(n2,:))*dw;
end
end
q=q-2*trapz(U,2)*dw;
%part2
dw=pi/500;
W=10000;%Weight of Notch part
epsi=0.001;
w=[interval(i+1):dw:interval(i+2)]';
nM=[0:N-1]';
U=cos(nM*w');
for n1=1:N
for n2=1:N
P(n1,n2)=P(n1,n2)+W*trapz(U(n1,:).*U(n2,:))*dw;
end
end
q=q-2*W*epsi*trapz(U,2)*dw;
end
%part3
dw=pi/300;
w=[interval(interval_len-1):dw:pi]';
nM=[0:N-1]';
U = cos(nM*w');
for n1=1:N
for n2=1:N
P(n1,n2)=P(n1,n2)+trapz(U(n1,:).*U(n2,:))*dw;
end
end
q=q-2*trapz(U,2)*dw;
%figure(1);
%plot(q)
%solve for minimization
a=-P\(q/2);
for k=1:M/2-1
h(M/2-k)=a(k+1)/2;
h(M/2+k)=a(k+1)/2;
end
h(M/2)=a(1);
%%
y = conv(x,h);
%%
nf = 2^(nextpow2(length(x)));
f = Fs/2*linspace(0,1,nf/2+1);
X = fft(x,nf)/nf;
figure
subplot(211)
plot(f,abs(X((1:nf/2+1)))*2);
%xlim([0 500])
title('input spectrum')
nf = 2^(nextpow2(length(y)));
f = Fs/2*linspace(0,1,nf/2+1);
Y = fft(y,nf)/nf;
subplot(212)
plot(f,abs(Y((1:nf/2+1)))*2);
%xlim([0 500])
title('output spectrum')
%%
figure
subplot(211)
F=linspace(0,Fs/2,2000);
H=freqz(h,1,F,Fs);
plot(F,abs(H));
xlabel('Freqeuncy')
ylabel('Magnitude')
title('Freq Response')
grid on
subplot(212)
plot (F, phase(H));
title('Phase Response')
%%
b = floor(log2(2^15-1/max(abs([x h]))));
h_fix = sfi(h,16,b);
x_fix = sfi(x,16,b);
%%
figure
subplot(211)
F=linspace(0,Fs/2,2000);
H_fix=freqz(double(h_fix),1,F,Fs);
plot(F,abs(H_fix));
xlabel('Freqeuncy')
ylabel('Magnitude')
title('Freq Response(fixed point)')
grid on
subplot(212)
plot (F, phase(H_fix));
title('Phase Response(fixed point)')
%%
figure
subplot(211)
plot(x)
title('input signal')
subplot(212)
plot(x_fix)
title('input signal(fixed point)')
file1=fopen('h.txt', 'w');
for i=1:1:length(h_fix)
num=h_fix(i);
if i<length(h_fix)
fprintf(file1, '0x%s, ', hex(num));
else
fprintf(file1, '0x%s', hex(num));
end
end
fclose(file1);
%%
file2=fopen('x.txt', 'w');
for i=1:length(x_fix)
si=x_fix(i);
if i<length(x_fix)
fprintf(file2, '0x%s, ', hex(si));
else
fprintf(file2, '0x%s', hex(si));
end
end
fclose(file2);