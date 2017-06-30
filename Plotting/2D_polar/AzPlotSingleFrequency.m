function [ handle ] = AzPlotSingleFrequency( plotFreq, freq, data, fixedTheta, label, plotProperty, fname )
%AZPLOTSINGLEFREQUENCY Summary of this function goes here
%   Detailed explanation goes here
nsiConstant = nsiConstants();
nFreq = size(freq,1);
%nFreq = 4;

% 
% plot stuff for AzCut
ang = (-180:nsiConstant.FF_dTH:180);
leg_ang = fftshift(ang); %corrects for graphing under Azplot function
leg_ang = repmat(leg_ang, [1 1 nFreq]);

Az_Ang_vec = linspace(0,180,nsiConstant.FF_nTH);
[ Dummy,   Az_Ang_indx ] = min( abs(Az_Ang_vec-fixedTheta) );
[ maxGain,  maxGindx   ] = max( data(Az_Ang_indx,:,:) );
[ minGain,  minGindx   ] = min( data(Az_Ang_indx,:,:) );

% Debug statements
size(ang)
size(data)

% Data Plot------------------------------------------------
% 

fullscreen = get(0,'ScreenSize');
%handle = figure('Position',[0 -50 fullscreen(3) fullscreen(4)]);
handle = figure('Position',[0 0 1024 768]);

orient landscape;

i = find(freq==plotFreq);
Azplot( ...
    ang, ...
    data(Az_Ang_indx,:,i), ...
    char(plotProperty.lnstyl(i)), ...
    [plotProperty.azcut_rhomax plotProperty.rhoplotmin plotProperty.n_plot_inc] );
hold on;

% - Create the legend entires
celltxt = nsiCreateLegend(1, plotFreq, leg_ang, maxGain, maxGindx, minGain, minGindx);
[hleg1 hleg2 hleg3 hleg4] = legend(celltxt,4, 'Location', 'BestOutside');

titltxt = sprintf('%s\nAzimuth Cut, held at \\theta = %s^o: \n%s', ...
    plotProperty.DirName, ...
    num2str(fixedTheta),label );
%titltxt = strvcat(plotProperty.DirName,  ['Azimuth Cut, held at \theta = ' num2str(fixedTheta) '^o: ' label ]);
%titltxt = strvcat(plotProperty.autsernum,  ['Azimuth Cut, held at \theta = ' num2str(fixedTheta) '^o: ' label ]);
title(titltxt);


