function [ imagen_alineada, largo, hoja_en_base, area ] = analizar( imagen )
%% Valores iniciales
escala_palito = 0.00936170212765957447;
%% Escoger la imagen
h = waitbar(0,'Transformando, por favor espere...');
%% Transformar en CMYK
[fil,col,cap] = size(imagen);
[~,~,y,~]=getCMYK(imagen);
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
%ee=strel('square',3);          % Nuevo elemento estructurante más pequeño
% b = imdilate(b,ee);           
prop = regionprops(b,'all');    % Propiedades de la imagen (Para el ángulo)
N = length(prop);               % Número de propiedades encontradas
if N ~= 1                       % Si es diferente de 1, el esqueje no fue
                                % encontrado.
    close(h);
    %figure(1); imshow(imagenSinModificar);
    msgbox('No se ha encontrado un esqueje en la imagen','Error','error');
    error('No se ha encontrado un esqueje en la imagen');
end
theta = prop(N).Orientation;    % Obtener el ángulo de orientación
b = imrotate(b,-theta/2,'crop');% Orientar -theta medios para alinear con
                                % el eje horizontal, rotar también la
                                % imagen original
originalImage = imrotate(imagen, -theta / 2, 'crop');
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
%% Encontrar el tallo
prop = regionprops(b,'all');    % Propiedades de la nueva imagen
box = prop.BoundingBox();
inicio_columnas = uint64(ceil(box(1)));
fin_columnas = uint64(inicio_columnas + box(3));
inicio_j = uint64(ceil(box(2)));
fin_j = uint64(ceil(box(2)) + box(4));
columnas = zeros(fin_columnas-inicio_columnas,1);
for i = inicio_columnas:fin_columnas
    %waitbar(double((i-inicio_raiz)/(fin_columnas-inicio_columnas)));
    columna = b(:,i,:);
    columnas(i-inicio_columnas+1) = alto_de_columna(inicio_j,columna,fin_j);
end
columna_mas_grande = max(columnas);
columnas(columnas > 40) = 0;
columnas(columnas>columna_mas_grande*0.2) = 0;
i = 1;
while(columnas(i)==0)
    i = i + 1;
end
j = i + 1;
while(columnas(j)~=0)
    j = j + 1;
end
while(j-i<40)
    i = j;
    while(columnas(i)==0)
        i = i + 1;
    end
    j = i + 1;
    while(columnas(j)~=0)
        j = j + 1;
    end
end
i = i + inicio_columnas;
j = j + inicio_columnas;
tallo_b = b;
tallo_b(:,1:i) = 0;
tallo_b(:,j:end) = 0;
nueva_b=[255*tallo_b,255*tallo_b,255*tallo_b];
nueva_b=reshape(nueva_b,[fil,col,cap]);
figure(1); imshow(nueva_b); impixelinfo
%% Girar con el ángulo del tallo
prop = regionprops(tallo_b,'all');    % Propiedades de la nueva imagen
theta = prop(1).Orientation;
disp(strcat('Theta: ', num2str(theta)));
b = imrotate(b,-theta/2,'crop');% Orientar -theta medios para alinear con
                                % el eje horizontal, rotar también la
                                % imagen original
originalImage = imrotate(originalImage, -theta / 2, 'crop');
%% Recortar imágenes
nueva_b=[b,b,b];                        % Hacer que la capa binaria mida lo mismo
                                        % que la imagen original
nueva_b=reshape(nueva_b,[fil,col,cap]); % Con el tamaño de la imagen original
originalImage(nueva_b==0)=0;            % Recortar los elementos que estén en 0
waitbar(1);
close(h);
%% Mostrar resultado de la alineación
%figure(3); imshow(originalImage); impixelinfo;
%msgbox('Imagen del esqueje orientado, presione Aceptar para continuar','Info','info');
%% Largo del esqueje
prop = regionprops(b,'all');                    % Propiedades de la nueva imagen
box = prop(1).BoundingBox;                      % Bounding box del esqueje
largo_esqueje = box(3);                         % Largo en pixeles del esqueje
largo_esqueje = largo_esqueje * escala_palito;  
area = prop(1).Area * escala_palito * escala_palito;
%if largo_esqueje > largo 
%    msgbox(strcat('El esqueje es más largo que el máximo: ',num2str(largo_esqueje),' cm'),'Esqueje descartado','info');
%    error('Esqueje largo');
%end
%if largo_esqueje < corto 
%    msgbox(strcat('El esqueje es más corto que el mínimo: ',num2str(largo_esqueje),' cm'),'Esqueje descartado','info');
%    error('Esqueje corto');
%end
%msgbox(strcat('El largo del esqueje es : ',num2str(largo_esqueje),' cm'),'Largo del esqueje aceptado','info');
%% Distancia a primera hoja
inicio_raiz = uint64(ceil(box(1)));
fin_esqueje = uint64(inicio_raiz + box(3));
fin_esqueje_y = uint64(ceil(box(2)) + box(4));
inicio_j = uint64(ceil(box(2)));
h = waitbar(0,'Verificando distancia a la primera hoja...');
for i = inicio_raiz:fin_esqueje
    waitbar(double((i-inicio_raiz)/(fin_esqueje-inicio_raiz)));
    columna = b(:,i,:);
    alto_columna = alto_de_columna(inicio_j,columna,fin_esqueje_y);
    if exist('primer_alto_columna','var')
        if alto_columna == primer_alto_columna + primer_alto_columna * 0.5
            distancia_primera_hoja = i-inicio_raiz;
            break;
        end
    else
        if alto_columna > 25
            primer_alto_columna = alto_columna;
        end
    end
end
close(h);
if exist('distancia_primera_hoja','var')
    originalImage(:,i-5:i+5,1)=255;
    distancia_primera_hoja = double(distancia_primera_hoja) * escala_palito * 10;
    %if distancia_primera_hoja < primera_hoja
    %    msgbox(strcat('Distancia a la primera hoja muy corto: ', num2str(distancia_primera_hoja), 'mm'),'Esqueje descartado','info');
    %else
    %    msgbox(strcat('Distancia a la primera hoja aceptable: ', num2str(distancia_primera_hoja), 'mm'),'Esqueje aceptado','info');
    %end
    hoja_en_base = distancia_primera_hoja;
else
    %msgbox('El esqueje no tiene hoja en base','Esqueje descartado','info');
    hoja_en_base = -1;
end
largo = largo_esqueje;
imagen_alineada = originalImage;
end

