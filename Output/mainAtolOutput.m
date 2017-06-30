function mainAtolOutput(hObject, eventdata, handles)

    % Get user input with serparte GUI
    prodSelectedID = get(handles.cmbxProductInfo,'Value');
    prodList = get(handles.cmbxProductInfo,'String');
    prodName = prodList{prodSelectedID};
    
    SwapVH = get(handles.cbSwapVH,'Value');
    invThe = get(handles.cbPlanetThetaInvert,'Value');
    
    outputTabDelimited = get(handles.cbAtol,'Value');
    outputExcel = get(handles.cbAtol2D_Excel,'Value');
    
    plotSlantPolarization = get(handles.cbPlotSlantPolarizations,'Value');
    switch(plotSlantPolarization)
        case true
            data = handles.Totgainslant;
        case false
            data = handles.Totgain;
    end
    
    switch( get(handles.cbPFuseMaxGain,'Value') )
        case true
            if(outputTabDelimited)
                CreateAtol2DCSVFile( handles.DataPath, handles.Constants, handles.freq, data, plotSlantPolarization, invThe, SwapVH, ...
                    handles.MeasDate, prodName, handles.portLabel );
            elseif(outputExcel)
                CreateAtolExcelFile2( handles.DataPath, handles.Constants, handles.freq, data, plotSlantPolarization, invThe, SwapVH, ...
                    handles.MeasDate, prodName, handles.portLabel );
            end
            
        case false
            PFtheta = str2double(get(handles.tbxPFtheta,'String'));
            PFphi   = str2double(get(handles.tbxPFphi,'String'));

            if(outputTabDelimited)
                CreateAtol2DCSVFile( handles.DataPath, handles.Constants, handles.freq, data, plotSlantPolarization, invThe, SwapVH, ...
                    handles.MeasDate, prodName, handles.portLabel, PFtheta, PFphi );
            elseif(outputExcel)
                CreateAtolExcelFile2( handles.DataPath, handles.Constants, handles.freq, data, plotSlantPolarization, invThe, SwapVH, ...
                    handles.MeasDate, prodName, handles.portLabel, PFtheta, PFphi );
            end

    end

return;
