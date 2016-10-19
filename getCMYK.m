function [ c, m, y, k ] = getCMYK( image )
%GETCMYK Summary of this function goes here
%   Detailed explanation goes here
cform = makecform('srgb2cmyk');
cmyk = applycform(image,cform);
% a3 = a3(:,:,1:3);
%a3 = normaliza(a3);
c = cmyk(:,:,1);
m = cmyk(:,:,2);
y = cmyk(:,:,3);
k = cmyk(:,:,4);
end

