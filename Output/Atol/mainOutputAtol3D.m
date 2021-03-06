function mainOutputAtol3D(hObject, eventdata, handles)

    % Get user input with serparte GUI
    prodSelectedID = get(handles.cmbxProductInfo,'Value');
    prodList = get(handles.cmbxProductInfo,'String');
    prodName = prodList{prodSelectedID};
    
    
    plotSlantPolarization = get(handles.cbPlotSlantPolarizations,'Value');

    if(plotSlantPolarization)
        CreateAtol3DFiles( handles.DataPath, handles.freq, handles.Totgainslant, ...
            handles.MeasDate, handles.Constants, prodName, handles.portLabel );
    else
        CreateAtol3DFiles( handles.DataPath, handles.freq, handles.Totgain, ...
            handles.MeasDate, handles.Constants, prodName, handles.portLabel );
    end

return;
