function [ image ] = chooseAndRead()
%CHOOSEANDREAD Summary of this function goes here
%   Detailed explanation goes here
filename=uigetfile('3_Esquejes/*.TIFF');
filename=strcat('3_Esquejes/', filename);
fprintf('File to be analyzed: %s\n',filename);
image = imread(filename);
end

