%% PROBLEM 2.31
% Quantization of 100 Hz sinusoidal signal using 6-bit bipolar quantizer
% Sampling rate = 8000 Hz
% Range = -5 V to 5 V

clear; clc; close all;

%% 1. Parameter Sampling
fs = 8000;              % Sampling frequency (Hz)
Ts = 1/fs;              % Sampling period
t = 0:Ts:0.05;          % Time vector (50 ms duration)

%% 2. Generate Original Signal
A = 4.5;                % Amplitude
f0 = 100;               % Signal frequency (Hz)
x = A * sin(2*pi*f0*t); % Original signal

%% 3. Quantizer Parameters
m = 6;                  % Number of bits
L = 2^m;                % Number of quantization levels
xmin = -5;              % Minimum input voltage
xmax = 5;               % Maximum input voltage
Delta = (xmax - xmin)/L; % Quantization step size

%% 4. Quantization Process
% Convert signal to level index
index = round((x - xmin)/Delta);

% Saturation (prevent overflow)
index(index < 0) = 0;
index(index > L-1) = L-1;

% Convert back to quantized voltage
xq = xmin + index * Delta;

%% 5. Quantization Error
e = x - xq;

%% 6. Compute SNR
SNR = 10*log10(sum(x.^2) / sum(e.^2));

%% 7. Display Results
fprintf('Quantization Step (Delta) = %.6f V\n', Delta);
fprintf('Measured SNR = %.2f dB\n', SNR);

% Theoretical SNR
SNR_theory = 6.02*m + 1.76;
fprintf('Theoretical SNR ≈ %.2f dB\n', SNR_theory);

%% 8. Plot Results
figure;
plot(t, x, 'b', 'LineWidth', 1.2);
hold on;
stairs(t, xq, 'r', 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Amplitude (V)');
title('Original vs Quantized Signal');
legend('Original Signal','Quantized Signal');
grid on;

figure;
plot(t, e);
xlabel('Time (s)');
ylabel('Error (V)');
title('Quantization Error');
grid on;