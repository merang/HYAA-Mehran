
% Overlay Region Boundaries on Image

I = imread('cell1.png');
B = imfill(I);
BW = imbinarize(B);

[B,L] = bwboundaries(BW,'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end