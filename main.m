clear all, close all; clc
%% Choose the image
originalImage = chooseAndRead();
h = waitbar(0,'Transormando, por favor espere...');
%% Transform to CMYK
[fil,col,cap] = size(originalImage);
[c,m,y,k]=getCMYK(originalImage);
waitbar(0.2);
% figure(1); imshow(y); impixelinfo;
%% Eliminar manchas
ee=strel('square',10);          % Elemento estructurante para las 
                                % transformaciones.
y = imclearborder(y);           % Limpiar los bordes antes que nada.
b = imerode(y,ee);              % Primero erosionar para eliminar manchas.
b = imdilate(b,ee);             % Luego dilatar para reunir un poco de la
                                % información perdida en el paso anterior.
b(b<80)=0;                      % Binarizar en 0 los valores menores a 80.
b(b>0)=1;                       % Y en 1 los valores restantes.
waitbar(0.4);
%% Rotar
ee=strel('square',3);           % Nuevo elemento estructurante más pequeño
% b = imdilate(b,ee);             
prop = regionprops(b,'all');    % Propiedades de la imagen (Para el ángulo)
N = length(prop);               % Número de propiedades encontradas
if N ~= 1                       % Si es diferente de 1, el esqueje no fue
                                % encontrado.
    close(h);
    msgbox('No se ha encontrado un esqueje en la imagen','Error','error');
    error('No se ha encontrado un esqueje en la imagen');
end
theta = prop(N).Orientation;    % Obtener el ángulo de orientación
b = imrotate(b,-theta/2,'crop');% Orientar -theta medios para alinear con
                                % el eje horizontal, rotar también la
                                % imagen original
originalImage = imrotate(originalImage,-theta/2,'crop');
waitbar(0.6);
%% Verificar si tiene la orientación adecuada (Hacia la derecha)
prop = regionprops(b,'all');    % Propiedades de la nueva imagen
box = prop(1).BoundingBox;      % Bounding box del esqueje
box_width = box(3);             % Ancho del bounding box
box_x = box(1);                 % X del borde izquierdo del bounding box
box_center = box_x + box_width / 2; % El centro es x + ancho / 2
centroid = prop(1).Centroid;    % Centroide, según la cantidad de pixeles 
                                % del esqueje, tiende a estar en las hojas
                                % del esqueje
centroid_x = centroid(1);       % X del centroide

if centroid_x < box_center      % Si el centroide está más a la izquierda
                                % que el centro del bounding box, girar 180
                                % grados ambas imágenes
    b = imrotate(b,180,'crop');
    originalImage = imrotate(originalImage,180,'crop');
end
waitbar(0.8);
%% Recortar imágenes
b=[b,b,b];                      % Hacer que la capa binaria mida lo mismo 
                                % que la imagen original
b=reshape(b,[fil,col,cap]);     % Con el tamaño de la imagen original
originalImage(b==0)=0;          % Recortar los elementos que estén en 0
waitbar(1);
close(h);
%% Mostrar resultado de la alineación
figure(3); imshow(originalImage); impixelinfo;
msgbox('Imagen del esqueje orientado, presione Aceptar para continuar','Info','info');