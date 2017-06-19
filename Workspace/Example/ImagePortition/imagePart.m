clc;    % Clear the command window.
format compact;
workspace;  % Make sure the workspace panel is showing.
fontSize = 20;
% % Read in a standard MATLAB color demo image.
% folder = fullfile(matlabroot, '\toolbox\images\imdemos');
% baseFileName = 'peppers.png';
% fullFileName = fullfile(folder, baseFileName);
% % Get the full filename, with path prepended.
% fullFileName = fullfile(folder, baseFileName);
% if ~exist(fullFileName, 'file')
% 	% Didn't find it there.  Check the search path for it.
% 	fullFileName = baseFileName; % No path this time.
% 	if ~exist(fullFileName, 'file')
% 		% Still didn't find it.  Alert user.
% 		errorMessage = sprintf('Error: %s does not exist.', fullFileName);
% 		uiwait(warndlg(errorMessage));
% 		return;
% 	end
% end
rgbImage = imread('8cells.png');
% For demo purposes, let's resize it to be 64 by 64;
rgbImage = imresize(rgbImage, [10 10]);
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows columns ] = size(rgbImage)
ca = mat2cell(rgbImage,8*ones(1,size(rgbImage,1)/8),8*ones(1,size(rgbImage,2)/8),3);
plotIndex = 1;
for c = 1 : size(ca, 2)
	for r = 1 : size(ca, 1)
		fprintf('c=%d, r=%d\n', c, r);
		subplot(8,8,plotIndex);
		imshow(ca{r,c});
		plotIndex = plotIndex + 1
	end
end
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);