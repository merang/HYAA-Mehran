% Another way to split the image up into blocks is to use indexing.
% Read in a standard MATLAB gray scale demo image.
clear;
close all;
clc;
delete('Frames\*.jpg');
fontSize = 10;
grayImage = imread('cell2.png');
% Get the dimensions of the image.  numberOfColorBands should be = 1.
[rows, columns] = size(grayImage);
% Display the original gray scale image.
figure(1)
imshow(grayImage, []);
title('Original Grayscale Image', 'FontSize', fontSize);

% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);


% Let's assume we know the block size and that all blocks will be the same size.
blockSizeR =63; % Rows in block.
blockSizeC = 65; % Columns in block.

% Figure out the size of each block. 
wholeBlockRows = floor(rows / blockSizeR);
wholeBlockCols = floor(columns / blockSizeC);

reduceC= 4*(blockSizeC);
reduceR= 9*(blockSizeR);

% Now scan though, getting each block and putting it as a slice of a 3D array.
sliceNumber = 1;
for row = 1 : blockSizeR : rows
	for col = reduceC: blockSizeC : columns-reduceR
            if  rem(sliceNumber,2)==0
                    % Let's be a little explicit here in our variables
                    % to make it easier to see what's going on.
                    row1 = row+(blockSizeR);
                    row2 = row1 + blockSizeR -1;
                    col1 = col;
                    col2 = col1 + blockSizeC-1 ;
                    % Extract out the block into a single subimage.
%                     oneBlock = grayImage(row1:row2, col1:col2);
            
            else  
                    row1 = row;
                    row2 = row1 + blockSizeR -1;
                    col1 = col;
                    col2 = col1 + blockSizeC-1 ;
                    % Extract out the block into a single subimage.
%                   oneBlock = grayImage(row1:row2, col1:col2);
            end
                    oneBlock = grayImage(row1:row2, col1:col2);
		% Specify the location for display of the image.
		subplot(18,7,sliceNumber);
		imshow(oneBlock);
		% Make the caption the block number.
		caption = sprintf('Block #%d of 120', sliceNumber);
		title(caption, 'FontSize', fontSize);
		drawnow;
		% Assign this slice to the image we just extracted.
		image3D(:,:, sliceNumber) = oneBlock;
		sliceNumber = sliceNumber + 1;
              
	end
end



% Now display all the blocks.
plotIndex = 1;
numPlotsR = size(ca, 1);
numPlotsC = size(ca, 2);
for r = 1: numPlotsR
	for c = 10 : numPlotsC
		fprintf('plotindex = %d,   c=%d, r=%d\n', plotIndex, c, r);
		% Specify the location for display of the image.
		subplot(numPlotsR, numPlotsC, plotIndex);
		% Extract the numerical array out of the cell
		% just for tutorial purposes.
		rgbBlock = ca{r,c};
		imshow(rgbBlock); % Could call imshow(ca{r,c}) if you wanted to.
		[rowsB columnsB numberOfColorBandsB] = size(rgbBlock);
		% Make the caption the block number.
		caption = sprintf('Block #%d of %d\n%d rows by %d columns', ...
			plotIndex, numPlotsR*numPlotsC, rowsB, columnsB);
		title(caption);
		drawnow;
		% Increment the subplot to the next location.
		plotIndex = plotIndex + 1;
	end
end
% Display the original image in the upper left.
% subplot(4, 6, 1);
figure(2)
imshow(rgbImage);
title('Original Image');









% Now image3D is a 3D image where each slice, 
% or plane, is one quadrant of the original 2D image.
msgbox('Done !!!!Check out the two figures.');



