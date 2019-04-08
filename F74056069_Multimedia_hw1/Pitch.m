function [t, pitch] = Pitch(y, Fs, info, frameLength, Tau)
frameSize = floor(frameLength*Fs/1000); % Setting frame time to 20ms, so we'll have 882 sample in one frame

% Calculate hamming window of frameSize
w = zeros(1, frameSize);  % Store w(n)
for n = 0:1:frameSize-1
    w(n+1) = 0.54-0.46*cos(2*pi*n/(frameSize-1));
end
pitch = [];
temp = 0;
for i = 1:floor(info.TotalSamples/frameSize)
    for j = (((i-1)*frameSize)+1):((i*frameSize)-Tau)   % For loop sum energy with overlap
        for k = 1:Tau
            temp = temp + y(j)*w(j-(i-1)*frameSize)*y(j+k)*w(j-(i-1)*frameSize+k); 
        end
        pitch(j) = temp;
        temp = 0;
    end
end

% Calculate the time duration for energy with frame and overlap
t = 0:((info.Duration)/length(pitch)):(info.Duration-1/Fs);
end