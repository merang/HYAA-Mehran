
close all;
clear ; clc;
tic ; % start timer 
captionFontSize = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

originalImage = imread('cell1.png');

[pixelCount, grayLevels] = imhist(originalImage);
figure();
bar(pixelCount);
title('Histogram of original image before threshold', 'FontSize', captionFontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

thresholdValue = 150;
hold on;
maxYValue = ylim;
line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
% Place a text label on the bar chart showing the threshold.
annotationText = sprintf('Thresholded at %d gray levels', thresholdValue);
% For text(), the x and y need to be of the data class "double" so let's cast both to double.
text(double(thresholdValue + 5), double(0.5 * maxYValue(2)), annotationText, 'FontSize', 10, 'Color', [0 .5 0]);
text(double(thresholdValue - 70), double(0.94 * maxYValue(2)), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
text(double(thresholdValue + 50), double(0.94 * maxYValue(2)), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check to make sure that it is grayscale, just in case the user substituted their own image.
[rows, columns, numberOfColorChannels] = size(originalImage);
originalImage = imadjust(originalImage,[0.4 0.69],[]);  % adjust contrast of image 

figure();
%subplot(3, 3, 1);
imshow(originalImage);
% Maximize the figure window.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Force it to display RIGHT NOW (otherwise it might not display until it's all done, unless you've stopped at a breakpoint.)
drawnow;
caption = sprintf('Original image with cells and traps ');
title(caption,'FontSize', captionFontSize);
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get histogram and display it.
[pixelCount, grayLevels] = imhist(originalImage);
histogram = imhist(originalImage);

figure();
imshow(histogram);
% subplot(3, 3, 1);
bar(pixelCount);
title('Histogram of original image after adjust threshold', 'FontSize', captionFontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

thresholdValue = 100;
hold on;
maxYValue = ylim;
line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
% Place a text label on the bar chart showing the threshold.
annotationText = sprintf('Thresholded at %d gray levels', thresholdValue);
% For text(), the x and y need to be of the data class "double" so let's cast both to double.
text(double(thresholdValue + 5), double(0.5 * maxYValue(2)), annotationText, 'FontSize', 10, 'Color', [0 .5 0]);
text(double(thresholdValue - 70), double(0.94 * maxYValue(2)), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
text(double(thresholdValue + 50), double(0.94 * maxYValue(2)), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%Convet Image to Binary %%%%%%%%%%%%%%%%%%%%%%%%%%%
binaryImage=imbinarize(originalImage);
% figure(),imshow(originalImage),title('Binary Image ');
binaryImage=imfill(binaryImage,'holes');

figure();
% subplot(3, 3, 2);
imshow(binaryImage); 
title('Binary Image, obtained', 'FontSize', captionFontSize); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Identify individual blobs by seeing which pixels are connected to each other.
% Each group of connected pixels will be given a label, a number, to identify
%it and distinguish it from the other blobs.
% Do connected components labeling with either bwlabel() or bwconncomp().
labeledImage = bwlabel(binaryImage, 8);     % Label each blob so we can make 
%measurements of it labeledImage is an integer-valued image where all pixels
%in the blobs have values of 1, or 2, or 3, or ... etc.
% each blob a different color to visually show the user the distinct blobs.
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); 
% pseudo random color labels (coloredLabels) is an RGB image

figure();
% subplot(3, 3, 4);
imshow(coloredLabels);
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
caption = sprintf('colored labels Binary Image from left to right');
title(caption, 'FontSize', captionFontSize);


% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
blobMeasurements = regionprops(labeledImage, originalImage, 'all');
numberOfBlobs = size(blobMeasurements, 1);

% textFontSize = 10;	% Used to control size of "blob number" labels put atop the image.
% labelShiftX = -7;	% Used to align the labels in the centers of the coins.
% blobECD = zeros(1, numberOfBlobs);
allBlobCentroids = [blobMeasurements.Centroid];
centroidsX = allBlobCentroids(1:2:end-1);
centroidsY = allBlobCentroids(2:2:end);
% Put the labels on the rgb labeled image also.



% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
figure();
% subplot(3, 3, 5);
imshow(originalImage);
title('Outlines, from bwboundaries()', 'FontSize', captionFontSize); 
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
hold on;
boundaries = bwboundaries(binaryImage);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;

textFontSize = 10;	% Used to control size of "blob number" labels put atop the image.
labelShiftX = -7;	% Used to align the labels in the centers of the coins.
blobECD = zeros(1, numberOfBlobs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Create Table %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'Blob #    (Mean Intensity)  (Area) (Perimeter) (*-Centroid-*) (Diameter)\n');
% Loop over all blobs printing their measurements to the command window.
for k = 1 : numberOfBlobs           % Loop through all blobs.
	% Find the mean of each blob.  (R2008a has a better way where you can pass the original image
	% directly into regionprops.  The way below works for all versions including earlier versions.)
	thisBlobsPixels = blobMeasurements(k).PixelIdxList;  % Get list of pixels in current blob.
	meanGL = mean(originalImage(thisBlobsPixels)); % Find mean intensity (in original image!)
	meanGL2008a = blobMeasurements(k).MeanIntensity; % Mean again, but only for version >= R2008a
	
	blobArea = blobMeasurements(k).Area;		        % Get area.
	blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
	blobCentroid = blobMeasurements(k).Centroid;		% Get centroid one at a time
	blobECD(k) = sqrt(4 * blobArea / pi);			    % Compute ECD - Equivalent Circular Diameter.
	fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));
	% Put the "blob number" labels on the "boundaries" grayscale image.
	text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Get Image elements based on brightness /darkness %%%%%%%%%%%

% % Now I'll demonstrate how to select certain blobs based using the ismember() function.
% %find only those blobs with an intensity between 150 and 220 and an area less than 2000 pixels.
allBlobIntensities = [blobMeasurements.MeanIntensity];
allBlobAreas = [blobMeasurements.Area];
allowableIntensityIndexes = (allBlobIntensities > 150) & (allBlobIntensities < 220);
allowableAreaIndexes = allBlobAreas < 2000; % Take the small objects.
keeperIndexes = find(allowableIntensityIndexes & allowableAreaIndexes);
keeperBlobsImage = ismember(labeledImage, keeperIndexes);
% % Re-label with only the keeper blobs kept.
labeledDimeImage = bwlabel(keeperBlobsImage, 8);    
% Label each blob so we can make measurements of it
% % Now we're done.  We have a labeled image of blobs that meet our specified criteria.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Plot centroids of Image elements %%%%%%%%%%%%%%%%%%%%

% Plot the centroids in the original image in the upper left.
% Dimes will have a red cross, nickels will have a blue X.
message = sprintf('Now I will plot the centroids over the original image in the upper left.\nPlease look at the upper left image.');
reply = questdlg(message, 'Plot Centroids?', 'OK', 'Cancel', 'Cancel');
% Note: reply will = '' for Upper right X, 'OK' for OK, and 'Cancel' for Cancel.
if strcmpi(reply, 'Cancel')
	return;
end

figure()
imshow(binaryImage);
hold on; % Don't blow away image.
for k = 1 : numberOfBlobs           % Loop through all keeper blobs.
	% Identify if blob #k is a dime or nickel.
	itsADime = allBlobAreas(k) < 2200; % Dimes are small.
	if itsADime
		% Plot dimes with a red +.
		plot(centroidsX(k), centroidsY(k), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
	else
		% Plot dimes with a blue x.
		plot(centroidsX(k), centroidsY(k), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now let's get the nickels (the larger coin type).
keeperIndexes = find(allBlobAreas > 2000);  % Take the larger objects.
% Note how we use ismember to select the blobs that meet our criteria.
nickelBinaryImage = ismember(labeledImage, keeperIndexes);
% Let's get the nickels from the original grayscale image, with the other non-nickel pixels blackened.
% In other words, we will create a "masked" image.
maskedImageNickel = originalImage; % Simply a copy at first.
maskedImageNickel(~nickelBinaryImage) = 0;  % Set all non-nickel pixels to zero.

figure()
imshow(maskedImageNickel, []);
axis image;
title('Only the nickels from the original image', 'FontSize', captionFontSize);

elapsedTime = toc;
% Alert user that the demo is done and give them the option to save an image.
message = sprintf('Done making measurements of the features.\n\nElapsed time = %.2f seconds.', elapsedTime);
message = sprintf('%s\n\nCheck out the figure window for the images.\nCheck out the command window for the numerical results.', message);
message = sprintf('%s\n\nDo you want to save the pseudo-colored image?', message);
reply = questdlg(message, 'Save image?', 'Yes', 'No', 'No');
% Note: reply will = '' for Upper right X, 'Yes' for Yes, and 'No' for No.

if strcmpi(reply, 'Yes')
	% Ask user for a filename.
	FilterSpec = {'*.PNG', 'PNG Images (*.png)'; '*.tif', 'TIFF images (*.tif)'; '*.*', 'All Files (*.*)'};
	DialogTitle = 'Save image file name';
	% Get the default filename.  Make sure it's in the folder where this m-file lives.
	% (If they run this file but the cd is another folder then pwd will show that folder, not this one.
	thisFile = mfilename('fullpath');
	[thisFolder, baseFileName, ext] = fileparts(thisFile);
	DefaultName = sprintf('%s/%s.tif', thisFolder, baseFileName);
	[fileName, specifiedFolder] = uiputfile(FilterSpec, DialogTitle, DefaultName);
	if fileName ~= 0
		% Parse what they actually specified.
		[folder, baseFileName, ext] = fileparts(fileName);
		% Create the full filename, making sure it has a tif filename.
		fullImageFileName = fullfile(specifiedFolder, [baseFileName '.tif']);
		% Save the labeled image as a tif image.
		imwrite(uint8(coloredLabels), fullImageFileName);
		% Just for fun, read image back into the imtool utility to demonstrate that tool.
		tifimage = imread(fullImageFileName);
		imtool(tifimage, []);
	end
end

message = sprintf('Would you like to crop out each coin to individual images?');
reply = questdlg(message, 'Extract Individual Images?', 'Yes', 'No', 'Yes');
% Note: reply will = '' for Upper right X, 'Yes' for Yes, and 'No' for No.

if strcmpi(reply, 'Yes')
	figure;	% Create a new figure window.
	% Maximize the figure window.
	set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]);
	for k = 1 : numberOfBlobs           % Loop through all blobs.
		% Find the bounding box of each blob.
		thisBlobsBoundingBox = blobMeasurements(k).BoundingBox;  % Get list of pixels in current blob.
		% Extract out this coin into it's own image.
		subImage = imcrop(originalImage, thisBlobsBoundingBox);
		% Determine if it's a dime (small) or a nickel (large coin).
		if blobMeasurements(k).Area > 2200
			coinType = 'nickel';
		else
			coinType = 'dime';
		end
		% Display the image with informative caption.
		subplot(10,10, k);
		imshow(subImage);
		caption = sprintf('Coin #%d is a %s.\nDiameter = %.1f pixels\nArea = %d pixels', ...
			k, coinType, blobECD(k), blobMeasurements(k).Area);
		title(caption, 'FontSize', textFontSize);
    end

writetable(blobMeasurements,'measurement.xls','Sheet',2,'Range'); 
xlswrite(blobMeasurements,measurement.xls,sheet,lRange);

end
