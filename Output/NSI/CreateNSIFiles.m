function [ success ] = CreateNSIFiles( DataPath, freq, coPolGain, xPolGain, coPolPhase, xPolPhase, Date, prodName, constants )
%CREATEGEOPLANFILES3 Summary of this function goes here
%   Detailed explanation goes here
DEBUG = 1;  % { 0 = no | 1 = yes }
success = false;
%nsiConstant = nsiConstants();

%% Process optional passed arguements
plotSlantPol = 0;
if( exist('plotSlantPolarization', 'var') )
    plotSlantPol = plotSlantPolarization;
end


thetaOffset = 90;

%% Find the maximum gain values for every frequency
numbeam1 = size(freq,1);
dPhi = constants.FF_dPHI;
dThe = constants.FF_dTH;
nPhi = constants.FF_nPHI;
theta_cut_angle = 90;

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
        display(sprintf('Writing NSI Output: frequency %i of %i.',i,numbeam1));
    end
        
    % Extract the pattern to work on
    azCut_coPolGain = coPolGain(90,:,i);
    azCut_coPolPhase = coPolPhase(90,:,i);
    azCut_xPolGain = xPolGain(90,:,i);
    azCut_xPolPhase = xPolPhase(90,:,i);

    % Find the location of the peak gain
    [maxCoPolGain idx] = max( coPolGain(:) );
    [iTheCoPolGain iPhiCoPolGain] = ind2sub(size(coPolGain),idx);

    [maxxPolGain idx] = max( xPolGain(:) );
    [iThexPolGain iPhixPolGain] = ind2sub(size(xPolGain),idx);
    
 
    % Create file name
    %[pathstr, name] = fileparts(DataPath); 
    name = [ label.Manufacturer, '_', label.ModelName ];
    fName = [ name, '_', num2str(ceil(freq(i)/1e6)), '_MHz' , '.asc' ];
    fName = strrep(fName,' ','_');              % replace spaces with _
    fName = strrep(fName,'_MLdata','');         % remove text from name
    
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
    fprintf(fid,'ALPHA-AW3350\n');
    fprintf(fid,'SAMPLE 1\n');
    fprintf(fid,'FIXED T-0\n');
    fprintf(fid,'\n');
    fprintf(fid,'NSI2000 V4.9.18, Filename:C:\DATA 2 DUAL HORN\SPRINT MAY 2014\ALPHA\AW3350_SAMPLE 1\2ND T-0.nsi\n');
    fprintf(fid,'Measurement date/time: %s, Filetype: NSI-97\n', Date);
    fprintf(fid,'Far-field display setup\n');
    fprintf(fid,'   Theta (deg)\n');
    fprintf(fid,'     Center = 90.000  deg, #pts = 1 \n');
    fprintf(fid,'   Phi (deg)\n');
    fprintf(fid,'     Span = 360.000  deg, Center = 0.000  deg, #pts = 361  \n');
    fprintf(fid,'     Start= -180.000  deg, Stop = 180.000  deg, Delta = 1.000  deg\n');
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
    fprintf(fid,'     Span = 179.999991  deg, Center = 89.999996  deg, #pts = 37 \n');
    fprintf(fid,'   Phi (deg)\n');
    fprintf(fid,'     Span = 360.00001  deg, Center = 180.000005  deg, #pts = 73 \n');
    fprintf(fid,'Network correction:(LBV_HBV_SNF 2014 0129 to Current.p97)\n');
    fprintf(fid,'Pol1(Ex) amp/phase: 0.000  dB, 0.000  deg\n');
    fprintf(fid,'Pol2(Ey) amp/phase: 0.000  dB, 0.000  deg\n');
    fprintf(fid,'Measured data:\n');
    fprintf(fid,'   Theta (deg)\n');
    fprintf(fid,'     Span = 179.999991  deg, Center = 89.999996  deg, #pts = 37   \n');
    fprintf(fid,'     Start= 0.000  deg, Stop = 179.999991  deg, Delta = 5.000  deg\n');
    fprintf(fid,'   Phi (Deg)\n');
    fprintf(fid,'     Span = 360.00001  deg, Center = 180.000005  deg, #pts = 73   \n');
    fprintf(fid,'     Start= 0.0  deg, Stop = 360.00001  deg, Delta = 5.000  deg\n');
    fprintf(fid,'   Aut Width/Height: 5.250  in, 15.500  in\n');
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
    fprintf(fid,'Scan speed: 19.999997  deg/sec\n');
    fprintf(fid,'Drift during scan (final - initial)\n');
    fprintf(fid,'Amp/Phase initial =  00.00  dB,  0.0  deg\n');
    fprintf(fid,'Amp/Phase drift   =  0.00  dB,  0.0  deg\n');
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'   Theta (deg)  Phi (deg)    Amp      Phase   P-pol Data starts on next line:\n');

    % Data goes here for co-pol
    for k = 1, size(copol,1)
        fprintf(fid,'%9.3f %9.3f %9.3f %9.3f\n',theta_cut_angle, k*dPhi, azCut_coPolGain(k), azCut_coPolPhase(k));
    end
    
    fprintf(fid,'\n');
    fprintf(fid,'   Theta (deg)  Phi (deg)    Amp      Phase   X-pol Data starts on next line:\n');
    
    % Data goes here for x-pol
    for k = 1, size(xpol,1)
        fprintf(fid,'%9.3f %9.3f %9.3f %9.3f\n',theta_cut_angle, k*dPhi, azCut_xPolGain(k), azCut_xPolPhase(k));
    end
    fprintf(fid,'\n');
    
    % Close the current file
    fclose(fid);
    
end
%% Return to previous directory
cd('..');
success = true;

return;

