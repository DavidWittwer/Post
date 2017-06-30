function [ success ] = PlotAzimuth( freq, CPgainplot, XPgainplot, Totgainplot, plotProperty, DataPath, Angle, constants )
%NSIPLOTAZIMUTH Summary of this function goes here
%   Detailed explanation goes here

success = false;

% Process optional passed arguements
if( exist('Angle','var') )
    angle = Angle;
else
    % change this for different Azimuth cuts:  will sweep out a "cone", w/ Theta held fixed
    disp(sprintf('Enter the fixed Theta value for the azimuth cut.  '));
    angle = input('Enter downtilt angle 90-DT (in deg) = ');
end

figSumHndl = AzPlot( freq, Totgainplot, angle, plotProperty.total_label,  plotProperty, 'AzSum.txt', constants );
figCPHndl  = AzPlot( freq, CPgainplot,  angle, plotProperty.copol_label , plotProperty, 'AzVert.txt', constants );
figXPHndl  = AzPlot( freq, XPgainplot,  angle, plotProperty.xpol_label,   plotProperty, 'AzHorz.txt', constants );

Plot2File( figCPHndl, DataPath, 'Az_copol' );
Plot2File( figXPHndl, DataPath, 'Az_xpol' );
Plot2File( figSumHndl, DataPath, 'Az_sum' );

success = true;
