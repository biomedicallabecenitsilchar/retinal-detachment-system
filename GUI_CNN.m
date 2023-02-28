function varargout = GUI_CNN(varargin)
% GUI_CNN MATLAB code for GUI_CNN.fig
%      GUI_CNN, by itself, creates a new GUI_CNN or raises the existing
%      singleton*.
%
%      H = GUI_CNN returns the handle to a new GUI_CNN or the handle to
%      the existing singleton*.
%
%      GUI_CNN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CNN.M with the given input arguments.
%
%      GUI_CNN('Property','Value',...) creates a new GUI_CNN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_CNN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_CNN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_CNN

% Last Modified by GUIDE v2.5 03-Dec-2022 11:50:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_CNN_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_CNN_OutputFcn, ...
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
global I net

% --- Executes just before GUI_CNN is made visible.
function GUI_CNN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_CNN (see VARARGIN)

% Choose default command line output for GUI_CNN
handles.output = hObject;
load net 
handles.net = net;
axes1 = gca;
axes1.XAxis.Visible = 'off';   % remove y-axis
axes1.YAxis.Visible = 'off';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_CNN wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_CNN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
[fn pn] = uigetfile('*.jpg','select jpg file');
str = strcat(pn,fn);
set(handles.edit1,'string',str);
I = imread(str);
handles.I = I;
imshow(I, 'Parent', handles.axes1);
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
net = handles.net;
I = handles.I;
I= imresize(I,[224,224],'nearest');
[Pred,scores]  = classify(net,I);
scores = max(double(scores*100));
set(handles.pushbutton3,'string',join([string(Pred),'' ,scores ,'%']));

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
