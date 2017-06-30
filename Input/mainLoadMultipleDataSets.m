function mainLoadMultipleDataSets(hObject, eventdata, handles)

% --dcw-- Define local variables
debug = 0; % 0=false, 1=true

% --dcw-- Load antenna 1 data set
antInfo = handles.ant{1};
dataDir = antInfo{4};

disStr = sprintf('Loading antenna 1 data set');
disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
disp(sprintf('%s at path = %s',disStr,dataDir));
disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
set(handles.lblStatus,'string',disStr);

if( get(handles.rbNSIFormat,'Value') )
    %[ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, Constants, measDate ] = Load_NSI_Data();
elseif( get(handles.rbSatimoTRXFormat,'Value') )
    %[ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, Constants, measDate ] = Load_Satimo_Data();
elseif( get(handles.rbHowlandFormat,'Value') )
    if(debug)
        disp(sprintf('... Howland data for antenna 1 ...'));
    else
        [ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, Constants, measDate ] = Load_Howland_Data(dataDir);
    end
else
    return;
end

% Store loaded data into GUI handles (memory space)
%   Cell Array format:
%    { Costants ProductModelName MeasDate DataPath S11 freq CPgain XPgain CPphase XPphase Totgain }
if(~debug)
    antInfo{1} = Constants;
    antInfo{3} = measDate;
    antInfo{6} = freq;
    antInfo{7} = CPgain;
    antInfo{8} = XPgain;
    antInfo{9} = CPphase;
    antInfo{10} = XPphase;
    antInfo{11} = Totgain;
end

% Update handles structure
handles.ant{1} = antInfo;
set(handles.lblStatus,'string','Ready ...');
%guidata(hObject, handles);

% --dcw-- Load antenna 2 data set
ant2Info = handles.ant{2};
dataDir = ant2Info{4};

disStr = sprintf('Loading antenna 2 data set');
disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
disp(sprintf('%s at path = %s',disStr,dataDir));
disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
set(handles.lblStatus,'string',disStr);

if( get(handles.rbNSIFormat,'Value') )
    %[ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, Constants, measDate ] = Load_NSI_Data();
elseif( get(handles.rbSatimoTRXFormat,'Value') )
    %[ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, Constants, measDate ] = Load_Satimo_Data();
elseif( get(handles.rbHowlandFormat,'Value') )
    if(debug)
        disp(sprintf('... Howland data for antenna 2 ...'));
    else
        [ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, Constants, measDate ] = Load_Howland_Data(dataDir);
    end
else
    return;
end

% Store loaded data into GUI handles (memory space)
%   Cell Array format:
%    { Costants ProductModelName MeasDate DataPath S11 freq CPgain XPgain CPphase XPphase Totgain }
if(~debug)
    ant2Info{1} = Constants;
    ant2Info{3} = measDate;
    ant2Info{6} = freq;
    ant2Info{7} = CPgain;
    ant2Info{8} = XPgain;
    ant2Info{9} = CPphase;
    ant2Info{10} = XPphase;
    ant2Info{11} = Totgain;
end

% Update handles structure
handles.ant{2} = ant2Info;
set(handles.lblStatus,'string','Ready ...');
guidata(hObject, handles);

return;