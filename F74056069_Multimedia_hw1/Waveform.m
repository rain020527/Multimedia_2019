function [t, bitSample] = Waveform(y, Fs, info)
t = 0:(1/Fs):(info.Duration-1/Fs);  % Set time duration to audio file's length
% Denormalize the value of sample
bitSample = zeros(1, length(y));
switch info.BitsPerSample
    case 8 
        bitSample = y.*(2^7)+(2^7);     % 0 <= y <= 255 (int8)
    case 16 
        bitSample = y.*(2^15);     % -32768 <= y <= +32767 (int16)
    case {24, 32}
        bitSample = y.*(2^31);  % -2^31 <= y <= 2^31¡V1 (int32)
    otherwise
        bitSample = y;
end
end