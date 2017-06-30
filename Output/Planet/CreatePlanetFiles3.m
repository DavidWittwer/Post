function [ success ] = CreatePlanetFiles3( DataPath, constants, prodName, portLabel, freq, gain, plotSlantPolarization, invThe, SwapVH, THETA, PHI )
%CREATEPLANETFILES3 Summary of this function goes here
%   Detailed explanation goes here
DEBUG = 1;  % { 0 = no | 1 = yes }
success = false;

%% Process optional passed arguements
plotSlantPol = 0;
if( exist('plotSlantPolarization', 'var') )
    plotSlantPol = plotSlantPolarization;
end

invertThe = 0;
if( exist('invThe','var') )
    invertThe = invThe;
end

swapVH = 0;
if( exist('SwapVH','var') )
    swapVH = SwapVH;
end

theta_ = 0;
useTheta = false;
if( exist('THETA','var') )
    theta_ = THETA;
    useTheta = true;
end

phi_ = 0;
usePhi = false;
if( exist('PHI','var') )
    phi_ = PHI;
    usePhi = true;
end

useThetaPhi = false;
if( useTheta && usePhi )
    useThetaPhi = true;
end

thetaOffset = 90;

%% Get antenna details from the user with GUI
numbeam1 = size(freq,1);
label = getProductInfo(prodName);
label.Lower_Freq = freq(1)/1e6;
label.Upper_Freq = freq(numbeam1)/1e6;

%% Find the maximum gain values for every frequency
numbeam1 = size(freq,1);
dPhi = constants.FF_dPHI;
dThe = constants.FF_dTH;
nPhi = constants.FF_nPHI;

%% Create a directory to store the Planet files in (if it doesn't already
% exist)
cd(DataPath);

dirName = 'PlanetFiles';
directory = dir([dirName '*']);
if( 0 == size(directory,1) )
    mkdir(dirName)
end
cd(dirName);

%=========================================================================
% Write peak gain, VHPBW, HHPBW values to a file
%-------------------------------------------------------------------------
% Create file name
%-------------------------------------------------------------------------
[pathstr, name] = fileparts(DataPath); 
gName = [ name, '_peak_gain.txt'];
gName = strrep(gName,' ','_');              % replace spaces with _

%-------------------------------------------------------------------------
% Write header to file
%-------------------------------------------------------------------------
[fid, MESSAGE] = fopen(gName, 'wt');
fprintf(fid, 'Freq(MHz), Theta(deg), Phi(deg), MaxGain(dB), AZ_HPBW(deg), EL_HPBW(deg), Front-to-Back(dB)\n');
fclose(fid);

%% For each frequency, create a separate Planet file
for i=1:numbeam1
    %=====================================================================
    % Extract the pattern to work on
    %---------------------------------------------------------------------
    tmp_gain = gain(:,:,i);

    %=====================================================================
    %  Perform data rotations first!!
    %---------------------------------------------------------------------
    if( invertThe )
        tmp_gain = flipud(tmp_gain);
    end
        
    %=====================================================================
    % Find the peak gain and its location
    %---------------------------------------------------------------------
    if( useThetaPhi )
        [maxGainVal, iThe, iPhi] = FindPatternMaxGainValue( tmp_gain, theta, phi, dThe, dPhi);
    else
        [maxGainVal, iThe, iPhi] = FindPatternMaxGainValue( tmp_gain );
    end
    %disp(sprintf('Max. gain found at Theta = %5.3f dBi, Phi = %5.3f dBi, Total = %5.3f dBi',iThe,iPhi,maxGainVal));

    %=====================================================================
    % Get the azimuth and elevation cut through the selected (The, Phi)
    % value.
    %---------------------------------------------------------------------
    [az_data, el_data] = GetPrincipleCutPlanes(tmp_gain,iThe,iPhi);
    
    % Normalize and invert the 2D azimuth cut gain values
    az_data = abs( az_data - maxGainVal );
    iPhiDeg = (iPhi-1) * dPhi;
    az_data = circshift(az_data,-iPhiDeg);
    
    % Normalize, invert and rotate teh 2D elevation cut gain values
    el_data = abs( el_data - maxGainVal );
    el_data = circshift(el_data,-thetaOffset);
    
    %=====================================================================
    % Swap Vertical and Horizontal cuts if requested by the user
    %---------------------------------------------------------------------
    if(swapVH)
        tmp = az_data;
        az_data = el_data;
        el_data = tmp;
    end
 
    %=====================================================================
    % compute the half power beam widths (HPBW)
    %---------------------------------------------------------------------
    azHPBW = ComputeAzimuthHPBWfrom2Ddata(az_data,dPhi);
    elHPBW = ComputeElevationHPBWfrom2Ddata(el_data,dThe);
    
    %=====================================================================
    % compute the half power beam widths (HPBW)
    %---------------------------------------------------------------------
    f2b = Front2Back(az_data,el_data);

    if(DEBUG) 
        disp(sprintf('Freq:\t%4.0f\tAzimuth:\t%5.1f\tElevation:\t%5.1f\tFront-to-Back:\t%6.2f', ...
            freq(i) / 1e6, azHPBW, elHPBW, f2b));
    end

    %=====================================================================
    % Write the cummulative metrics (peak gian, VHPBW, HHPBW, F2B).
    %---------------------------------------------------------------------
    [fid, MESSAGE] = fopen(gName,'at');
    fprintf(fid, '%4.0f, %3i, %3i, %6.2f, %5.1f, %5.1f, %6.2f\n', ...
        freq(i)/1e6, iThe, iPhi, maxGainVal, azHPBW, elHPBW, f2b);
    fclose(fid);

    %=====================================================================
    % Create the Planet file name.
    %---------------------------------------------------------------------
    freq_MHz = ceil(freq(i)/1e6);
    [pathstr, name] = fileparts(DataPath); 
    fName = [ label.Manufacturer, '_', label.ModelName, '_', sprintf('%6.1fMHz',freq_MHz) , '_', portLabel, '.txt' ];
    fName = strrep(fName,' ','_');              % replace spaces with _
    fName = strrep(fName,'_MLdata','');         % remove text from name
    
    %=====================================================================
    % Open new planet file
    %---------------------------------------------------------------------
    fid = fopen(fName,'wt');

    %=====================================================================
    % Compute the angles where the max gain occurs
    %---------------------------------------------------------------------
    gmaxThe = (iThe-1) * constants.FF_dTH;
    gmaxPhi = (iPhi-1) * constants.FF_dPHI;

    %=====================================================================
    % Write header to file
    %---------------------------------------------------------------------
    fprintf(fid,'NAME\t%s\n', fName );
    fprintf(fid,'MAKE\t%s\n', 'GALTRONICS' );
    fprintf(fid,'FREQUENCY\t%4.0f\n', freq(i) / 1e6 );
    fprintf(fid,'H_WIDTH\t%5.1f\n', azHPBW );
    fprintf(fid,'V_WIDTH\t%5.1f\n', elHPBW );
    fprintf(fid,'FRONT_TO_BACK\t%i\n', 0 );
    fprintf(fid,'GAIN\t%6.2f dBi\n', maxGainVal );
    fprintf(fid,'TILT\t%s\n', 'fixed' );
    if(plotSlantPol)
        fprintf(fid,'POLARIZATION\t%s\n', 'slant 45' );
    else
        fprintf(fid,'POLARIZATION\t%s\n', 'linear' );
    end
    %fprintf(fid,'COMMENT\t%s\n', 'preliminary' );
    fprintf(fid,'COMMENT\tPeak Gain found at (Theta,Phi) = (%i,%i) deg\n', gmaxThe, gmaxPhi);
    
    if(DEBUG) 
       % disp(sprintf('Offsets (theta,phi) = (%5.1f,%5.1f)deg',gmaxThe,gmaxPhi));
    end

    %=====================================================================
    % Write azimuth cut
    %---------------------------------------------------------------------
    fprintf(fid,'HORIZONTAL\t%i\n', size(az_data,1) );
    for j = 1 : size(az_data,1)
        fprintf(fid,'%i\t%5.3f\n', j-1, az_data(j) ); 
    end
    
    %=====================================================================
    % Write elevation cut
    %---------------------------------------------------------------------
    % Elevation cuts are created from two columns of the matrix.  The first
    % column must include the maximum value.  The second column is its
    % compliment.
    fprintf(fid,'VERTICAL\t%i\n', size(el_data,1) );
    for j = 1 : size(el_data,1)
        fprintf(fid,'%i\t%5.3f\n', j-1, el_data(j) ); 
    end
    
    %=====================================================================
    % Close the current file
    %---------------------------------------------------------------------
    fclose(fid);

    %=====================================================================
    % Create 3D Plot showing cut planes used to create the Planet file.
    %---------------------------------------------------------------------
    figHandle = Plot3D_with_PlanetFileCuts( tmp_gain, az_data, el_data, maxGainVal, iThe, iPhi, dThe, dPhi);

    %---------------------------------------------------------------------
    % Save the figure to an image file
    %---------------------------------------------------------------------
    loc = [DataPath '/PlanetFiles'];
    f = uint64( freq(i) / 1e6 );
    pfname = sprintf('PlanetCuts_%i4Mhz', f );
    Plot2File( figHandle, loc, pfname );
    
end

%% Return to previous directory
cd('..');
success = true;
