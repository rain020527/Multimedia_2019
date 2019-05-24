close all;
clear;
clc;
path = './images/';
type = {'*.jpg', '*.png', '*.jpeg', '*.bmp'};
% Loop check if this type of file exist in folder
for i = 1:length(type)
    if (~isempty(dir(strcat(path, type{i}))))
        imgList = dir(strcat(path, type{i}));
        % This type of files exist, loop get all of files of this type
        for i = 1:length(imgList)
            imgName = imgList(i).name;
            imgPath = strcat(path, imgName);
            img = imread(imgPath);
            
            figure;
            % Show original image
            subplot(2,2,1);
            imshow(img);
            title('Original image');
            % Change image to grayscale
            grayImg = colorToGray(img);
            % Apply Gaussian filter to image
            blurImg = gaussianFilter(grayImg);
            % Show image after gaussian filter
            subplot(2,2,2);
            imshow(blurImg);
            title('Image after Gaussian filter');
            % Apply histogram equlization to image
            histEqImg = histogramEqualization(grayImg);
            % Show image after histogram equlization
            subplot(2,2,3);
            imshow(histEqImg);
            title('Image after histogram equalization');
            % Apply sobel operator to find image's edge
            edgeImg = sobel(histEqImg);
            % Show image after sobel opertator
            subplot(2,2,4);
            imshow(edgeImg);
            title('Image after Sobel operator');
        end
    end
end






