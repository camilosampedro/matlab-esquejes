clear all, close all; clc
uigetfile
a = imread('esquejes (127).TIFF');
[fil,col,cap] = size(a);
cform = makecform('srgb2cmyk');
a3 = applycform(a,cform);
a3 = a3(:,:,1:3);
%a3 = normaliza(a3);
y=a3(:,:,3);
figure(1); imshow(y); impixelinfo;
ee=strel('square',10);
y = imclearborder(y);
b = imerode(y,ee);

b = imdilate(b,ee);
b(b<80)=0;
b(b>0)=1;
ee=strel('square',3);
b = imdilate(b,ee);
prop = regionprops(b,'all');
N = length(prop);
theta = prop(1).Orientation;


%if abs(theta) > 2
b = imrotate(b,-theta/2,'crop');
a = imrotate(a,-theta/2,'crop');
%end 

prop = regionprops(b,'all');
box = prop(1).BoundingBox;
box_width = box(3);
box_x = box(1);
box_center = box_x + box_width / 2;
centroid = prop(1).Centroid;
centroid_x = centroid(1);

if centroid_x < box_center
    b = imrotate(b,180,'crop');
    a = imrotate(a,180,'crop');
end
figure(2); imshow(b); impixelinfo;

b=[b,b,b];
b=reshape(b,[fil,col,cap]);
a(b==0)=0;
figure(3); imshow(a); impixelinfo;