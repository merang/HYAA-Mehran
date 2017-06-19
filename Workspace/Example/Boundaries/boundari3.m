% Display Object Boundaries in Red and Hole Boundaries in Green

I = imread('cell1.png');

BW = imbinarize(I);
[B,L,N] = bwboundaries(BW);

imshow(BW); hold on;

for k=1:length(B),
   boundary = B{k};
   if(k > N)
     plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
   else
     plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
   end
end