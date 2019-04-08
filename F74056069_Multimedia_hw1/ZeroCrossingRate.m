function [t, zeroCrossingRate] = ZeroCrossingRate(y, Fs, info, frameLength, overlapLength)
frameSize = floor(frameLength*Fs/1000); % Setting frame time to 20ms, so we'll have 882 sample in one frame
frameOverlap = floor(overlapLength*Fs/1000); % Setting frame overlap to 10 ms, so two consecutive frames will have 15 ms overlap

% Calculate window of frameSize
w = 1/(2*frameSize);  % Store w(n), in our calculation will always be 1/2N

% Calculate the zerocrossing with frame and overlap
temp = 0;
zeroCrossingRate = zeros(1, (floor((length(y))/frameOverlap)-floor(frameSize/frameOverlap)));
for i = 1:(floor(info.TotalSamples/frameOverlap)-floor(frameSize/frameOverlap))
    for j = (((i-1)*frameOverlap)+2):(((i-1)*frameOverlap)+frameSize)   % For loop sum zerocrossing rate with overlap
        temp = temp + abs(sign(y(j))-sign(y(j-1)))*w;
    end
    zeroCrossingRate(i) = temp;
    temp = 0;
end

% Calculate the time duration for zerocrossing with frame and overlap
t = 0:((info.Duration)/length(zeroCrossingRate)):(info.Duration-1/Fs);

end