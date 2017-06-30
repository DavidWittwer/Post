function mainPlanetOutput(hObject, eventdata, handles)

    % Get user input with serparte GUI
    prodSelectedID = get(handles.cmbxProductInfo,'Value');
    prodList = get(handles.cmbxProductInfo,'String');
    prodName = prodList{prodSelectedID};
    
    SwapVH = get(handles.cbSwapVH,'Value');
    invThe = get(handles.cbPlanetThetaInvert,'Value');
    
    plotSlantPolarization = get(handles.cbPlotSlantPolarizations,'Value');
    switch(plotSlantPolarization)
        case true
            data = handles.Totgainslant;
        case false
            data = handles.Totgain;
    end
    
    switch( get(handles.cbPFuseMaxGain,'Value') )
        case true
            CreatePlanetFiles3( handles.DataPath, handles.Constants, prodName, handles.portLabel, handles.freq, data, plotSlantPolarization, invThe, SwapVH );
        case false
            PFtheta = str2double(get(handles.tbxPFtheta,'String'));
            PFphi   = str2double(get(handles.tbxPFphi,'String'));
            CreatePlanetFiles3( handles.DataPath, handles.Constants, prodName, handles.portLabel, handles.freq, data, plotSlantPolarization, invThe, SwapVH, PFtheta, PFphi );
    end
    
return;
