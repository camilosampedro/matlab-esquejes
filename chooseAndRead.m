function [ image ] = chooseAndRead()
%CHOOSEANDREAD Summary of this function goes here
%   Detailed explanation goes here
filename=uigetfile('3_Esquejes/*.TIFF');       % Obtener gráficamente el
                                               % nombre del archivo
filename=strcat('3_Esquejes/', filename);      % Agregarle el nombre de la
                                               % carpeta
fprintf('File to be analyzed: %s\n',filename); % Mostrarla en la stdout
image = imread(filename);                      % Leer la imagen del archivo
end

