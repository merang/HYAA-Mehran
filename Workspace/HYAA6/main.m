

%%% Image partition %%%
clear ,close all ,clc
fontSize=10;

%%% read image 
originalImage = imread('cell1.png');
originalImage = imadjust(originalImage,[0.4 0.69],[]);  % adjust contrast of image 

figure();
imshow(originalImage);
title('Original Image' );
axis image; 

%%%%%%%%%%%%%%%%%%%%%%%Display original image Histogram%%%%%%%%%%%%%%%%%%%
[pixelCount, grayLevels] = imhist(originalImage);

figure();
bar(pixelCount);
grid on;
title('Histogram of original image', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
%%%%%%%%%%%%%%%%%%%%%% Convert to Binary Image %%%%%%%%%%%%%%%%%%%%%%%%%%
binaryImage=imbinarize(originalImage);   % fill the mising pixels
binaryImage=imfill(binaryImage,'holes');

figure();
imshow(binaryImage); 
title('Binary Image " Level Contrast" ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Enlarge figure to full screen.
% set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RGB Label %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
labeledImage = bwlabel(binaryImage, 8);    
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); 

figure();
imshow(coloredLabels);
axis image; 
caption = sprintf('colored labels Binary Image from left to right');
title('Caption');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Label each image Elements in color %%%%%%%%%%%%%%%%%%%%%%%%%%
blobMeasurements = regionprops(labeledImage, originalImage, 'all');
numberOfBlobs = size(blobMeasurements, 1);
allBlobCentroids = [blobMeasurements.Centroid];
centroidsX = allBlobCentroids(1:2:end-1);
centroidsY = allBlobCentroids(2:2:end);

figure();
imshow(originalImage);
title('Outlines, from bwboundaries'); 
axis image; % 
hold on;
boundaries = bwboundaries(binaryImage);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Create Table for cells properties %%%%%%%%%%%%%%%%%
properties = regionprops(binaryImage, {'Area','Centroid', 'Orientation', 'Perimeter'});
properties = struct2table(properties);
%%%%%%%%%%%%%%%%%%%%%%% Great blank  traps image %%%%%%%%%%%%%%%%%%%%%%%%%
% BW_out = bwpropfilt(BW_in, 'Area', [-Inf, X - eps(X)]);
BW_out = bwpropfilt(binaryImage, 'Area', [82,200]);% fillter object area

figure ();
imshow(BW_out)
title('Blank Trap')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cells Locations %%%%%%%%%%%%%%%%%%%%%%%%%%%
 cell=gsubtract(binaryImage,BW_out);
 cell = imclearborder(cell);  % Get rid of border of image 
 
 figure();
 imshow(cell);
 title('Cells position without traps');
%%%%%%%%%%%%%%%%%%%%%%% partition image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%==========================================================================
val=80;
min_Pixels= 2;  % min pixels to filter
max_Pixels=30;  % max pixels to filter 
[z,y]=size(binaryImage);
plotIndex = 1;
width = 70;
height = 56;
cOffset = 270;
rOffset = 2;  %%%%  pixels vertically
cOffsetRight = 760;
numRows = floor(z / height); %%%%% 17
x = cOffsetRight - cOffset; %%%%%%  490
numCols = floor(x / width);%%%%% 7
figure(9);
for r=1:numRows 
    if (rem(r,2)==0)      %  for even row 
        cols=1:numCols-1;
        offset = 30;    %%%% to add 30 pixel to even rows
        add=2;
    else
        cols=1:numCols;       % for odd rows 
        offset =0;
        add=0;
    end
    for c=cols
        top = ((r-1)*height+rOffset)-add;
        bottom = ((r)*height+rOffset)+add;
        left = offset+(c-1)*width+cOffset-add;
        right = offset+(c)*width+cOffset+add;
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        fprintf('%d,%d',top,left);
        ref=BW_out(top:bottom,left:right); 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        cropImage=binaryImage(top:bottom,left:right);
        
        subplot(3,4,1)
        imshow(cropImage);
        hold on
        visboundaries(cropImage,'Color','r');
        title(' Traget Cell Area ');
        hold off
        %%%%%%%%%%%%%%Display only cell areas of image %%%%%%%%%%%%%%%%%
        cell = bwpropfilt(cropImage, 'Area', [0,81]);
        
        subplot(3,4,2);
        imshow(cell);
        hold on
        visboundaries(cell,'Color','r');
        title(' Detected Cells ');
        hold off
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%% Extract largest blob . %%%%%%%%%%%%%%%%%%%%%%%%%%
        numberToExtract = 1;
        %---------------------------------------------------------------------------
        % Extract the largest area using our custom function ExtractNLargestBlobs().
        % This is the meat of the demo!
        biggestBlob = ExtractNLargestBlobs(cell, numberToExtract);
        %---------------------------------------------------------------%

		drawnow; 
        pause;
        plotIndex=plotIndex+1;
    end  
end



