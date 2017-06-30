function main2DPlotOutput(hObject, eventdata, handles)

    plotProperty = plotProperties( handles.DataPath );

    %% Plot azimuth pattern
    if( get(handles.cbPlotSlantPolarizations,'Value') ) 
        plotProperty.copol_label = 'E_{+45} (CoPol) Component';
        plotProperty.xpol_label = 'E_{-45} (XPol) Component';
        
        [ CP XP TOT ] = scaleForPlotting( handles.CPgainslant, handles.XPgainslant, handles.Totgainslant, plotProperty );
        
        disp(sprintf('Plotting azimuth cuts ...'));
        angle = str2double(get(handles.txtTheta,'String'));
        PlotAzimuth( handles.freq, CP, XP, TOT, plotProperty, handles.DataPath, angle, handles.Constants );

        disp(sprintf('Plotting elevation cuts ...'));
        angle = str2double(get(handles.txtPhi,'String'));
        PlotElevation( handles.freq, CP, XP, TOT, plotProperty, handles.DataPath, angle, handles.Constants );

    else
        [ CP XP TOT ] = scaleForPlotting( handles.CPgain, handles.XPgain, handles.Totgain, handles.plotProperty );

        disp(sprintf('Plotting azimuth cuts ...'));
        angle = str2double(get(handles.txtTheta,'String'));
        PlotAzimuth( handles.freq, CP, XP, TOT, plotProperty, handles.DataPath, angle, handles.Constants );

        disp(sprintf('Plotting elevation cuts ...'));
        angle = str2double(get(handles.txtPhi,'String'));
        PlotElevation( handles.freq, CP, XP, TOT, plotProperty, handles.DataPath, angle, handles.Constants );

    end

return;