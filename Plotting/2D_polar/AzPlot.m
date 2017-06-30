function [ handle ] = AzPlot( freq, data, fixedTheta, label, plotProperty, fname, constants )
%AZPLOT Summary of this function goes here
%   Detailed explanation goes here

nFreq = size(freq,1);
%nFreq = 4;

% 
% plot stuff for AzCut
ang = (-180:constants.FF_dTH:180);
leg_ang = fftshift(ang); %corrects for graphing under Azplot function
leg_ang = repmat(leg_ang, [1 1 nFreq]);

Az_Ang_vec = linspace(0,180,constants.FF_nTH);
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

for i=1:nFreq
    Azplot__( ...
        ang, ...
        data(Az_Ang_indx,:,i), ...
        char(plotProperty.lnstyl(i)), ...
        [plotProperty.azcut_rhomax plotProperty.rhoplotmin plotProperty.n_plot_inc] );
    hold on;
end

% - Create the legend entires
celltxt = CreateLegend(nFreq, freq, leg_ang, maxGain, maxGindx, minGain, minGindx);
[hleg1 hleg2 hleg3 hleg4] = legend(celltxt,4, 'Location', 'BestOutside');

titltxt = sprintf('%s\nAzimuth Cut, held at \\theta = %s^o: \n%s', ...
    plotProperty.DirName, ...
    num2str(fixedTheta),label );
%titltxt = strvcat(plotProperty.DirName,  ['Azimuth Cut, held at \theta = ' num2str(fixedTheta) '^o: ' label ]);
%titltxt = strvcat(plotProperty.autsernum,  ['Azimuth Cut, held at \theta = ' num2str(fixedTheta) '^o: ' label ]);
title(titltxt);

WriteMaxMinToFile( fname, freq, maxGain, minGain, label );

% % Print table of max/min values to the screen
% disp( sprintf('%s',label) );
% disp( sprintf('Freq (MHz) \tG_{tot,max} \tG_{tot,min}') );
% for i=1:nFreq
%     disp( sprintf( '%i \t\t%g5 \t\t\t%g5', ceil(freq(i)/(1*10^6)), maxGain(1,1,i), minGain(1,1,i) ) );
% end


