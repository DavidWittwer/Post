function [ success ] = PlotElevation( freq, CPgainplot, XPgainplot, Totgainplot, plotProperty, DataPath, Angle, constants )
%PLOTELEVATION Summary of this function goes here
%   Detailed explanation goes here

success = false;

% Process optional passed arguements
if( exist('Angle','var') )
    angle = Angle;
else
    % change this for different Azimuth cuts:  will sweep out a "cone", w/ Theta held fixed
    disp(sprintf('Enter the fixed Theta value for the azimuth cut.  '));
    angle = input('Enter the fixed Phi value (in deg) for the elevation1 cut = ');
end

figSumEL1Hndl = ElPlot( freq, Totgainplot, angle, plotProperty.total_label, plotProperty, 'EL1Sum.txt', constants );
figCPEL1Hndl = ElPlot( freq, CPgainplot, angle, plotProperty.copol_label, plotProperty, 'EL1Vert.txt', constants );
figXPEL1Hndl = ElPlot( freq, XPgainplot, angle, plotProperty.xpol_label, plotProperty, 'EL1Horz.txt', constants );

angle = angle + 90;
figSumEL2Hndl = ElPlot( freq, Totgainplot, angle, plotProperty.total_label, plotProperty, 'EL2Sum.txt', constants );
figCPEL2Hndl = ElPlot( freq, CPgainplot, angle, plotProperty.copol_label, plotProperty, 'EL2Vert.txt', constants );
figXPEL2Hndl = ElPlot( freq, XPgainplot, angle, plotProperty.xpol_label, plotProperty, 'EL2Horz.txt', constants );

if( ~exist('plots', 'dir') ) 
    mkdir('plots');
end

Plot2File( figCPEL1Hndl, DataPath, 'EL1_copol' );
Plot2File( figXPEL1Hndl, DataPath, 'EL1_xpol' );
Plot2File( figSumEL1Hndl, DataPath, 'EL1_sum' );

Plot2File( figCPEL2Hndl, DataPath, 'EL2_copol' );
Plot2File( figXPEL2Hndl, DataPath, 'EL2_xpol' );
Plot2File( figSumEL2Hndl, DataPath, 'EL2_sum' );

success = true;
