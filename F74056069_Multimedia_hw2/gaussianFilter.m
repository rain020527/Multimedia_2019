function [blurImg] = gaussianFilter(firstImgGray)
    % Calculate the guassian blur matrix
    gaussianSize = 7;
    sigma = 2;
    for i = 1:gaussianSize
        for j = 1:gaussianSize
            u = i-ceil(7/2);
            v = j-ceil(7/2);
            gaussianMatrix(i, j) = (1/(2*pi*(sigma^2)))*exp(-(u^2+v^2)/(2*(sigma^2)));
        end
    end

    [height, width, numOfColor] = size(firstImgGray);

    % Accept the gasssian blur to the gray image
    for i = 1:height
        for j = 1:width
            temp = 0;
            for m = 1:gaussianSize   
                for n = 1:gaussianSize
                    u = m-ceil(7/2);
                    v = n-ceil(7/2);
                    if ((i+u <= height && i+u > 0) && (j+v <= width && j+v > 0))
                        temp = temp + gaussianMatrix(m, n)*firstImgGray(i+u, j+v);  
                    end
                end
            end
            blurImg(i, j) = temp;
        end
    end
end