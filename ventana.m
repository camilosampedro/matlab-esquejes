function varargout = ventana(varargin)
% VENTANA MATLAB code for ventana.fig
%      VENTANA, by itself, creates a new VENTANA or raises the existing
%      singleton*.
%
%      H = VENTANA returns the handle to a new VENTANA or the handle to
%      the existing singleton*.
%
%      VENTANA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VENTANA.M with the given input arguments.
%
%      VENTANA('Property','Value',...) creates a new VENTANA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ventana_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ventana_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ventana

% Last Modified by GUIDE v2.5 21-Oct-2016 11:01:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ventana_OpeningFcn, ...
                   'gui_OutputFcn',  @ventana_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ventana is made visible.
function ventana_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ventana (see VARARGIN)

% Choose default command line output for ventana
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ventana wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ventana_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_analizar.
function btn_analizar_Callback(hObject, eventdata, handles)
% hObject    handle to btn_analizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originalImage
[imagenAlineada,largo,hoja_en_base,area]=analizar(originalImage);
maximo_usuario = str2double(get(handles.edit1, 'string'));
minimo_usuario = str2double(get(handles.edit2, 'string'));
hoja_en_base_usuario = str2double(get(handles.edit3, 'string'));
if largo > maximo_usuario
    clase = 'Esqueje largo: ';
else
    if largo < minimo_usuario
        clase = 'Esqueje corto: ';
    else
        clase = 'Esqueje con longitud aceptable: ';
    end
end
if hoja_en_base < hoja_en_base_usuario
    clase_hoja_en_base = 'Distancia hoja en base muy pequeña: ';
else
    clase_hoja_en_base = 'Distancia aceptable hoja en base: ';
end
area = strcat('Area: ',num2str(area), 'cm^2');
imshow(imagenAlineada, 'Parent', handles.imagen_alineada);
set(handles.text2,'String',strcat(clase,num2str(largo),'. ',clase_hoja_en_base, num2str(hoja_en_base),area));


% --- Executes on button press in btn_abrir_archivo.
function btn_abrir_archivo_Callback(hObject, eventdata, handles)
% hObject    handle to btn_abrir_archivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originalImage
originalImage = chooseAndRead();
imshow(originalImage, 'Parent', handles.imagen_original);
