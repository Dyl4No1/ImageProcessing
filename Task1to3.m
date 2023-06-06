% MATLAB script for Assessment 1
% Task 1: Preprocessing ---------------------------
clear; close all; clc;

% Step-1: Load input image
I = imread('IMG_01.jpg');
figure;
imshow(I);
title('Step-1: Load input image');
axis on

% Step-2: Conversion of input image to grey-scale image
Igray = rgb2gray(I);
figure;
imshow(Igray);
title('Step-2: Conversion of input image to greyscale (1512x2016)');
axis on

% Step-3: Resizing the grayscale image using bilinear interpolation
sF = 0.5;
hfIgray = imresize(Igray, sF, 'bilinear');
figure, imshow(hfIgray)
title('Step-3: Resizing grayscaled Image by 0.5x (756x1008)')
axis on

% Step-4: Generating histogram for the resized image
figure, imhist(hfIgray, 255)
title('histogram for resized 0.5x image')
xlabel('RNG Value')
ylabel('Number of Entries')
axis on

% Step-5: Producing binarised image
bwIgray = imbinarize(hfIgray, 'adaptive','ForegroundPolarity', 'bright', 'Sensitivity', 0.2 );
%for report: hit+miss morphology to get swan?
figure, imshowpair(hfIgray, bwIgray, 'montage')

% for report: (delete when uploading)
subplot(2,2,1)
imshow(hfIgray)
title('Resized Grayscale Image')
axis on

subplot(2,2,2)
imhist(hfIgray)
title('Histogram of the Resized Grayscale Image')

subplot(2,2,3)
imshow(bwIgray)
title('Binarized Grayscaled Image')
axis on

%---------------------------------------------------------------
% Task 2: Edge Detection -----------------------

bin2Sobel = edge(bwIgray, "sobel");
bin2Canny = edge(bwIgray, "canny");
figure;
    imshowpair(bin2Sobel, bin2Canny, "montage");
    title('sobel left, canny right')

%---------------------------------------------------------------
% Task-3: Simple Segmentation -----------------------

binComps = bwconncomp(bwIgray);

baseMatrix = false(size(bwIgray));
%conncomp feature number for swan parts, make white
baseMatrix(binComps.PixelIdxList{96}) = true;
baseMatrix(binComps.PixelIdxList{99}) = true;
%final output
figure;
imshow(baseMatrix)
title('baseMatrix')

