
clear; clc; close all;


%% Parameter Sampling
Fs = 15;
Ts = 1/Fs;
t = (0:Ts:0.001);


%% Data
%fid = fopen('synthetic_seismic.dat','w');
x = load("synthetic_seismic.dat")
x = x(:);
clc;
%x = synthetic_seismic;

%% Quantizer parameters
m =[13,18,25,31];
bits = m;
L = [2^m(1,1), 2^m(1,2), 2^m(1,3), 2^m(1,4)];
for index = 1:4
    fprintf("%d ",m(1,index));
    fprintf("%d\n",L(1,index));
end
fprintf("\n");
xmax = max(abs(x));
xmin = -xmax;
fprintf("Max : %.3f \nMin : %.3f \n",xmax,xmin);
Interval = xmax-xmin
delta = [Interval/L(1,1),Interval/L(1,2),Interval/L(1,3),Interval/L(1,4)];
fprintf("Delta is: ");
for index = 1:4
fprintf("%g",delta(1,index));
end
fprintf("\n");

%% Quantization Process
indexQuantization = floor((x - xmin)./delta(1,:));
fprintf("%g\n",delta);
fprintf('%g ',indexQuantization(1,:)); % Index quant sample 1 / row ke 1 
xq = xmin + (indexQuantization .* delta);


%% Quantization error

e = x - xq;

%% 6. Compute SNR
SNR = 10*log10(sum(x.^2) ./ sum(e.^2));

%% 7. Display Results
fprintf('Quantization Step (Delta) = %.g V\n', delta(1,:));
fprintf('Measured SNR = %.2f dB\n', SNR);

% Theoretical SNR
SNR_theory = 6.02*m + 1.76;
fprintf('Theoretical SNR ≈ %.2f dB\n', SNR_theory);

% Error of SNR
SNR_error = SNR - SNR_theory;
fprintf('Error in SNR ≈ %.2f dB\n', SNR_error);
SNR_error_percentage = 100 .* abs(SNR_error/SNR);
fprintf("Percentage error = %.2f % \n",SNR_error_percentage);

%% ===================== FIGURE 1 =====================
figure('Name','Original and Quantized Signals','NumberTitle','off');

total1 = 1 + length(m);   % 1 original + quantized

subplot(total1,1,1)
plot(x,'k');
title('Original Signal');
ylabel('Amplitude');
grid on;

for i = 1:length(m)
    subplot(total1,1,i+1)
    plot(x,'k'); hold on;
    plot(xq(:,i),'r');
    title([num2str(m(i)),'-bit Quantized']);
    ylabel('Amplitude');
    legend('Original','Quantized');
    grid on;
end

xlabel('Sample Index');
sgtitle('Original vs Quantized Signals');

%% ===================== FIGURE 2 =====================
figure('Name','Quantization Error','NumberTitle','off');

for i = 1:length(m)
    subplot(length(m),1,i)
    plot(e(:,i));
    title([num2str(m(i)),'-bit Quantization Error']);
    ylabel('Error');
    grid on;
end

xlabel('Sample Index');
sgtitle('Quantization Error for Each Bit Level');

%% ===================== FIGURE 3 =====================
figure('Name','SNR vs Number of Bits','NumberTitle','off');

plot(m,SNR,'o-','LineWidth',2);
hold on;
plot(m,SNR_theory,'--','LineWidth',2);

xlabel('Number of Bits');
ylabel('SNR (dB)');
title('SNR vs Number of Bits');
legend('Measured','Theoretical');
grid on;
