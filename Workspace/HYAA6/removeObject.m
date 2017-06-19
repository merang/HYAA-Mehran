 clc
    clear
    close all
%     [filename, pathname] = uigetfile('*.*','File Selector');
%     I = imread(strcat(pathname,'\',filename)); % for example FileName='MyImage.jpg' 
    
I = imread('cell1.png');
I = imadjust(I,[0.4 0.69],[]);  % adjust contrast of image 
BW=imbinarize(I);
figure(1);
imshow(I);
title('Original Image' );
axis image; 

 
    [bw, loc2]= imfill(BW,'holes');
    
    rp = regionprops(bw,'All'); % you can specify the parameters which you need
    ObjArea=zeros(size(rp,1),1);
    CenterX=zeros(size(rp,1),1);
    CenterY=zeros(size(rp,1),1);
    for i=1:size(rp,1)
        ObjArea(i)=rp(i).Area;
        CenterX (i)= rp(i).Centroid(1);
        CenterY (i)= rp(i).Centroid(2);
        % you can add other properties (for example area, perimeter etc here)
    end
  Final=[ObjArea CenterX CenterY];
  imshow(bw);
  hold on
  for i=1:size(Final,1)
      text(Final(i,2),Final(i,3),num2str(Final(i,1)),...
      'HorizontalAlignment' , 'center',...
      'VerticalAlignment' , 'middle');
  end
  title('Area of Particles');
prompt = {'Minimum size:','Maximum size:'};
dlg_title = 'Mini_Max';
num_lines = 1;
def = {'2','500'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
MinMaxSize =str2num(char(answer));
MinSize=MinMaxSize(1,1); MaxSize= MinMaxSize(2,1);
Removed=[];
  for i=1:size(rp,1)
      if rp(i).Area<MinSize || rp(i).Area>MaxSize
        Removed=[Removed i];
      end
  end
rp(Removed)=[];
NewImage= zeros(size(I));
  for i=1:size(rp,1)
        OneOject= rp(i).PixelList;
        for j=1:length(rp(i).PixelList)
            OneRow = OneOject(j,:);
            NewImage (OneRow(2),OneRow(1))=1;
        end
  end
figure
imshow(NewImage)
hold on
visboundaries(NewImage,'Color','r');      
hold off
title('Area of Particles - between Minimum and Maximum');