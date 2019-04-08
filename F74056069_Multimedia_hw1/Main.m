% Clear and close all previous data
close all;
clear;
clc;
figure(2);
% Open audio file
filePath = "sample_1.wav";
[y, Fs] = audioread(filePath);   % Get audio sample data & sample rate
info = audioinfo(filePath);  % Get audio info

% Set frame length & overlap length
frameLength = 20;
overlapLength = 10;

% Plot waveform of audio file
subplot(5, 1, 1);
% Plot the waveform according to the bitpersample, also denormalize it
[t, bitSample] = Waveform(y, Fs, info);
waveform = plot(1:1800, bitSample(1:1800));
title("Waveform");
xlabel("Time(s)");
ylabel("Audio Data(" + info.BitsPerSample + " bits)"); 

% Plot energy contour
subplot(5, 1, 2);
[t, energy] = Energy(bitSample, Fs, info, frameLength, overlapLength);
plot(t, energy);
title("Energy contour");
xlabel("Time(s)");
ylabel("Energy(dB)"); 

% Plot zero-crossing rate contour
subplot(5, 1, 3);
[t, zeroCrossingRate] = ZeroCrossingRate(y, Fs, info, frameLength, overlapLength);
plot(t, zeroCrossingRate);
title("Zero-crossing rate contour");
xlabel("Time(s)");
ylabel("Rate"); 

% Plot pitch contour
subplot(5, 1, 4);
% Tau = 30;
% [t, pitch] = Pitch(y, Fs, info, frameLength, Tau);
% plot(1:1800, pitch(1:1800))
% [c, lags] = xcorr(y(1:1800),y(1:1800));
% plot(lags, c);
acf = autocorr(y(1:1800));
plot(acf);
title("Pitch contour");

% Plot end point detection
endplot = subplot(5, 1, 5);
[frontEnd, backEnd] = EndPointDetection(y, Fs, info, frameLength, overlapLength, energy, zeroCrossingRate);
hold on;
copyobj(waveform, endplot);
line([frontEnd, frontEnd], [2^(info.BitsPerSample-1), -2^(info.BitsPerSample-1)], 'Color',[1 0 0]);
line([backEnd, backEnd], [2^(info.BitsPerSample-1), -2^(info.BitsPerSample-1)], 'Color',[1 0 0]);
hold off;
title("End point detection");
xlabel("Time(s)");
ylabel("Audio Data(" + info.BitsPerSample + " bits)"); 