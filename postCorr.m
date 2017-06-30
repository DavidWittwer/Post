function varargout = postCorr(varargin)
% POSTCORR M-file for postCorr.fig
%      POSTCORR, by itself, creates a new POSTCORR or raises the existing
%      singleton*.
%
%      H = POSTCORR returns the handle to a new POSTCORR or the handle to
%      the existing singleton*.
%
%      POSTCORR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSTCORR.M with the given input arguments.
%
%      POSTCORR('Property','Value',...) creates a new POSTCORR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before postCorr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to postCorr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help postCorr

% Last Modified by GUIDE v2.5 10-Jul-2014 10:01:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @postCorr_OpeningFcn, ...
                   'gui_OutputFcn',  @postCorr_OutputFcn, ...
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


% --- Executes just before postCorr is made visible.
function postCorr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to postCorr (see VARARGIN)

% Choose default command line output for postCorr
handles.output = hObject;

% --dcw-- Cell array containing each set of antenna data
%         Format  { Costants ProductModelName MeasDate DataPath S11 freq CPgain XPgain
%         CPphase XPphase Totgain }
handles.ant{1} = { [] [] [] [] [] [] [] [] [] [] [] };
handles.ant{2} = { [] [] [] [] [] [] [] [] [] [] [] };

handles.outputDir = '';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes postCorr wait for user response (see UIRESUME)
% uiwait(handles.figMain);


% --- Outputs from this function are returned to the command line.
function varargout = postCorr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnExit.
function btnExit_Callback(hObject, eventdata, handles)
% hObject    handle to btnExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close('all');


function tbxAnt1Dir_Callback(hObject, eventdata, handles)
% hObject    handle to tbxAnt1Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxAnt1Dir as text
%        str2double(get(hObject,'String')) returns contents of tbxAnt1Dir as a double


% --- Executes during object creation, after setting all properties.
function tbxAnt1Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxAnt1Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxAnt2Dir_Callback(hObject, eventdata, handles)
% hObject    handle to tbxAnt2Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxAnt2Dir as text
%        str2double(get(hObject,'String')) returns contents of tbxAnt2Dir as a double


% --- Executes during object creation, after setting all properties.
function tbxAnt2Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxAnt2Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxOutputDir_Callback(hObject, eventdata, handles)
% hObject    handle to tbxOutputDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxOutputDir as text
%        str2double(get(hObject,'String')) returns contents of tbxOutputDir as a double


% --- Executes during object creation, after setting all properties.
function tbxOutputDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxOutputDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSetAnt1Dir.
function btnSetAnt1Dir_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetAnt1Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiText = 'Antenna 1 Howland data directory';
set(handles.lblStatus,'string',uiText);
dataDir = getDirectory(uiText, handles.ant{1}{4});
handles.ant{1}{4} = dataDir;

% Update handles structure
set(handles.tbxAnt1Dir,'String',dataDir);
set(handles.lblStatus,'String','Ready ...');
guidata(hObject, handles);
cd(dataDir);


% --- Executes on button press in btnSetAnt2Dir.
function btnSetAnt2Dir_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetAnt2Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiText = 'Antenna 2 Howland data directory';
set(handles.lblStatus,'string',uiText);
dataDir = getDirectory(uiText, handles.ant{2}{4});
handles.ant{2}{4} = dataDir;

% Update handles structure
set(handles.tbxAnt2Dir,'String',dataDir);
set(handles.lblStatus,'String','Ready ...');
guidata(hObject, handles);
cd(dataDir);


% --- Executes on button press in btnSetOutputDir.
function btnSetOutputDir_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetOutputDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiText = 'Output data directory';
set(handles.lblStatus,'string',uiText);
dataDir = getDirectory(uiText, handles.outputDir);
handles.outputDir = dataDir;

% Update handles structure
set(handles.tbxOutputDir,'String',dataDir);
set(handles.lblStatus,'String','Ready ...');
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function btnExit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btnExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over tbxAnt1Dir.
function tbxAnt1Dir_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to tbxAnt1Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
btnSetAnt1Dir_Callback(hObject, eventdata, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over tbxAnt2Dir.
function tbxAnt2Dir_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to tbxAnt2Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
btnSetAnt2Dir_Callback(hObject, eventdata, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over tbxOutputDir.
function tbxOutputDir_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to tbxOutputDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
btnSetOutputDir_Callback(hObject, eventdata, handles);


% --- Executes on button press in btnCalculate.
function btnCalculate_Callback(hObject, eventdata, handles)
% hObject    handle to btnCalculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainLoadMultipleDataSets(hObject, eventdata, handles);

%         Format  { Costants ProductModelName MeasDate DataPath S11 freq CPgain XPgain
%         CPphase XPphase Totgain }

corr  = calcCorrelation( handles.ant{1}, handles.ant{2}, get(handles.tbxOutputDir,'String') );
plot(corr(:,1), corr(:,2));
guidata(hObject, handles);

