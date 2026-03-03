
%Example 2.14
clear all; close all
disp('load speech: We');
[sig, fs] = audioread('we.mp3');
sig = sig(:,1); % ambil satu channel kalau stereo
% save we.dat sig -ascii
% load we.dat % Load speech data at the current folder
% sig = we; % Provided by the instructor
fs=8000; % Sampling rate
lg=length(sig); % Length of signal vector
T=1/fs; % Sampling period

t=[0:1:lg-1]*T; % Time instants in second
sig=4.5*sig/max(abs(sig)); % Normalizes speech in the range from 4.5 to 4.5
Xmax = max(abs(sig)); % Maximum amplitude
Xrms = sqrt( sum(sig .* sig) / length(sig)) % RMS value
disp('Xrms/Xmax')
k=Xrms/Xmax
disp('20*log10(k)¼>');
k = 20*log10(k)
bits = input('input number of bits ¼>');
lg = length(sig);

L = 2^bits;
xmin = -5;
xmax = 5;
delta = (xmax - xmin)/L;

Index = floor((sig - xmin)/delta);
Index(Index < 0) = 0;
Index(Index > L-1) = L-1;

qsig = xmin + delta*(Index + 0.5);

qerr = sig-qsig; %Calculate the quantized error
subplot(3,1,1);plot(t,sig);
ylabel('Original speech');title('we.dat: we');
subplot(3,1,2);stairs(t, qsig);grid
ylabel('Quantized speech')
subplot(3,1,3);stairs(t, qerr);grid
ylabel('Quantized error')
xlabel('Time (sec.)');axis([0 0.25 -1 1]);
disp('signal to noise ratio due to quantization noise')
snr(sig,qsig) % Signal to noise ratio in dB:
% sig ¼ original signal vector,
% qsig ¼quantized signal vector