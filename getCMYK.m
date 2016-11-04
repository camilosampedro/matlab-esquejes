function [ c, m, y, k ] = getCMYK( image )
%GETCMYK Summary of this function goes here
%   Detailed explanation goes here
cform = makecform('srgb2cmyk');         % Crear el conversor de rgb a cmyk
cmyk = applycform(image,cform);         % Aplicarlo a la imagen
c = cmyk(:,:,1);                        % Separar capa C
m = cmyk(:,:,2);                        % Separar capa M
y = cmyk(:,:,3);                        % Separar capa Y
k = cmyk(:,:,4);                        % Separar capa K
end

