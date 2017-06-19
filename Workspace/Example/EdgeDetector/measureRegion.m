clear;
close all;
clc;
I = imread('cell3.png');
imshow(I)
title('Synthetic Image')


BW = im2bw(I) ;
imshow(BW)
title('Binary Image')

s = regionprops(BW, I, {'Centroid','WeightedCentroid'});

imshow(I)
title('Weighted (red) and Unweighted (blue) Centroids'); 
hold on
numObj = numel(s);
for k = 1 : numObj
    plot(s(k).WeightedCentroid(1), s(k).WeightedCentroid(2), 'r*');
    plot(s(k).Centroid(1), s(k).Centroid(2), 'bo');
end
hold off

s = regionprops(BW, I, {'Centroid','PixelValues','BoundingBox'});
imshow(I);
title('Standard Deviation of Regions');
hold on
for k = 1 : numObj
    s(k).StandardDeviation = std(double(s(k).PixelValues));
    text(s(k).Centroid(1),s(k).Centroid(2), ...
        sprintf('%2.1f', s(k).StandardDeviation), ...
        'EdgeColor','b','Color','r');
end
hold off

figure
bar(1:numObj,[s.StandardDeviation]);
xlabel('Region Label Number');
ylabel('Standard Deviation');


sStd = [s.StandardDeviation];
lowStd = find(sStd < 200);

imshow(I);
title('Objects Having Standard Deviation < 50');
hold on;
for k = 1 : length(lowStd)
    rectangle('Position', s(lowStd(k)).BoundingBox, ...
        'EdgeColor','y');
end
hold off;