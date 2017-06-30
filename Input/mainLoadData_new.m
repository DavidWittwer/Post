function mainLoadData_new(hObject, eventdata, handles)



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

DataPath1 = DataPath;
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

x = 1;
while(x == 1)
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

if (size(DataPath1) == size(DataPath))
if((DataPath1(1, 1:108) == DataPath(1, 1:108))) 
   if((DataPath1(1, 109) ~= DataPath(1, 109)))
       if((DataPath1(1, 110:length(DataPath)) == DataPath(1, 110:length(DataPath))))
             disp(sprintf('Correct Orthogonal File\n'));
             x = 0;
       else
           disp(sprintf('Incorrect Orthogonal File\n'));
           
       end
   else
       disp(sprintf('Incorrect Orthogonal File\n'));
       
   end
else
    disp(sprintf('Incorrect Orthogonal File\n'));
    
end
else
    disp(sprintf('Incorrect Orthogonal File\n'));
end
end

disp(sprintf('Main Load Data path = %s',DataPath));
handles.Constants_orth = Constants;
handles.MeasDate_orth = measDate;
handles.DataPath_orth = DataPath;

handles.freq_orth = freq;
handles.CPgain_orth = CPgain;
handles.XPgain_orth = XPgain;
handles.CPphase_orth = CPphase;
handles.XPphase_orth = XPphase;
handles.Totgain_orth = Totgain;


%if (((DataPath1(1, 1:108) == DataPath(1, 1:108)))&&((DataPath1(1, 109) ~= DataPath(1, 109)))&&((DataPath1(1, 110:length(DataPath)) == DataPath(1, 110:length(DataPath)))))
% if (size(DataPath1) == size(DataPath))
% if((DataPath1(1, 1:108) == DataPath(1, 1:108))) 
%    if((DataPath1(1, 109) ~= DataPath(1, 109)))
%        if((DataPath1(1, 110:length(DataPath)) == DataPath(1, 110:length(DataPath))))
%              disp(sprintf('Correct Orthogonal File\n'));
%        else
%            disp(sprintf('Incorrect Orthogonal File\n'));
%            
%        end
%    else
%        disp(sprintf('Incorrect Orthogonal File\n'));
%        
%    end
% else
%     disp(sprintf('Incorrect Orthogonal File\n'));
%     
% end
% else
%     disp(sprintf('Incorrect Orthogonal File\n'));
% end

set(handles.txtDataPath,'String',DataPath1);
  DataPath = DataPath1;

% Update handles structure
guidata(hObject, handles);

 return;