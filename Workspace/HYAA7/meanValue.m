
clear ;
close all;
clc;
fontSize=10;

%%% read image 
originalImage = imread('cell90.png');
originalImage = imadjust(originalImage,[0.4 0.69],[]);  % adjust contrast of image 

figure()
imshow(originalImage)
title('Original Image')

binaryImage=imbinarize(originalImage);   % fill the mising pixels
binaryImage=imfill(binaryImage,'holes');
figure()
imshow(binaryImage)
title('Binery Image')

load ref.mat

properties = regionprops(binaryImage, {'Area','Centroid', 'Orientation', 'Perimeter'});
properties = struct2table(properties);
% BW_out = bwpropfilt(binaryImage, 'Area', [82,200]);% fillter object area
figure ()
imshow(BW_out)
title('Blank Traps')


%%%%%%%%%%%% Convert Image to Whithe backround & black Object%%%%%%%%%%%%%%
Bb = imclearborder(binaryImage);
%%%%%%%%%%%%%%%  Create properties of image for each object %%%%%%%%%%%%%%%  
BrCent = regionprops(Bb,'centroid');
%%%%%%%%%%%  center point coordinate of each object in the images %%%%%%%%%%

Br = floor(reshape(convert2vector(BrCent),[2,size(BrCent,1)]))'*[0 1; 1 0];

BrRefCent = regionprops(BW_out,'centroid');
BrRef = floor(reshape(convert2vector(BrRefCent),[2,size(BrRefCent,1)]))'*[0 1; 1 0];

% Bf = ~imfill(~Bb,Br);

figure();
imshow(Bb);
hold on; 
scatter(Br(:,2),Br(:,1),'red','.')
hold off;

figure();
imshow(BW_out);
hold on; 
scatter(BrRef(:,2),BrRef(:,1),'red','.')
hold off;

estimateImage = imregcorr(binaryImage,BW_out,'translation');
Rfixed = imref2d(size(BW_out));
movingReg = imwarp(binaryImage,estimateImage,'OutputView',Rfixed);
figure()
imshow(movingReg);
title('Original Image Aligned')


sub=gsubtract(movingReg,BW_out);
figure();
imshow(sub);

% properties = regionprops(sub, {'Area','Centroid', 'Orientation', 'Perimeter'});
% properties = struct2table(properties);
% subImage = bwpropfilt(sub, 'Area',2);% fillter object area

BW2 = bwareaopen(sub,12);
figure();
imshowpair(sub,BW2,'montage')

[x , y]= bwboundaries(movingReg,'noholes');
