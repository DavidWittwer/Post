% nsi_post.m
%
% Post processing script for binary GTU NSI/ Howland Chamber files.  The
% script imports uncorrected CoPol and XPol (dB) amplitudes for all 
% measured beams (frequencies).  Total Power is computed from the power sum
% of the CoPol and Xpol components (convert to linear units, sum and then
% convert back to dB).  The Azplot.m and Dirpolot.m script files are used (external!) 
% The data matrices are arranged 62x122 with the 62st and 122st columns filled
% with ZEROS.  Matrix ROWS are PHI cuts (Theta held constant) while COLUMNS
% are THETA cuts (phi held constant).  Theta Point Sampling 0:1:180
% Phi Point Sampling 0:1:360.  First ROW corresponds to THETA=0, First Column
% to PHI=0.

clear all;
close all;
clc;

plotSlantPolarizations = false;
createPlanetFiles = true;
plot3D = false;
fileFormat_NSI = true;
fileFormat_TRX = false;


%% Load data files

if(fileFormat_NSI)
    [ freq, CPgain, XPgain, Totgain, DataPath, Constants ] = Load_NSI_Data();
elseif(fileFormat_TRX)
    [ freq, CPgain, XPgain, Totgain, DataPath, Constant ] = Load_Satimo_Data();
else
    return;
end

%% Compute auxillary quantities

if( plotSlantPolarizations )
    [ CPgainslant, XPgainslant ] = nsiComputeSlantPolarizations( CPgain, XPgain, CPphase, XPphase );
    % Compute the total power for the two field components
    [ Totgainslant ] = nsiComputeTotalGain( CPgainslant, XPgainslant );
else
    % Compute the total power for the two field components
    %[ Totgain ] = nsiComputeTotalGain( CPgain, XPgain );
end

%% Plot routines
%-----------------------------------------------------------------------
%PLOTTING SPECIFIC CUTS (typically, Azimuth w/ Theta=90, Elev. w/ Phi=0,
%& Elev. w/ Phi=90

plotProperty = plotProperties( DataPath );

% Plot azimuth pattern
if( plotSlantPolarizations ) 
    plotProperty.copol_label = 'E_{+45} (CoPol) Component';
    plotProperty.xpol_label = 'E_{-45} (XPol) Component';
    [ CPgainslantplot XPgainslantplot Totgainslantplot ] = scaleForPlotting( CPgainslant, XPgainslant, Totgainslant, plotProperty );
    nsiPlotAzimuth( freq, CPgainslantplot, XPgainslantplot, Totgainslantplot, plotProperty, DataPath );
else
    [ CPgainplot XPgainplot Totgainplot ] = scaleForPlotting( CPgain, XPgain, Totgain, plotProperty );
    nsiPlotAzimuth( freq, CPgainplot, XPgainplot, Totgainplot, plotProperty, DataPath );
end

% Plot elevation patterns
if( plotSlantPolarizations ) 
    nsiPlotElevation( freq, CPgainslantplot, XPgainslantplot, Totgainslantplot, plotProperty, DataPath );
else
    nsiPlotElevation( freq, CPgainplot, XPgainplot, Totgainplot, plotProperty, DataPath );
end

%% Generate Planet output files
if( createPlanetFiles && plotSlantPolarizations )
    CreatePlanetFiles2( DataPath, freq, Totgainslant );
elseif (createPlanetFiles)
    CreatePlanetFiles2( DataPath, freq, Totgain );
end

%% Compute additional pattern statistics

%nsiPlotCDF( freq, Totgain, Effcheck, maxdBitest, S11dBmag, plotProperty );

if(plot3D)
    nsiPlot3D( freq, Totgain );
end

fclose('all');

