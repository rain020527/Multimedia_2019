function [t, pitch] = Pitch(y, Fs, info, frameLength, overlapLength)
frameSize = floor(frameLength*Fs/1000); % Setting frame time to 20ms, so we'll have 882 sample in one frame
frameOverlap = floor(overlapLength*Fs/1000); % Setting frame overlap to 10 ms, so two consecutive frames will have 15 ms overlap
Tau = frameSize-1;  % Setting Tau to 

% Calculate hamming window of frameSize
w = zeros(1, frameSize);  % Store w(n)
for n = 0:1:frameSize-1
    w(n+1) = 0.54-0.46*cos(2*pi*n/(frameSize-1));
end

pitch = []; % Store pitch
frameAcr = [];  % Store local frame autocorrelation
temp = 0;
for i = 1:(floor(info.TotalSamples/frameOverlap)-floor(frameSize/frameOverlap)) % loop through all the frame with overlap
    for k = 0:Tau  
        for m = (((i-1)*frameOverlap)+1):(((i-1)*frameOverlap)+frameSize-k) % loop through elements in each frame
            temp = temp + y(m)*w(mod(m-1, frameSize)+1)*y(m+k)*w(mod(m+k-1, frameSize)+1); % sum R(n)
        end
        frameAcr(k+1) = temp;   % store R(n)
        temp = 0;
    end
    peaks = findpeaks(frameAcr);    % get all the peak of acr wave in this frame
    max2 = max(peaks(peaks<max(peaks)));    % get second peak of acr wave in this frame
    pitch(i) = find(frameAcr==max2);    % get this peak's index, it's the pitch
    frameAcr = [];
end


% Calculate the time duration for energy with frame and overlap
t = 0:((info.Duration)/length(pitch)):(info.Duration-1/Fs);
end