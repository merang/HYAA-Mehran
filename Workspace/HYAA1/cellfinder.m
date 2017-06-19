%%%%%% Counting cell(s) from specific area %%%%%%% 

close all;
clear;
clc;

%Reading image 
I = imread('cell1.png');   %upload the image
BW = imbinarize(I);        % convert image to Binary (Black & white)


figure(1);
imshow(I);
title('Image for Cell Counting ')
disp('Specify a section of image that cells need to be counted !!!')



%%%%%%%%%%%% Target cell area by input column and row %%%%%%%%%%%%%%%%%%

% select the area that needs to be considered for image processing where 
% pixeles from 250 to 750 is width range of image and
% pixles from 1 to 960 is length range of image.


while 2==2
    row = input('1 - Enter X(row) value for allocated pixel between 250 to 760:');
    col = input('2 - Enter Y(column)value for allocated pixel between between 1 to 960:');
    width = 50;   % width of target area
    height = 50; % length of target area
   
    Y= input( '3 - Confirm, the entery is correct(1= YES,0 = NO):');
    if Y ~=1  %   y is not equal to 1 for NO 
        disp('Please try again !!!');
        continue
    end
    if Y==1   % y is eqaul to 1 for YES
        break
    end
end

J=imcrop(I, [row col width height]);
S = imbinarize(J);
area_target= bwarea(S);
figure(2);
imshow(J);   
title('Chosen Cell(s) area ')

figure(3);
imshow(S);   
title('Binary image of Chosen area')
 
 
% Scan the chosen image and returen a close trace of the shape of cell

K= imcrop(BW ,[row col width height]);
N = imcomplement(K);                % to swip backgrount to black and cell to white 
F = flipud(N);                      % image returen come as flip so we needto flip it again 
BW_filled = imfill(F,'holes');      % filling any holes on cell area 
[B,L]= bwboundaries(S,'noholes');

figure (4)
for h = 1:1
    
    b = B{h};
    plot(b(:,2),b(:,1),'g','Linewidth',3);
 
end

title('Trace of chosen cell(s) area')

%%%%%%%%%%%%%%%%% some function to remove object %%%%%%%%%%%%%%%%

cellShow = 3 ;
RMO=bwareafilt(S,cellShow);    
figure (5);
imshow(RMO);
title('Object(S) Removed from Binary Image')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%% Counting total cell(s) of area %%%%%%%%%%%% 

while 1==1
     X =input('4 - Enter number of attached cell(s)together:');
     Y= input('5 - Confirm the entery (1= YES,0 = NO)?');
   
     if Y ~=1  %   y is not equal to 1 for NO 
        disp('Please try again !!!');
        continue
     end
     
     if Y==1   % y is eqaul to 1 for YES
        break
     end
end


count=bwconncomp(S,X);           % Counting cells, joint_cell means number of cell connected to each other and count them as one cell
Total_Cells = count.NumObjects;  % total number of cells 


%%%%%%%%%%%%%%%%%%% Image information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BW_in = S ;   % S is binary image of target area with cells 
properties = regionprops(BW_in, {'Area', 'Eccentricity', 'EquivDiameter', 'EulerNumber', 'FilledArea', 'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'Perimeter'});

properties = struct2table(properties)

%r


%%%%%%%%%%  Get image of only chosen cell(S) %%%%%%%%%% 
 
 while 1==1
     X =input('6 - Enter area of object(trap) to be removed :');
     trap= input('7 - Confirm the entery (1=YES,0 = NO)?');
   
     if trap ~= 1  
        disp('Please try again !!!');
        continue
     end
     
     if trap == 1  
        break
     end
 end

%%%%%%%%% Filter image based on image properties %%%%%%%%%%%%%%%%%%
BW_out = bwpropfilt(BW_in, 'Area', [-Inf, X - eps(X)]);

figure (6);
imshow(BW_out)
title('Target the chosen cells')


%%%%%%%%%%%%%%%%%%%% Finding individual cell  %%%%%%%%%%%%%%%%%%%%%%%%%%%%

BB= imfill(BW_out,'holes'); % to fill out the holes 
label =bwlabel(BB); %% find out independent components and labels them with pixle inside
MaxCell= max(max(label)) %  max number of cell(s) from chosen area

Dims_input = size(BW)
Dims_output = size(BW_out)

for j=1:max(max(label))          %  j = 1 to  max components 
    [row,col]=find(label==j);    %  find row & col for each components 
    len=max(row)-min(row)+2;
    breadth=max(col)-min(col)+2;  
    target=uint8(zeros([len breadth]));  % zero = all asign as zero , unit8 = unsign integer 8 
    sy=min(col)-1;  % number of iterations to do for col  x direction
    sx=min(row)-1;  % number of iterations to do for row  y direction
    
    for i=1:size(row,1)  % start iterating and segment out each object 
        x=row(i,1)-sx;
        y= col(i,1)-sy;
        target(x,y)=BW_out(row(i,1),col(i,1));
    end
    
    cellTitle=strcat('Cell No. ' , num2str(j)); %% to title each objects num2str = number to string 
    figure
    imshow(target);
    title(cellTitle);
 
  
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%properties = sort(properties,{'Area'});




% properties = sort(properties,'descend');
%idx = sort(properties);

%properties = properties(idx);


%for i=1:size(properties)
    
%cell_area = properties(i).Area
%end


