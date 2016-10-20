function [ corto, largo, primera_hoja ] = getLength()
%GETLENGTH Summary of this function goes here
%   Detailed explanation goes here
prompt = {'Largo máximo de los esquejes (cm):','Largo mínimo de los esquejes (cm):', 'Distancia de la base del tallo a la primera hoja(mm)'};
dlg_title = 'Entrada';
num_lines = 1;
defaultans = {'20','10','5'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
largo = answer(1);
corto = answer(2);
primera_hoja = answer(3);
end

