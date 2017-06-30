function [ success ] = CreateNSI_EL_Files( DataPath, freq, coPolGain, xPolGain, coPolPhase, xPolPhase, Date, prodName, portLabel, constants )
%CREATEGEOPLANFILES3 Summary of this function goes here
%   Detailed explanation goes here
DEBUG = 1;  % { 0 = no | 1 = yes }
success = false;
%nsiConstant = nsiConstants();

%% Process optional passed arguements


%% Find the maximum gain values for every frequency
numbeam1 = size(freq,1);
dPhi = constants.FF_dPHI;
dThe = constants.FF_dTH;
nPhi = constants.FF_nPHI;
thetaOffset = 180;
phi_cut_angle = 90;
iPhi = phi_cut_angle/dPhi + 1;


%% Create a directory to store the NSI Output files in (if it doesn't already
% exist)
cd(DataPath);

directory = dir('NSI_Output*');
if( 0 == size(directory,1) )
    mkdir('NSI_Output')
end

cd('NSI_Output');


%% Augment user supplied antenna details 
freq_MHz = freq(numbeam1)/1e6;
label = getProductInfo(prodName);

%% For each frequency, create a separate GeoPlan file
for i=1:numbeam1
    
    if(DEBUG) 
        display(sprintf('Writing NSI EL Output: frequency %i of %i.',i,numbeam1));
    end

    % Extract the pattern to work on
    elCut_coPolGain1 = coPolGain(:,iPhi,i);
    elCut_coPolGain2 = coPolGain(:,mod(iPhi+180,360),i);
    elCut_coPolGain = [ elCut_coPolGain1(1:end); flipud(elCut_coPolGain2(2:end)) ];
    elCut_coPolGain = circshift(elCut_coPolGain,-thetaOffset);
    
    elCut_coPolPhase1 = coPolPhase(:,iPhi,i);
    elCut_coPolPhase2 = coPolPhase(:,mod(iPhi+180,360),i);
    elCut_coPolPhase = [ elCut_coPolPhase1(1:end); flipud(elCut_coPolPhase2(2:end)) ];
    elCut_coPolPhase = circshift(elCut_coPolPhase,-thetaOffset);
    
    elCut_xPolGain1 = xPolGain(:,iPhi,i);
    elCut_xPolGain2 = xPolGain(:,mod(iPhi+180,361),i);
    elCut_xPolGain = [ elCut_xPolGain1(1:end); flipud(elCut_xPolGain2(2:end)) ];
    elCut_xPolGain = circshift(elCut_xPolGain,-thetaOffset);
    
    elCut_xPolPhase1 = xPolPhase(:,iPhi,i);
    elCut_xPolPhase2 = xPolPhase(:,mod(iPhi+180,361),i);
    elCut_xPolPhase = [ elCut_xPolPhase1(1:end); flipud(elCut_xPolPhase2(2:end)) ];
    elCut_xPolPhase = circshift(elCut_xPolPhase,-thetaOffset);
    

    % Find the location of the peak gain
    [maxCoPolGain idx] = max( coPolGain(:) );
    [iTheCoPolGain iPhiCoPolGain] = ind2sub(size(coPolGain),idx);

    [maxxPolGain idx] = max( xPolGain(:) );
    [iThexPolGain iPhixPolGain] = ind2sub(size(xPolGain),idx);
    
 
    % Create file name
    %[pathstr, name] = fileparts(DataPath); 
    name = [ label.Manufacturer, '_', label.ModelName, '_EL' ];
    fName = [ name, '_', num2str(ceil(freq(i)/1e6)), '_MHz_', portLabel, '.asc' ];
    fName = strrep(fName,' ','_');              % replace spaces with _
    %fName = strrep(fName,'_MLdata','');         % remove text from name
    
    % Open new GeoPlan file
    fid = fopen(fName,'wt');

    fprintf(fid,'Far-field amplitude, Eprincipal: Linear, Tau = 45.000  deg, X-pol at peak = -23.59  dB\n');
    fprintf(fid,'Gain = None  Max far-field (global) = 36.46103  dB, Max far-field (plot) = 36.43799  dB\n');
    fprintf(fid,'Normalization: None, Network offset = 0.000  dB\n');
    fprintf(fid,'Hpeak at: 91.169167  deg, Vpeak at: 1.350  deg\n');
    fprintf(fid,'Plot label centering: Off\n');
    fprintf(fid,'Directivity = 12.794  dB\n');
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'%s\n',label.ModelName);
    fprintf(fid,'SAMPLE 1\n');
    fprintf(fid,'FIXED T-0\n');
    fprintf(fid,'\n');
    fprintf(fid,'NSI2000 V4.9.18, Filename:\n');
    fprintf(fid,'Measurement date/time: %s, Filetype: NSI-97\n', Date);
    fprintf(fid,'Far-field display setup\n');
    fprintf(fid,'   Theta (deg)\n');
    fprintf(fid,'     Span = 360.000  deg, Center = 90.000  deg, #pts = 361  \n');
    fprintf(fid,'     Start= -90.000  deg, Stop = 270.000  deg, Delta = 1.000  deg\n');
    fprintf(fid,'   Phi (deg)\n');
    fprintf(fid,'     Center = 0.000  deg, #pts = 1 \n');
    fprintf(fid,'   Plot rotation= 0.000  deg\n');
    fprintf(fid,'   Interpolation: Cubic\n');
    fprintf(fid,'   Coordinate system: Th-Phi; Polarization: L2 Eth-Eph, Auto Tau: Off\n');
    fprintf(fid,'Far-field transform setup\n');
    fprintf(fid,'   FFT size:  2048,  32\n');
    fprintf(fid,'   Filter Mode: Max FF, Zoom: Off\n');
    fprintf(fid,'   Probe setup: Non-acquired (LBV_HBV_SNF 2014 0129 to Current.p97)\n');
    fprintf(fid,'   Probe model: Pattern file:   Probe-1: HBV_1850.th, Probe-2: HBV_1850.ph\n');
    fprintf(fid,'Selected beam(s) %i of %i\n', i, numbeam1);
    fprintf(fid,'Beam    Pol Sw    Beam Sw  Frequency       Phi axis  Azimuth\n');
    fprintf(fid,'----    ------    -------  ---------       --------  -------\n');
    fprintf(fid,'%i       Dual-pol  %i        %9.7f  GHz  Phi axis  Azimuth\n', i, i, freq(i)/1e9);
    fprintf(fid,'\n');
    fprintf(fid,'Near-field setup:\n');
    fprintf(fid,'Data - Preprocessed\n');
    fprintf(fid,'   Truncation: Off\n');
    fprintf(fid,'   Amplitude tapering: Off\n');
    fprintf(fid,'   Network correction: On\n');
    fprintf(fid,'   Probe/AUT Z-axis: On,K-correction: Off\n');
    fprintf(fid,'   MTIgain: Off, MTIphase: Off\n');
    fprintf(fid,'\n');
    fprintf(fid,'Near-field display setup:\n');
    fprintf(fid,'   Theta (deg)\n');
    fprintf(fid,'     Span = 180.0  deg, Center = 90.0  deg, #pts = 61 \n');
    fprintf(fid,'   Phi (deg)\n');
    fprintf(fid,'     Span = 360.00001  deg, Center = 180.000005  deg, #pts = 121 \n');
    fprintf(fid,'Network correction:(LBV_HBV_SNF 2014 0129 to Current.p97)\n');
    fprintf(fid,'Pol1(Ex) amp/phase: 0.000  dB, 0.000  deg\n');
    fprintf(fid,'Pol2(Ey) amp/phase: 0.000  dB, 0.000  deg\n');
    fprintf(fid,'Measured data:\n');
    fprintf(fid,'   Theta (deg)\n');
    fprintf(fid,'     Span = 179.999991  deg, Center = 89.999996  deg, #pts = 61   \n');
    fprintf(fid,'     Start= 0.000  deg, Stop = 179.999991  deg, Delta = 3.000  deg\n');
    fprintf(fid,'   Phi (Deg)\n');
    fprintf(fid,'     Span = 360.00001  deg, Center = 180.000005  deg, #pts = 121   \n');
    fprintf(fid,'     Start= 0.0  deg, Stop = 360.00001  deg, Delta = 3.000  deg\n');
    fprintf(fid,'   Aut Width/Height: 12.000  in, 71.999  in\n');
    fprintf(fid,'   H/V Max Far-field angles: 180.000005  deg, 180.000005  deg\n');
    fprintf(fid,'   Measurement radius: 133.500  in\n');
    fprintf(fid,'   MRE: 21.999999  in\n');
    fprintf(fid,'\n');
    fprintf(fid,'Measurement type: NF Spherical Theta-Phi\n');
    fprintf(fid,'Scan options: CV Off, CP On, Bi-dir On, V-scan \n');
    fprintf(fid,'Beamset smear: 0.00000  deg\n');
    fprintf(fid,'Probe setup as acquired: \n');
    fprintf(fid,'   Probe model: None\n');
    fprintf(fid,'   Probe-1: Lin-0(Ex), Probe-2:Lin-90(Ey)\n');
    fprintf(fid,'\n');
    fprintf(fid,'RF system:\n');
    fprintf(fid,'Integration time: 0.000 mSec\n');
    fprintf(fid,'Scan speed: 00.000000  deg/sec\n');
    fprintf(fid,'Drift during scan (final - initial)\n');
    fprintf(fid,'Amp/Phase initial =  00.00  dB,  0.0  deg\n');
    fprintf(fid,'Amp/Phase drift   =  0.00  dB,  0.0  deg\n');
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'   Theta (deg)  Phi (deg)    Amp      Phase   P-pol Data starts on next line:\n');


    % Data goes here for co-pol
    for k = 1 : size(elCut_coPolGain,1)
        fprintf(fid,'%9.3f %9.3f %9.3f %9.3f\n',(k-1)*dThe-180, phi_cut_angle, ...
            elCut_coPolGain(k), elCut_coPolPhase(k));
    end
    
    fprintf(fid,'\n');
    fprintf(fid,'   Theta (deg)  Phi (deg)    Amp      Phase   X-pol Data starts on next line:\n');
    
    % Data goes here for x-pol
    for k = 1 : size(elCut_xPolGain,1)
        fprintf(fid,'%9.3f %9.3f %9.3f %9.3f\n',(k-1)*dThe-180, phi_cut_angle, ...
            elCut_xPolGain(k), elCut_xPolPhase(k));
    end
    fprintf(fid,'\n');
    
    % Close the current file
    fclose(fid);
    
    %% Plot fields on xy-plot
    % Debug plot
    if(DEBUG)
        % Create figure
        figure1 = figure;

        % Create axes
        axes1 = axes('Parent',figure1);
        xlim([0 360]);
        ylim([-35 10]);
        hold('all');
        grid on;

        % Create surface

        the = ( linspace(1,size(elCut_coPolGain,1),361) - 1 ) .* dThe;
        plot1 = plot(the, [elCut_coPolGain'; elCut_xPolGain'], 'Parent',  axes1);
        set(plot1(1),'DisplayName','+45^o polarization');
        set(plot1(2),'DisplayName','-45^o polarization');

        % Create xlabel
        xlabel('Phi (deg)');

        % Create ylabel
        ylabel('Gain (dBi)');
        
        % Create title
        title(sprintf('Elevation Cut: %s, %s, %s MHz', label.ModelName, portLabel, num2str(ceil(freq(i)/1e6))));
        
        % Get xdata from plot
        xdata1 = get(plot1(1), 'xdata');
        
        % Get ydata from plot
        ydata1 = get(plot1(1), 'ydata');
        ydata2 = get(plot1(2), 'ydata');
        
        % Make sure data are column vectors
        xdata1 = xdata1(:);
        ydata1 = ydata1(:);
        ydata2 = ydata2(:);

        % Get axes xlim
        axXLim1 = get(axes1, 'xlim');

        % Find the max
        ymax1 = max(ydata1);
        ymax2 = max(ydata2);
        ymax = max(ymax1,ymax2) - 3;

        % Get coordinates for the max line
        maxValue1 = [ymax ymax];
        
        % Plot the max
        statLine1 = plot(axXLim1,maxValue1,'DisplayName','   max - 3dBi','Parent',axes1,...
            'Tag','max - 3dBi',...
            'LineStyle','-.',...
            'Color',[0 0 0]);

        % Set new line in proper position
        if(ymax1>ymax2)
            setLineOrder(axes1, statLine1, plot1(1));
        else
            setLineOrder(axes1, statLine1, plot1(2));
        end
        

        % Create legend
        legend1 = legend(axes1,'show');
        set(legend1,'Position',[0.598 0.16 0.2836 0.1114]);
        
        % Create textbox
        annotation(figure1,'textbox','String',sprintf('Measured:  %s',Date),...
        'LineStyle','none',...
        'FitBoxToText','off',...
        'Position',[0.6967 0.002653 0.2939 0.04775]);
    
        loc = [DataPath '/NSI_Output'];
        f = uint64( freq(i) / 1e6 );
        pfname = [strrep(fName,'.asc','') '.png'];         % remove text from name
        %pfname = sprintf('%s_%i4Mhz', fName, f );
        %disp(sprintf('Writing output file:  %s\n',pfname));
        Plot2File( figure1, loc, pfname );
    end

end
%% Return to previous directory
cd('..');
success = true;
return;

%-------------------------------------------------------------------------%
function setLineOrder(axesh1, newLine1, associatedLine1)
%SETLINEORDER(AXESH1,NEWLINE1,ASSOCIATEDLINE1)
%  Set line order
%  AXESH1:  axes
%  NEWLINE1:  new line
%  ASSOCIATEDLINE1:  associated line

% Get the axes children
hChildren = get(axesh1,'Children');
% Remove the new line
hChildren(hChildren==newLine1) = [];
% Get the index to the associatedLine
lineIndex = find(hChildren==associatedLine1);
% Reorder lines so the new line appears with associated data
hNewChildren = [hChildren(1:lineIndex-1);newLine1;hChildren(lineIndex:end)];
% Set the children:
set(axesh1,'Children',hNewChildren);
