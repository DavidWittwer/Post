function mainGeoPlanOutput(hObject, eventdata, handles)

    % Get user input with serparte GUI
    GeoPlanV3 = get(handles.rbGeoPlanV3,'Value');
    GeoPlanV5 = get(handles.rbGeoPlanV5,'Value');
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
            if(GeoPlanV3)
                CreateGeoPlanFiles( handles.DataPath, handles.freq, data, ...
                    plotSlantPolarization, invThe, SwapVH, handles.MeasDate, ...
                    handles.Constants, prodName );
            elseif(GeoPlanV5)
                CreateGeoPlanFiles_v5( handles.DataPath, handles.freq, data, ...
                    plotSlantPolarization, invThe, SwapVH, handles.MeasDate, ...
                    handles.Constants, prodName );
            end
        case false
            PFtheta = str2double(get(handles.tbxPFtheta,'String'));
            PFphi   = str2double(get(handles.tbxPFphi,'String'));
            if(GeoPlanV3)
                CreateGeoPlanFiles( handles.DataPath, handles.freq, data, ...
                    plotSlantPolarization, invThe, SwapVH, handles.MeasDate, ...
                    handles.Constants, prodName, PFtheta, PFphi );
            elseif(GeoPlanV5)
                CreateGeoPlanFiles_V5( handles.DataPath, handles.freq, data, ...
                    plotSlantPolarization, invThe, SwapVH, handles.MeasDate, ...
                    handles.Constants, prodName, PFtheta, PFphi );
            end
    end
    
return;