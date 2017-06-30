function varargout = GeoPlanGetInfo(varargin)
% GEOPLANGETINFO M-file for GeoPlanGetInfo.fig
%      GEOPLANGETINFO, by itself, creates a new GEOPLANGETINFO or raises the existing
%      singleton*.
%
%      H = GEOPLANGETINFO returns the handle to a new GEOPLANGETINFO or the handle to
%      the existing singleton*.
%
%      GEOPLANGETINFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GEOPLANGETINFO.M with the given input arguments.
%
%      GEOPLANGETINFO('Property','Value',...) creates a new GEOPLANGETINFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeoPlanGetInfo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeoPlanGetInfo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GeoPlanGetInfo

% Last Modified by GUIDE v2.5 12-Apr-2013 15:58:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GeoPlanGetInfo_OpeningFcn, ...
                   'gui_OutputFcn',  @GeoPlanGetInfo_OutputFcn, ...
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


% --- Executes just before GeoPlanGetInfo is made visible.
function GeoPlanGetInfo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GeoPlanGetInfo (see VARARGIN)

% Choose default command line output for GeoPlanGetInfo
handles.output = hObject;

handles.label = getProductInfo('default');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GeoPlanGetInfo wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GeoPlanGetInfo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.label;

% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in btnOK.
function btnOK_Callback(hObject, eventdata, handles)
% hObject    handle to btnOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;

% --- Executes on button press in btnCancel.
function btnCancel_Callback(hObject, eventdata, handles)
% hObject    handle to btnCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.label = getProductInfo('default');
close all;


function tbxModelName_Callback(hObject, eventdata, handles)
% hObject    handle to tbxModelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxModelName as text
%        str2double(get(hObject,'String')) returns contents of tbxModelName as a double
handles.label.ModelName = get(handles.tbxModelName,'String');

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tbxModelName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxModelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxManufacturer_Callback(hObject, eventdata, handles)
% hObject    handle to tbxManufacturer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxManufacturer as text
%        str2double(get(hObject,'String')) returns contents of tbxManufacturer as a double
handles.label.Manufacturer = get(handles.tbxManufacturer,'String');

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tbxManufacturer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxManufacturer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxDescription_Callback(hObject, eventdata, handles)
% hObject    handle to tbxDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxDescription as text
%        str2double(get(hObject,'String')) returns contents of tbxDescription as a double
handles.label.Description = get(handles.tbxDescription,'String');

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tbxDescription_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxElectricalTilt_Callback(hObject, eventdata, handles)
% hObject    handle to tbxElectricalTilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxElectricalTilt as text
%        str2double(get(hObject,'String')) returns contents of tbxElectricalTilt as a double
handles.label.Electrical_Tilt = str2double( get(handles.tbxElectricalTilt,'String') );

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tbxElectricalTilt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxElectricalTilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxHeight_Callback(hObject, eventdata, handles)
% hObject    handle to tbxHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxHeight as text
%        str2double(get(hObject,'String')) returns contents of tbxHeight as a double
handles.label.Height_m = str2double( get(handles.tbxHeight,'String') );
%changes tobi - OLD - NOT WORKING: handles.label.Height_m = spritnf('%5.3f', str2double( get(handles.tbxHeight,'String') ) );
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tbxHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxWidth_Callback(hObject, eventdata, handles)
% hObject    handle to tbxWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxWidth as text
%        str2double(get(hObject,'String')) returns contents of tbxWidth as a double
handles.label.Width_m = str2double( get(handles.tbxWidth,'String') );

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tbxWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxDepth_Callback(hObject, eventdata, handles)
% hObject    handle to tbxDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxDepth as text
%        str2double(get(hObject,'String')) returns contents of tbxDepth as a double
handles.label.Depth_m = str2double( get(handles.tbxDepth,'String') );

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tbxDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxWeight_Callback(hObject, eventdata, handles)
% hObject    handle to tbxWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxWeight as text
%        str2double(get(hObject,'String')) returns contents of tbxWeight as a double
handles.label.Weight_kg = str2double( get(handles.tbxWeight,'String') );

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tbxWeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cmbxPolarity.
function cmbxPolarity_Callback(hObject, eventdata, handles)
% hObject    handle to cmbxPolarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns cmbxPolarity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cmbxPolarity
handles.label.Polarization = get(handles.cmbxPolarity,'Value') - 1;

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cmbxPolarity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmbxPolarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cmbxAntennaType.
function cmbxAntennaType_Callback(hObject, eventdata, handles)
% hObject    handle to cmbxAntennaType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns cmbxAntennaType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cmbxAntennaType
handles.label.Antenna_Type = get(handles.cmbxAntennaType,'Value') - 1;

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cmbxAntennaType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmbxAntennaType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cmbxPreset.
function cmbxPreset_Callback(hObject, eventdata, handles)
% hObject    handle to cmbxPreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns cmbxPreset contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cmbxPreset
selectedIndex = get(hObject,'Value');
selectedPreset = get(handles.cmbxPreset,'String');
if( selectedIndex ~= 1 ) 
    handles.label = getProductInfo( selectedPreset{selectedIndex} );
end

% Update handles structure
guidata(hObject, handles);
update_labels(handles);


% --- Executes during object creation, after setting all properties.
function cmbxPreset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmbxPreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on btnOK and no controls selected.
function btnOK_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to btnOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

if isequal (get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, use UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


function update_labels(handles)
set(handles.tbxModelName,'String',handles.label.ModelName);
set(handles.tbxManufacturer,'String',handles.label.Manufacturer);
set(handles.tbxDescription,'String',handles.label.Description);
set(handles.cmbxAntennaType,'Value',handles.label.Antenna_Type+1);
set(handles.cmbxPolarity,'Value',handles.label.Polarization+1);
set(handles.tbxElectricalTilt,'String',sprintf('%4.3f',handles.label.Electrical_Tilt));
set(handles.tbxHeight,'String',sprintf('%4.3f',handles.label.Height_m));
set(handles.tbxWidth,'String',sprintf('%4.3f',handles.label.Width_m));
set(handles.tbxDepth,'String',sprintf('%4.3f',handles.label.Depth_m));
set(handles.tbxWeight,'String',sprintf('%4.3f',handles.label.Weight_kg));



% --- Executes on key press with focus on tbxModelName and no controls selected.
function tbxModelName_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to tbxModelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.label.ModelName = get(handles.tbxModelName,'String');

% Update handles structure
guidata(hObject, handles);
