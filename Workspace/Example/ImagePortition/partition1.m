img=imread('cell3.png');

[img_x,img_y]=size(img);

block_size=50;
slide_len=10;

for ix=block_size/2:slide_len:img_x-block_size/2
    for jy=block_size/2:slide_len:img_y-block_size/2
        current_block=img((ix-block_size/2+1):(ix+block_size/2),(jy-block_size/2+1):(jy+block_size/2));
        dct_coeff=reshape(dct2(current_block),1,block_size^2);

       figure();
       imshow(img);
    end
end