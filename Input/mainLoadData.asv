function mainLoadData(hObject, eventdata, handles)



if( get(handles.rbNSI,'Value') )
    [ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, Constants, measDate ] = Load_NSI_Data();
    set(handles.txtDataPath,'String',DataPath);
elseif( get(handles.rbSatimo,'Value') )
    [ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, Constants, measDate ] = Load_Satimo_Data();
    set(handles.txtDataPath,'String',DataPath);
elseif( get(handles.rbHowland,'Value') )
    [ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, Constants, measDate ] = Load_Howland_Data();
    set(handles.txtDataPath,'String',DataPath);
else
    set(handles.txtDataPath,'String','');
    return;
end

% Store loaded data into GUI handles (memory space)
%display(sprintf('Main Load Data Date = %s',measDate));
disp(sprintf('Main Load Data path = %s',DataPath));

handles.Constants = Constants;
handles.MeasDate = measDate;
handles.DataPath = DataPath;

handles.freq = freq;
handles.CPgain = CPgain;
handles.XPgain = XPgain;
handles.CPphase = CPphase;
handles.XPphase = XPphase;
handles.Totgain = Totgain;

handles.plotProperty = plotProperties( DataPath );

% Update handles structure
guidata(hObject, handles);

 return;