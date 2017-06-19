close all;clear; clc;

I = imread('cell1.png');
figure(1),imshow(I),title('ORIGINAL IMAGE');


%%% . 2nd method %%%
A = imadjust(I,[0.4 0.69],[]);  % adjust contrast of image 
figure(2),imshow(A),title('Contrasted ORIGINAL IMAGE ');
G=imbinarize(A);
figure(3),imshow(G),title('Binary Image ');
BW=imfill(G,'holes');
figure(4),imshow(BW),title('Fill Image Pixels  ');

[B,L,N,A] = bwboundaries(BW);


% Display the image with the boundaries overlaid. Add the region number next to every boundary (based on the label matrix). Use the zoom tool to read individual labels.

imshow(BW); hold on;
colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(A)
  boundary = B{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);

  %randomize text position for better visibility
  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
  col = boundary(rndRow,2); row = boundary(rndRow,1);
  h = text(col+1, row-1, num2str(L(row,col)));
  set(h,'Color',colors(cidx),'FontSize',10,'FontWeight','bold');
end

figure(5)
spy(A);





 CC = bwconncomp(BW);
 L = labelmatrix(CC);
 L2 = bwlabel(BW);
 whos L L2
 figure(), imshow(label2rgb(L));

labeled=labelmatrix(CC);
RGB_label=label2rgb(labeled,@copper,'b','shuffle');
figure(), imshow(RGB_label,'InitialMagnification','fit');

SE= ones(5);
BW2=imdilate(BW,SE);
increase=(bwarea(BW2)-bwarea(BW))/bwarea(BW)


eul=bweuler(BW,8)


