function [edgeImg] = sobel(histEqImg)
    
    [height, width, numOfColor] = size(histEqImg);
    % Setting sobel kenel x and y
    kernelX = [-1 0 1;
               -2 0 2;
               -1 0 1];
    kernelY = [-1 -2 -1;
               0 0 0;
               1 2 1];
    % Initialize magnitude 
    mag(1:height, 1:width) = 0.0;
    % Change histogram image to double precision, for later calculation
    histEqImg = double(histEqImg);
    % Calculate by sobel operator
    for i = 1:height
        for j = 1:width
            Gx = 0; Gy = 0;
            for m = -1:1
                for n = -1:1
                    if ((i+m > 0 && i+m <= height) && (j+n > 0 && j+n <= width))
                        % Calculate x-direction derivative
                        Gx = Gx + kernelX(m+2, n+2) * histEqImg(i+m, j+n);
                        % Calculate y-direction derivative
                        Gy = Gy + kernelY(m+2, n+2) * histEqImg(i+m, j+n);
                    end
                end
            end
            % Get the Gradient
            mag(i, j) = sqrt(Gx^2 + Gy^2);
        end
    end
    edgeImg = uint8(mag);
end