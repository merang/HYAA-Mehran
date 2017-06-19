clc;
close all;

A=imread('cell2.tif');
figure, imshow(A);
title ('original image')
B=im2bw(A);
figure, imshow(B);
C = imfill(B,'holes');
figure, imshow(C);
label = bwlabel(C);