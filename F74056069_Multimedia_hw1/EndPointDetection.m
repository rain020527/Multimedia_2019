function [frontEnd, backEnd] = EndPointDetection(y, Fs, info, frameLength, overlapLength, energy, zeroCrossingRate)
% set silence interval to 100 ms
intervalSilence = 100;
frameNumber = length(energy);
soundStart = floor((intervalSilence-(frameLength-overlapLength))/overlapLength);
soundEnd = frameNumber - soundStart;

% Take second 100ms to set Tu, Tl, Tzc
Tu = max(energy(soundStart:soundStart*2));
Tl = median(energy(soundStart:soundStart*2));
Tzc = max(zeroCrossingRate(soundStart:soundStart*2));

%% Calculate front end point

frontEnd = 0;
N = 0;
% Get initial N by Tu
for i = 1:frameNumber
    if energy(i) > Tu
        N = i;
        break;
    end
end
% Adjust N by Tl
for i = N:-1:1
    if energy(i) < Tl
        N = i;
        break;
    end
end
% Adjust N by Tzc
for i = N:-1:1
    if zeroCrossingRate(i) < Tzc
        N = i;
        break;
    end
end
frontEnd = N/frameNumber*info.Duration;

%% Calculate back end point
backEnd = 0;
N = 0;
% Get initial N by Tu
for i = soundEnd:-1:1
    if energy(i) > Tu
        N = i;
        break;
    end
end
% Adjust N by Tl
for i = N:soundEnd
    if energy(i) > Tl
        N = i;
        break;
    end
end
% Adjust N by Tzc
for i = N:soundEnd
    if zeroCrossingRate(i) < Tzc
        N = i;
        break;
    end
end
backEnd = N/frameNumber*info.Duration;

end