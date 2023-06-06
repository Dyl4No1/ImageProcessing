% MATLAB script for Assessment Item-1
% Task 4: Robust Swan Recognition ----------------
clear; close all; clc;

% Read image the image
origImage = imread("IMG_05.JPG");
figure, imshow(origImage);
title('Read Image')

% Convert image to Greyscale
imGrayscale = rgb2gray(origImage);
figure, imshow(imGrayscale);
title('Convert image to Greyscale');

% Invert the image for enhancement and display
imComp = imcomplement(imGrayscale);
imReduceh = imreducehaze(imComp, 0.9, 'method', 'approxdcp');
figure, imshow(imComp);
title('Invert image for enhancing')
figure, imshow(imReduceh);
title('Reduce haze on image')

% Invert to obtain enhanced image
imEnh = imcomplement(imReduceh);
figure, imshow(imEnh);
title('Invert haze reduced image for enhancement')

% Binarise the enhanced image
oThresh1 = graythresh(imEnh); % Apply Otsu's threshholding method
imBinary = imbinarize(imEnh,'adaptive','ForegroundPolarity', 'Bright', 'Sensitivity', oThresh1); 
swanGT = imread("IMG_08_GT.JPG");
figure, imshow(imBinary);
title('Convert Greyscale image with imbinarise')
figure, imshow(swanGT);
title('Read the Ground Truth Swan image')

% Detect feature points
% generate SURF detection features : needs Computer Vision Toolbox
swanPoints = detectSURFFeatures(swanGT);
scenePoints = detectSURFFeatures(imBinary);

% show 100 strongest features for comparison
figure, imshow(swanGT);
title('find 100 strongest swan feature points')
hold on;
axis on;
plot(selectStrongest(swanPoints, 100));
%
figure, imshow(imBinary);
title('find 100 strongest scene feature points')
hold on;
axis on;
plot(selectStrongest(scenePoints, 100));

% Extract swan and scene feature descriptors
[swanFeatures, swanpoints] = extractFeatures(swanGT, swanPoints); 
[sceneFeatures, scenePoints] = extractFeatures(imBinary, scenePoints);
%

% compare feature descriptors
swanPairs = matchFeatures(swanFeatures, sceneFeatures);
% create variables 
swanPointsmatch = swanPoints(swanPairs(:,1),:); %find the locations of points for each image
scenePointsmatch = scenePoints(swanPairs(:,2),:); % ^^
% show features together
figure; showMatchedFeatures(swanGT, imBinary, swanPointsmatch, scenePointsmatch, 'montage');
title('Find point matches')

% Detect the swan in the scene
[tform, inlrIdx] = estgeotform2d(swanPointsmatch, scenePointsmatch, 'affine'); %% estimate transformation based on matching pairs
swanPointsinlier = swanPointsmatch(inlrIdx,:);
scenePointsinlier = scenePointsmatch(inlrIdx,:);
%
figure; showMatchedFeatures(swanGT, imBinary, swanPointsinlier, scenePointsinlier, 'montage'); % display side by side
title('detect swan in the scene')

% Task 5: Performance Evaluation ----------------- 
%import images (add into one array)
gt = imread("IMG_01_GT.JPG");
image = imread("IMG_01.JPG");

% binarize GT inputs (tried to iteratively assign and binarise images to
% compare whole set.
% for k = 1:length(Gt)
%     k.update = imbinarize(k,'adaptive','ForegroundPolarity', 'Bright', 'Sensitivity', oThresh1); 
% end

%convert regular image to grayscale for binarising
imtemp = rgb2gray(image);

%binarise both images
imBin1 = imbinarize(imtemp, 'adaptive','ForegroundPolarity', 'Bright', 'Sensitivity', oThresh1);
imGT1 = imbinarize(gt, 'adaptive','ForegroundPolarity', 'Bright', 'Sensitivity', oThresh1);

%another attempt at finding files based on their name.
% myDir = uigetdir; % get current directory
% files = dir(fullfile(myDir,'*.JPG'));
% for k = 1:length(files)
%     if strfind(files, 'GT')
%     end
% end

%dice score comparison
similarity = dice(imBin1, imGT1);
disp('dice index: ') %show in command window
disp(similarity)
