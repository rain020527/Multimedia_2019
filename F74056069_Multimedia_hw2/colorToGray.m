function [grayImg] = colorToGray(colorImg)
    % Get the height, width, number of color stack of this color img
    [height, width, numOfColor] = size(colorImg);
    % Initialize the grayImg with colorImg's size
    %grayImg = zeros(height, width);
    for i = 1:height
        for j = 1:width        
            grayImg(i, j) = round(colorImg(i, j, 1)*0.299 + colorImg(i, j, 2)*0.587 + colorImg(i, j, 3)*0.114);
        end
    end
end