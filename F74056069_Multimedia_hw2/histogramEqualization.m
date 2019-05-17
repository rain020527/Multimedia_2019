function [histEqImg] = histogramEqualization(firstImgGray)
    [height, width, numOfColor] = size(firstImgGray);
    histogram = zeros(1,256);   % Initialize image's histogram (grayscale 1~256)
    cdf = zeros(1,256); % Initialize cumulative distribution function (grayscale 1~256)
    histEq = zeros(1,256);   % Initialize image's histogram equalization (grayscale 1~256)
    
    % Calculate histogram 
    for graylevel = 0:255
        for i = 1:height
            for j = 1:width
                if firstImgGray(i, j)  == graylevel
                    histogram(graylevel+1) = histogram(graylevel+1) + 1;
                end
            end
        end
    end
    
    % Cumulative distribution function
    for graylevel = 1:256
        for i = 1:graylevel
             cdf(graylevel) = cdf(graylevel) + histogram(i);
        end
    end
    
    
    % Calculate histogram equalization
    cdfmin = min(cdf);
    for i = 1:256
        histEq(i) = round((cdf(i)-cdfmin) / ((height * width)-cdfmin) * 255);
    end
    
    % Apply the histogram equalization to the image
    for i = 1:height
        for j = 1:width
            histEqImg(i, j) = uint8(histEq(firstImgGray(i,j)+1));
        end
    end