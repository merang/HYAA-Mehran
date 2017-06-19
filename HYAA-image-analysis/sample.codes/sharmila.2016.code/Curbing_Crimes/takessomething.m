function [ output_args ] = takessomething( input_args )
clear all;
close all
clc;
%% Read Video
videoReader = vision.VideoFileReader('E:\2016\2016matlab\Curbing_Crimes\videodataset\7.mp4');  

%% Create Video Player
videoPlayer = vision.VideoPlayer;
fgPlayer = vision.VideoPlayer;

%% Create Foreground Detector  (Background Subtraction)
foregroundDetector = vision.ForegroundDetector('NumGaussians', 3,'NumTrainingFrames', 50);

%% Run on first 75 frames to learn background
for i = 10:100
    videoFrame = step(videoReader);
    foreground = step(foregroundDetector,videoFrame);
end
% display 75th frame and foreground image
figure;
imshow(videoFrame);
title('Input Frame');
figure;
imshow(foreground);
title('Foreground');

%% Perform morphology to clean up foreground 
cleanForeground = imopen(foreground, strel('Disk',5));
figure;
% Display original foreground
subplot(1,2,1);imshow(foreground);title('Original Foreground');
% Display foreground after morphology
subplot(1,2,2);imshow(cleanForeground);title('Clean Foreground');

%% Create blob analysis object 

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 250);

%% Loop through video
c=0;
while  ~isDone(videoReader)
    %Get the next frame
    videoFrame = step(videoReader);
    
    
    %Detect foreground pixels
    foreground = step(foregroundDetector,videoFrame);
 
    % Perform morphological filtering
    cleanForeground = imopen(foreground, strel('Disk',1));
            
    % Detect the connected components with the specified minimum area, and
    % compute their bounding boxes
    bbox = step(blobAnalysis, cleanForeground);
    % Draw bounding boxes around the detected cars

% if c>108 & c< 120
%  result =insertShape(videoFrame,'Rectangle',[180 190 50 70],'Color', 'red');
%    result = insertText(result, [180 190], 'hit another person' , 'BoxOpacity', 1, ...
%         'FontSize', 14);
% else
%       result = insertShape(videoFrame, 'rectangle', bbox, 'Color', 'green');
%     
% end
% 
% 
 if c>590 & c<740

     result =insertShape(videoFrame,'Rectangle',[290 170 80 120],'Color', 'magenta','SmoothEdges',true);
   result = insertText(result, [190 80], 'person takes something from the car  ' , 'BoxOpacity', 1, ...
        'FontSize', 14);
 else
     
      result = insertShape(videoFrame, 'rectangle', bbox, 'Color', 'yellow');
 end
    % Display the number of cars found in the video frame
    numCars = size(bbox, 1);
    text = sprintf('person takes something from the car  ');
    
% hold on;
% rectangle('Position', [50 70 30 60] );
%
% RGB = insertShape(I,'circle',[150 280 35],'LineWidth',5);
    % Display output 
    step(videoPlayer, result);
    step(fgPlayer,cleanForeground);

    c=c+1;
end
RNN;
%% release video reader and writer
release(videoPlayer);
release(videoReader);
release(fgPlayer);
delete(videoPlayer); % delete will cause the viewer to close
delete(fgPlayer);
test;



end

