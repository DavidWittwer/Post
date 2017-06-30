function varargout = post(varargin)
% POST M-file for post.fig
%      POST, by itself, creates a new POST or raises the existing
%      singleton*.
%
%      H = POST returns the handle to a new POST or the handle to
%      the existing singleton*.
%
%      POST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POST.M with the given input arguments.
%
%      POST('Property','Value',...) creates a new POST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before post_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to post_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help post

% Last Modified by GUIDE v2.5 21-Aug-2015 17:16:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @post_OpeningFcn, ...
                   'gui_OutputFcn',  @post_OutputFcn, ...
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


% --- Executes just before post is made visible.
function post_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to post (see VARARGIN)

% Choose default command line output for post
handles.output = hObject;

handles.ProductModelName = '';

handles.Constants = 0;
handles.MeasDate = '';
handles.DataPath = '';
handles.S11 = 0;
handels.freq = 0;
handles.CPgain = 0;
handles.XPgain = 0;
handles.CPphase = 0;
handles.XPphase = 0;
handles.Totgain = 0;

handles.CPgainslant = 0;
handles.XPgainslant = 0;
handles.CPphaseslant = 0;
handles.XPphaseslant = 0;
handles.Totgainslant = 0;

handles.plotProperty = '';

handles.portLabel = 'P1';

[label prodInfo] = getProductInfo('default');
set(handles.cmbxProductInfo,'String',prodInfo);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes post wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = post_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rbNSI.
function rbNSI_Callback(hObject, eventdata, handles)
% hObject    handle to rbNSI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbNSI
set(handles.panelDataSelect,'Title','Select NSI Data Directory');
set(handles.txtS11NSI,'Visible','on');
set(handles.txtS11Path,'Visible','on');
set(handles.btnBrowseS11,'Visible','on');

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in rbSatimo.
function rbSatimo_Callback(hObject, eventdata, handles)
% hObject    handle to rbSatimo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbSatimo
set(handles.panelDataSelect,'Title','Select Satimo TRX file');
set(handles.txtS11NSI,'Visible','off');
set(handles.txtS11Path,'Visible','off');
set(handles.btnBrowseS11,'Visible','off');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update status bar
guidata(hObject, handles);

set(handles.txtStatus,'String',sprintf('Loading data files (please wait) ...'));
handles = guidata(hObject);

dataPath = get(handles.txtDataPath,'String');
handles.DataPath = dataPath;
handles = guidata(hObject);

%% Load the data
%mainLoadData(hObject, eventdata, handles);
mainLoadData_new(hObject, eventdata, handles); %addition

% Update the GUI handles after the subroutine makes changes
handles = guidata(hObject);
    
% Update status bar
set(handles.txtStatus,'String',sprintf('Measurement Date:  %s',handles.MeasDate));

%% Compute auxillary quantities
if( get(handles.cbPlotSlantPolarizations,'Value') )
    [ handles.CPgainslant, handles.XPgainslant, handles.CPphaseslant, handles.XPphaseslant  ] = ComputeSlantPolarizations( handles.CPgain, handles.XPgain, handles.CPphase, handles.XPphase );
    % Compute the total power for the two field components
    [ handles.Totgainslant ] = ComputeTotalGain( handles.CPgainslant, handles.XPgainslant );
end

% Update handles structure
guidata(hObject, handles);

% Update the GUI handles after the subroutine makes changes
handles = guidata(hObject);

%% Compute efficiency
if( get(handles.cbEff,'Value') )

    % Update status bar
    set(handles.txtStatus,'String',sprintf('Computing efficiency ...'));

    disp(sprintf('Computing efficiency ...'));
    s11FileName = get(handles.txtS11Path,'String');
    %disp(sprintf('GUI:  S11 File Name = %s, No. Elements = %i',s11FileName,numel(s11FileName)));
    if( 0 ~= numel(s11FileName) )
        eff = calcEfficiency( handles.freq, handles.Totgain, handles.CPgain, handles.XPgain, handles.S11 );
    else
        eff = calcEfficiency( handles.freq, handles.Totgain, handles.CPgain, handles.XPgain );
    end
end

% Update handles structure
guidata(hObject, handles);

% Update the GUI handles after the subroutine makes changes
handles = guidata(hObject);


%% Create 2D plots
if( get(handles.cbPlot2D,'Value') )
    
    % Update status bar
    set(handles.txtStatus,'String',sprintf('Creating 2D Plots ...'));
    disp(sprintf('Creating 2D Plots ...'));
        
    main2DPlotOutput(hObject, eventdata, handles);  % Call the 2D Plot output routine
    
    % Update status bar
    %set(handles.txtStatus,'String',sprintf('Finished creating 2D Plots ...'));

end

%% Generate Planet output files
if( get(handles.cbPlanet,'Value') && strcmp('on',get(handles.panelPlanetFileRotation,'Visible')) )

    % Update status bar
    set(handles.txtStatus,'String',sprintf('Creating Planet files ...'));
    disp(sprintf('Creating Planet files ...'));

    mainPlanetOutput(hObject, eventdata, handles);  % Call the Planet File output routine

    % Update status bar
    %set(handles.txtStatus,'String',sprintf('Finished creating Planet files ...'));

end

%% Generate GeoPlan output files
%%if( get(handles.cbGeoPlan,'Value') && strcmp('on',get(handles.panelPlanetFileRotation,'Visible')) )
if( get(handles.cbGeoPlan,'Value')  )

    % Update status bar
    set(handles.txtStatus,'String',sprintf('Creating GeoPlan files ...'));
    disp(sprintf('Creating GeoPlan files ...'));

    mainGeoPlanOutput(hObject, eventdata, handles); % Call the GeoPlan File output routine
    
    % Update status bar
    %set(handles.txtStatus,'String',sprintf('Finished creating GeoPlan files ...'));

end

%% Create ATOL  file
%%if( get(handles.cbAtol,'Value') && strcmp('on',get(handles.panelPlanetFileRotation,'Visible')) )
outAtol = get(handles.cbAtol,'Value') | get(handles.cbAtol2D_Excel,'Value') ;
if( outAtol  )
    % Update status bar
    set(handles.txtStatus,'String',sprintf('Creating ATOL output files ...'));
    disp(sprintf('Creating ATOL files ...'));

    mainAtolOutput(hObject, eventdata, handles);    % Call the Atol File output routine

    % Update status bar
    %set(handles.txtStatus,'String',sprintf('Finished creating ATOL files ...'));

end

%% Generate 3D Atol Output Text files
if( get(handles.cbAtol3D,'Value') )
   
    % Update status bar
    set(handles.txtStatus,'String',sprintf('Creating 3D Atol Output files ...'));
    disp(sprintf('Creating 3D Atol Output files ...'));
    
    mainOutputAtol3D(hObject, eventdata, handles); % Call the ATT Text file output routine
    
end

%% Generate NSI output files
%%if( get(handles.cbGeoPlan,'Value') && strcmp('on',get(handles.panelPlanetFileRotation,'Visible')) )
if( get(handles.cbOutputNSI,'Value')  )

    % Update status bar
    set(handles.txtStatus,'String',sprintf('Creating NSI Output files ...'));
    disp(sprintf('Creating NSI Output files ...'));

    mainOutputNSI(hObject, eventdata, handles); % Call the GeoPlan File output routine
    
    % Update status bar
    %set(handles.txtStatus,'String',sprintf('Finished creating GeoPlan files ...'));

end


%% Generate 3D Atol Output Text files
if( get(handles.cbNormCSV,'Value') )
   
    % Update status bar
    set(handles.txtStatus,'String',sprintf('Creating Normalized 3D Output files ...'));
    disp(sprintf('Creating Normalized 3D Output files ...'));
    
    mainOutputNorm3D(hObject, eventdata, handles); % Call the ATT Text file output routine
    
end


%% Generate 3D plots
if( get(handles.cbCreate3DPlots,'Value') )
    nsiPlot3D( handles.freq, handles.DataPath, handles.Totgain, handles.CPgain, handles.XPgain );
end

%% Update status bar
set(handles.txtStatus,'String',sprintf('Ready ...'));
disp(sprintf('Done ...'));

% Update handles structure
guidata(hObject, handles);

cd('..');

fclose('all');
disp(sprintf('Antenna Post processing complete for %s', ...
    get(handles.txtDataPath,'String') ...
    ));

%%

% --- Executes on button press in cbPlotSlantPolarizations.
function cbPlotSlantPolarizations_Callback(hObject, eventdata, handles)
% hObject    handle to cbPlotSlantPolarizations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbPlotSlantPolarizations


% --- Executes on button press in cbPlanet.
function cbPlanet_Callback(hObject, eventdata, handles)
% hObject    handle to cbPlanet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbPlanet
setUserDefinedCutPlaneVisibility(hObject, eventdata, handles);


% --- Executes on button press in cbCreate3DPlots.
function cbCreate3DPlots_Callback(hObject, eventdata, handles)
% hObject    handle to cbCreate3DPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbCreate3DPlots


function txtTheta_Callback(hObject, eventdata, handles)
% hObject    handle to txtTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTheta as text
%        str2double(get(hObject,'String')) returns contents of txtTheta as a double


% --- Executes during object creation, after setting all properties.
function txtTheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtPhi_Callback(hObject, eventdata, handles)
% hObject    handle to txtPhi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPhi as text
%        str2double(get(hObject,'String')) returns contents of txtPhi as a double


% --- Executes during object creation, after setting all properties.
function txtPhi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPhi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtAzRotAngle_Callback(hObject, eventdata, handles)
% hObject    handle to txtAzRotAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtAzRotAngle as text
%        str2double(get(hObject,'String')) returns contents of txtAzRotAngle as a double


% --- Executes during object creation, after setting all properties.
function txtAzRotAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAzRotAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtElRotAngle_Callback(hObject, eventdata, handles)
% hObject    handle to txtElRotAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtElRotAngle as text
%        str2double(get(hObject,'String')) returns contents of txtElRotAngle as a double


% --- Executes during object creation, after setting all properties.
function txtElRotAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtElRotAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbSwapVH.
function cbSwapVH_Callback(hObject, eventdata, handles)
% hObject    handle to cbSwapVH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbSwapVH



% --- Executes on button press in btnExit.
function btnExit_Callback(hObject, eventdata, handles)
% hObject    handle to btnExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear('all');
fclose('all');
close('all');



% --- Executes on button press in cbPlanetThetaInvert.
function cbPlanetThetaInvert_Callback(hObject, eventdata, handles)
% hObject    handle to cbPlanetThetaInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbPlanetThetaInvert


% --- Executes on button press in cbPFuseMaxGain.
function cbPFuseMaxGain_Callback(hObject, eventdata, handles)
% hObject    handle to cbPFuseMaxGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbPFuseMaxGain
switch( get(handles.cbPFuseMaxGain,'Value') )
    case true
        set(handles.text10,'Enable','off');
        set(handles.tbxPFtheta,'Enable','off');
        set(handles.text12,'Enable','off');
        set(handles.text11,'Enable','off');
        set(handles.tbxPFphi,'Enable','off');
        set(handles.text13,'Enable','off');
    case false
        set(handles.text10,'Enable','on');
        set(handles.tbxPFtheta,'Enable','on');
        set(handles.text12,'Enable','on');
        set(handles.text11,'Enable','on');
        set(handles.tbxPFphi,'Enable','on');
        set(handles.text13,'Enable','on');
end


function tbxPFtheta_Callback(hObject, eventdata, handles)
% hObject    handle to tbxPFtheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxPFtheta as text
%        str2double(get(hObject,'String')) returns contents of tbxPFtheta as a double


% --- Executes during object creation, after setting all properties.
function tbxPFtheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxPFtheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxPFphi_Callback(hObject, eventdata, handles)
% hObject    handle to tbxPFphi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxPFphi as text
%        str2double(get(hObject,'String')) returns contents of tbxPFphi as a double


% --- Executes during object creation, after setting all properties.
function tbxPFphi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxPFphi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rbHowland.
function rbHowland_Callback(hObject, eventdata, handles)
% hObject    handle to rbHowland (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbHowland
set(handles.panelDataSelect,'Title','Select Howland Data Directory');
set(handles.txtS11NSI,'Visible','off');
set(handles.txtS11Path,'Visible','off');
set(handles.btnBrowseS11,'Visible','off');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnBrowseS11.
function btnBrowseS11_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseS11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

S11dBmag = 0;

% Load the data
if( get(handles.rbNSI,'Value') )
    [ S11, S11Path ] = nsiReadS11File();
    A = nsiReadBeamList( S11Path );
    set(handles.txtS11Path,'String',S11Path);
    S11dBmag = zeros( size(A,1), 2);
    S11dBmag(:,1) = A;
    S11dBmag(:,2) = S11;
elseif( get(handles.rbSatimo,'Value') )
elseif( get(handles.rbHowland,'Value') )
    [ S11dBmag, S11Path ] = HowlandReadS11();
    set(handles.txtS11Path,'String',S11Path);
else
    set(handles.txtDataPath,'String','');
    S11dBmag = 0;
end

% Store the data in the handles object
handles.S11 = S11dBmag;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in cbEff.
function cbEff_Callback(hObject, eventdata, handles)
% hObject    handle to cbEff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbEff


% --- Executes on key press with focus on btnExit and no controls selected.
function btnExit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to btnExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cbGeoPlan.
function cbGeoPlan_Callback(hObject, eventdata, handles)
% hObject    handle to cbGeoPlan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbGeoPlan
setUserDefinedCutPlaneVisibility(hObject, eventdata, handles);

% --- Executes on button press in cbPlot2D.
function cbPlot2D_Callback(hObject, eventdata, handles)
% hObject    handle to cbPlot2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbPlot2D


% --- Executes on button press in btnAntennaInfo.
function btnAntennaInfo_Callback(hObject, eventdata, handles)
% hObject    handle to btnAntennaInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cbAtol.
function cbAtol_Callback(hObject, eventdata, handles)
% hObject    handle to cbAtol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbAtol
setUserDefinedCutPlaneVisibility(hObject, eventdata, handles);

function setUserDefinedCutPlaneVisibility(hObject, eventdata, handles)
    cbPlanetValue = get(handles.cbPlanet,'Value');
    cbGeoPlanValue = get(handles.cbGeoPlan,'Value');
    cbAtolValue = get(handles.cbAtol,'Value');

    if( cbPlanetValue || cbAtolValue || cbGeoPlanValue )
        set(handles.panelPlanetFileRotation,'Visible','on');
    else
        set(handles.panelPlanetFileRotation,'Visible','off');
        set(handles.cbGrpGeoPlanVer,'Visible','off');
    end

    if(cbGeoPlanValue)
        set(handles.cbGrpGeoPlanVer,'Visible','on');
    else
        set(handles.cbGrpGeoPlanVer,'Visible','off');
    end

    
return

% end of file


% --- Executes on selection change in cmbxProductInfo.
function cmbxProductInfo_Callback(hObject, eventdata, handles)
% hObject    handle to cmbxProductInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns cmbxProductInfo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cmbxProductInfo


% --- Executes during object creation, after setting all properties.
function cmbxProductInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmbxProductInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbOutputNSI.
function cbOutputNSI_Callback(hObject, eventdata, handles)
% hObject    handle to cbOutputNSI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbOutputNSI


% --- Executes on button press in cbAtol3D.
function cbAtol3D_Callback(hObject, eventdata, handles)
% hObject    handle to cbAtol3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbAtol3D


% --- Executes when selected object is changed in uipanel9.
function uipanel9_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel9 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cbNormCSV.
function cbNormCSV_Callback(hObject, eventdata, handles)
% hObject    handle to cbNormCSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbNormCSV


% --- Executes on button press in rbPort1.
function rbPort1_Callback(hObject, eventdata, handles)
% hObject    handle to rbPort1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbPort1
handles.portLabel = 'P1';
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in rbPort2.
function rbPort2_Callback(hObject, eventdata, handles)
% hObject    handle to rbPort2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbPort2
handles.portLabel = 'P2';
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in rbPort3.
function rbPort3_Callback(hObject, eventdata, handles)
% hObject    handle to rbPort3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbPort3
handles.portLabel = 'P3';
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in rbPort4.
function rbPort4_Callback(hObject, eventdata, handles)
% hObject    handle to rbPort4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbPort4
handles.portLabel = 'P4';
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in cbAtol2D_Excel.
function cbAtol2D_Excel_Callback(hObject, eventdata, handles)
% hObject    handle to cbAtol2D_Excel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbAtol2D_Excel

% --- Executes on button press in rbP45.
function rbP45_Callback(hObject, eventdata, handles)
% hObject    handle to rbP45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbP45
handles.portLabel = 'P45';
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in rbM45.
function rbM45_Callback(hObject, eventdata, handles)
% hObject    handle to rbM45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbM45
handles.portLabel = 'M45';
% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in GeoPlanVersion.
function GeoPlanVersion_Callback(hObject, eventdata, handles)
% hObject    handle to GeoPlanVersion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns GeoPlanVersion contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GeoPlanVersion


% --- Executes during object creation, after setting all properties.
function GeoPlanVersion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GeoPlanVersion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


