function varargout = ch71(varargin)
% CH71 MATLAB code for ch71.fig
%      CH71, by itself, creates a new CH71 or raises the existing
%      singleton*.
%
%      H = CH71 returns the handle to a new CH71 or the handle to
%      the existing singleton*.
%
%      CH71('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CH71.M with the given input arguments.
%
%      CH71('Property','Value',...) creates a new CH71 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ch71_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ch71_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ch71

% Last Modified by GUIDE v2.5 16-Aug-2016 01:40:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ch71_OpeningFcn, ...
                   'gui_OutputFcn',  @ch71_OutputFcn, ...
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


% --- Executes just before ch71 is made visible.
function ch71_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ch71 (see VARARGIN)

% Choose default command line output for ch71
handles.output = hObject;
set(handles.inputbox,'string','0.00');
set(handles.balancebox,'string','500.00');
setappdata(handles.output,'balance',500);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ch71 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ch71_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function balancebox_Callback(hObject, eventdata, handles)
% hObject    handle to balancebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of balancebox as text
%        str2double(get(hObject,'String')) returns contents of balancebox as a double


% --- Executes during object creation, after setting all properties.
function balancebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to balancebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputbox_Callback(hObject, eventdata, handles)
% hObject    handle to inputbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputbox as text
%        str2double(get(hObject,'String')) returns contents of inputbox as a double


% --- Executes during object creation, after setting all properties.
function inputbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in withdraw.
function withdraw_Callback(hObject, eventdata, handles)
% hObject    handle to withdraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(handles.inputbox,'string'));
balance = getappdata(handles.output,'balance');
setappdata(handles.output,'balance',balance-input);
set(handles.balancebox,'string',num2str(balance-input));



% --- Executes on button press in deposit.
function deposit_Callback(hObject, eventdata, handles)
% hObject    handle to deposit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(handles.inputbox,'string'));
balance = getappdata(handles.output,'balance');
setappdata(handles.output,'balance',balance+input);
set(handles.balancebox,'string',num2str(balance+input));