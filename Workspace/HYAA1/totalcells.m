%%%%%% Counting cell(s) from specific area %%%%%%% 

close all;
clear;
clc;

%Reading image 
I = imread('cell1.png');   %upload the image
figure(1);
imshow(I);
title('Cell Image')


BW_in = imbinarize(I);        % convert image to Binary (Black & white)
figure(2);
imshow(BW_in);
title('Binary Cell Image  ')


%%%%%%%%%%%%%%%%% 1st method to remove object(s) %%%%%%%%%%%%%%%%

NumCellShow = 225 ;   % Number of cell(s) to display largest areas 
RMO=bwareafilt(BW_in,NumCellShow);  %Remove Objects from image  
figure (3);
imshow(RMO);
title( 'Display only traps from Binary Image without filling')

trap_fill= imfill(RMO,'holes'); % fill out the holes 
figure (4);
imshow(trap_fill);
title( 'Display only traps from Binary Image with filling ')


while 1==1     % Counting total cell(s) of area 
     X =input('1 - Enter number of attached cell(s)together(1, 4, 6, 8, 18, or 26) :');
     Y= input('2 - Confirm the entery (1= YES,0 = NO)?');
   
     if Y ~=1  %   y is not equal to 1 for NO 
        disp('Please try again !!!');
        continue
     end
     
     if Y==1   % y is eqaul to 1 for YES
        break
     end
end

count=bwconncomp(BW_in,X);           % Counting cells, joint_cell means number of cell connected to each other and count them as one cell
Max_Cells_1 = count.NumObjects  % total number of cells 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% Image information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

properties = regionprops(BW_in, {'Area', 'Eccentricity', 'EquivDiameter', 'EulerNumber', 'FilledArea', 'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'Perimeter'});

properties = struct2table(properties)


%%%%%%%%%%%%%%%%%%%%  2nd method to count cell(S) %%%%%%%%%%%%%%%% 
 
 while 1==1
     X =input('3 - Enter area of object(trap) to be removed :');
     trap= input('4 - Confirm the entery (1=YES,0 = NO)?');
   
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

figure (4);
imshow(BW_out)
title('Target the chosen cells')

BB= imfill(BW_out,'holes'); % fill out the holes 
label =bwlabel(BB); %% find out independent components and labels them with pixle inside
Max_Cell_2= max(max(label)) %  max number of cell(s) from chosen area
Dims_input = size(BW_in)
Dims_output = size(BW_out)



