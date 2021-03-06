function [ handle ] = ElPlot( freq, data, fixedPhi, label, plotProperty, fname, constants )
%ELPLOT Summary of this function goes here
%   Detailed explanation goes here

nFreq = size(freq,1);
%nFreq = 4;

EL_Ang_vec = linspace(0,180,constants.FF_nTH);
[Dummy, EL_Ang_indx] = min(abs(EL_Ang_vec - fixedPhi));
 
EL_Gplot=[data(:,EL_Ang_indx,:) ; flipdim( (data(2:end, EL_Ang_indx + (constants.FF_cPHI-1), :)),1)];
EL_Gplot = fftshift(EL_Gplot,1);

% EL_Ang_vec = linspace(-180,180,2*constants.FF_nTH-1);
% [Dummy, EL_Ang_indx]=min(abs(EL_Ang_vec-fixedPhi));

ELang=(-180:constants.FF_dTH:180);
leg_ang=(ELang); %corrects for graphing under Dirplot function
leg_ang=repmat(leg_ang, [1 1 nFreq]);

[ maxGain, maxGindx ] = max(data(:,1,:));
[ minGain, minGindx ] = min(data(:,1,:));

%plot stuff for Phi=0 Theta Cut (Elevation Cut#1)
fullscreen = get(0,'ScreenSize');
%handle = figure('Position',[0 -50 fullscreen(3) fullscreen(4)]);
handle = figure('Position',[0 0 1024 768]);
orient landscape;

for i=1:nFreq
    Dirplot( ...
        ELang.', ...
        EL_Gplot(:,:,i), ...
        char(plotProperty.lnstyl(i)), ...
        [plotProperty.azcut_rhomax plotProperty.rhoplotmin plotProperty.n_plot_inc]);
hold on;
end

% - Create the legend entires
celltxt = CreateLegend(nFreq, freq, leg_ang, maxGain, maxGindx, minGain, minGindx);
[hleg1 hleg2 hleg3 hleg4]=legend(celltxt,4, 'Location', 'BestOutside');

titltxt = sprintf('%s\nElevation Cut, held at \\phi = %s^o:\n%s', ...
    plotProperty.DirName, ...
    num2str(fixedPhi),label );
%titltxt=strvcat(plotProperty.DirName, ['Elevation Cut, held at \phi = ' num2str(fixedPhi) '^o: ' label ]);
%titltxt=strvcat(plotProperty.autsernum,  ['Elevation Cut, held at \phi = ' num2str(fixedPhi) '^o: ' label ]);
title(titltxt);

WriteMaxMinToFile( fname, freq, maxGain, minGain, label );

