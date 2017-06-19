frmActivePixels = 45;
frmActiveLines = 45;
frmOrig = imread('cellZoom2.png');
frmInput = frmOrig(1:frmActiveLines,1:frmActivePixels);
figure
imshow(frmInput,'InitialMagnification',300)
title 'Input Image'


 edgeDetectSobel = visionhdl.EdgeDetector();
 
frm2pix = visionhdl.FrameToPixels(...
      'NumComponents',1,...
      'VideoFormat','custom',...
      'ActivePixelsPerLine',frmActivePixels,...
      'ActiveVideoLines',frmActiveLines,...
      'TotalPixelsPerLine',frmActivePixels+10,...
      'TotalVideoLines',frmActiveLines+10,...
      'StartingActiveLine',6,...
      'FrontPorch',5);
  
  
 
  
  
 [pixIn,ctrlIn] = frm2pix(frmInput);

[~,~,numPixelsPerFrame] = getparamfromfrm2pix(frm2pix);
ctrlOut = repmat(pixelcontrolstruct,numPixelsPerFrame,1);
edgeOut = false(numPixelsPerFrame,1);


for p = 1:numPixelsPerFrame
   [edgeOut(p),ctrlOut(p)] = edgeDetectSobel(pixIn(p),ctrlIn(p));
end


pix2frm = visionhdl.PixelsToFrame('NumComponents',1,'VideoFormat','custom','ActivePixelsPerLine',frmActivePixels,'ActiveVideoLines',frmActiveLines);

[frmOutput,frmValid] = pix2frm(edgeOut,ctrlOut);

if frmValid
    figure
    imshow(frmOutput, 'InitialMagnification',300)
    title 'Output Image'
end
  