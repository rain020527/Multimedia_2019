function [t, energy] = Energy(y, Fs, info, frameLength, overlapLength)
frameSize = floor(frameLength*Fs/1000); % Setting frame time to 20ms, so we'll have 882 sample in one frame
frameOverlap = floor(overlapLength*Fs/1000); % Setting frame overlap to 10 ms, so two consecutive frames will have 15 ms overlap

% Calculate hamming window of frameSize
w = zeros(1, frameSize);  % Store w(n)
for n = 0:1:frameSize-1
    w(n+1) = 0.54-0.46*cos(2*pi*n/(frameSize-1));
end

% Calculate the energy with frame and overlap
temp = 0;
energy = zeros(1, (floor(info.TotalSamples/frameOverlap)-floor(frameSize/frameOverlap)));
for i = 1:(floor((length(y))/frameOverlap)-floor(frameSize/frameOverlap))
    for j = (((i-1)*frameOverlap)+1):(((i-1)*frameOverlap)+frameSize)   % For loop sum energy with overlap
        temp = temp + (y(j)*w(j-(i-1)*frameOverlap))^2; % (x(m)w(n-m))^2
    end
    energy(i) = 10*log10(temp);
    temp = 0;
end

% Calculate the time duration for energy with frame and overlap
t = 0:((info.Duration)/length(energy)):(info.Duration-1/Fs);

end