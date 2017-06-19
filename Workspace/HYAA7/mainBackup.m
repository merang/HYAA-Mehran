

%%% Image partition %%%
clear ;
close all;
clc;
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
rOffset = 4;  %%%%  pixels vertically
cOffsetRight = 760;
numRows = floor(z / height); %%%%% 17
x = cOffsetRight - cOffset; %%%%%%  490
numCols = floor(x / width);%%%%% 7

figure(9);
for r=1:numRows
    if (rem(r,2)==0)      %  for even row 
        cols=1:numCols-1;
        offset = 30;
        add=2;
             if r >13
            add=add+2;
             else
            end
    else
        cols=1:numCols;       % for odd rows 
        offset =0;
       add=0;
    end
    for c=cols
        top = ((r-1)*height+rOffset)-add;        
        bottom = ((r)*height+rOffset)+add;
        left = (offset+(c-1)*width+cOffset)-add;
        right = (offset+(c)*width+cOffset)+add;
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        fprintf('TopPixel= %d, BottomPixel= %d ,LeftPixel= %d, RightPixel= %d\n',top,bottom,left,right);
        ref=BW_out(top:bottom,left:right); 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cropImage=binaryImage(top:bottom,left:right);
       
        subplot(4,4,1)
        imshow(cropImage);
        hold on
        visboundaries(cropImage,'Color','r');
        title(' Traget Cell Area ');
        hold off
        %%%%%%%%%%%%%%%%%%%%%%% align Images %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
        
        
        %%%%%%%%%%%%%%Display only cell areas of image %%%%%%%%%%%%%%%%%
        cell = bwpropfilt(cropImage, 'Area', [0,81]);
        
        subplot(4,4,2);
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
        
        % Display the image.
        subplot(4,4,3);
        imshow(biggestBlob, []);
        hold on 
        visboundaries(biggestBlob,'Color','r');
        hold off
        % Make the number positive again.  We don't need it negative for smallest extraction anymore.
        numberToExtract = abs(numberToExtract);
        caption = sprintf('Mother Cell');
        title(caption, 'FontSize', fontSize);
%       msgbox('Done with demo!');

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%% Detectated latgest to smallest cell %%%%%%%%%%%%%
       
        %cell=gsubtract(cell,biggestBlob);
        biggestBlob_Lower1 = ExtractNLargestBlobs((cell-biggestBlob), numberToExtract);
        subplot(4,4,4) 
        imshow(biggestBlob_Lower1,[]);
        hold on
        visboundaries(biggestBlob_Lower1,'Color','r');
        hold off
        title(' 1st Daughter Cell');
        
        biggestBlob_Lower2 = ExtractNLargestBlobs(cell-(biggestBlob+ ...
            biggestBlob_Lower1), numberToExtract);
        subplot(4,4,5)
        imshow(biggestBlob_Lower2,[]);
        hold on
        visboundaries(biggestBlob_Lower2,'Color','r');
        hold off
        title(' 2nd Daughter Cell');
        
        
        biggestBlob_Lower3 = ExtractNLargestBlobs(cell-(biggestBlob+ ...
            biggestBlob_Lower1+biggestBlob_Lower2), numberToExtract);
        subplot(4,4,6) 
        imshow(biggestBlob_Lower3);
        hold on
        visboundaries(biggestBlob_Lower3,'Color','r');
         hold off
        title(' 3nd Daughter Cell');
        
        
        biggestBlob_Lower4 = ExtractNLargestBlobs(cell-(biggestBlob+ ...
            biggestBlob_Lower1+biggestBlob_Lower2+biggestBlob_Lower3), numberToExtract);
        subplot(4,4,7) 
        imshow(biggestBlob_Lower4)
        hold on
        visboundaries(biggestBlob_Lower4,'Color','r');
         hold off
        title('4nd Daughter Cell');
        
        
        biggestBlob_Lower5 = ExtractNLargestBlobs(cell-(biggestBlob+ ...
            biggestBlob_Lower1+biggestBlob_Lower2+biggestBlob_Lower3+ ...
            biggestBlob_Lower4), numberToExtract);
        subplot(4,4,8) 
        imshow(biggestBlob_Lower5)
         hold on
        visboundaries(biggestBlob_Lower5,'Color','r');
         hold off
        title('5nd Daughter Cell');
         
       
        biggestBlob_Lower6 = ExtractNLargestBlobs(cell-(biggestBlob+ ...
            biggestBlob_Lower1+biggestBlob_Lower2+biggestBlob_Lower3+ ...
            biggestBlob_Lower4+biggestBlob_Lower5),numberToExtract);
        subplot(4,4,9) 
        imshow(biggestBlob_Lower6)
         hold on
        visboundaries(biggestBlob_Lower6,'Color','r');
         hold off
        title('6nd Daughter Cell');
         
        biggestBlob_Lower7 = ExtractNLargestBlobs(cell- (biggestBlob+ ...
            biggestBlob_Lower1+biggestBlob_Lower2+biggestBlob_Lower3+ ...
            biggestBlob_Lower4+biggestBlob_Lower5+biggestBlob_Lower6),...
            numberToExtract);
        subplot(4,4,10) 
        imshow(biggestBlob_Lower7)
         hold on
        visboundaries(biggestBlob_Lower7,'Color','r');
         hold off
        title('7nd Daughter Cell');
        
        biggestBlob_Lower8 = ExtractNLargestBlobs(cell- (biggestBlob+ ...
            biggestBlob_Lower1+biggestBlob_Lower2+biggestBlob_Lower3+ ...
            biggestBlob_Lower4+biggestBlob_Lower5+biggestBlob_Lower6+ ...
            biggestBlob_Lower7),numberToExtract);
        subplot(4,4,11) 
        imshow(biggestBlob_Lower8)
         hold on
        visboundaries(biggestBlob_Lower8,'Color','r');
         hold off
        title('8nd Daughter Cell');
        
        biggestBlob_Lower9 = ExtractNLargestBlobs(cell- (biggestBlob+ ...
            biggestBlob_Lower1+biggestBlob_Lower2+biggestBlob_Lower3+ ...
            biggestBlob_Lower4+biggestBlob_Lower5+biggestBlob_Lower6+ ...
            biggestBlob_Lower7+biggestBlob_Lower8),numberToExtract);
        subplot(4,4,12) 
        imshow(biggestBlob_Lower9)
         hold on
        visboundaries(biggestBlob_Lower9,'Color','r');
         hold off
        title('9nd Daughter Cell');

        reference=imread('cellRef.png');
        BIN = imadjust(reference,[0.4 0.69],[]);
        reference= im2bw(BIN);
        reference=imcomplement(BIN);
        
        tformEstimate = imregcorr(cropImage,BIN);
        Rfixed = imref2d(size(BIN));
        movingReg = imwarp(cropImage,tformEstimate,'OutputView',Rfixed);
%         subplot(4,4,13)
%         imshow(Rfixed);
        
        subplot(4,4,14)
        imshow(movingReg);
        
%         subplot(4,4,13)
%         imshowpair(ref,cropImage);
      
%         hlist=[cell  reference];
%         subplot(4,4,14)
%         cellAlign= align(hlist,'Center','middle');
%         imshow(cellAlign);
		 
        
        subplot(4,4,15)
        imshow(BIN)
        
         subplot(4,4,16)
         imshow(cropImage)
        
        drawnow; 
        pause;
%         add=add+1;
        plotIndex=plotIndex+1;
    end  
end



