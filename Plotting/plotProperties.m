function [ plotProperty ] = plotProperties( DataPath )
%PLOTPROPERTIES Summary of this function goes here
%   Detailed explanation goes here

%The line below sets plot scaling to next 3dB level above global peak gain 
% azcut_rhomax= ceil( max( max( max(Totgain) ) ) ./ plot_inc) .* plot_inc;
%The line below sets Rhomax manually (for all plots)
%azcut_rhomax=3;
%plotProperty.azcut_rhomax = 15;   % set plot scale maximum
%plotProperty.rhoplotmin = -10;    % set plot scale minimum
%plotProperty.plot_inc = 6;       % set radial increments to 10 dB/div
%plotProperty.n_plot_inc = 5;      % total # of radial div / plot
plotProperty.azcut_rhomax = 20;   % set plot scale maximum
plotProperty.rhoplotmin = -20;    % set plot scale minimum
plotProperty.plot_inc = 5;       % set radial increments to 10 dB/div
plotProperty.n_plot_inc = (plotProperty.azcut_rhomax - plotProperty.rhoplotmin)/plotProperty.plot_inc;      % total # of radial div / plot
plotProperty.lnstyl = { '-r' '-g' '-b' '-c' '-m' '-y' '-k' ...
                        '-.r' '-.g' '-.b' '-.c' '-.m' '-.y' '-.k' ...
                        '--r' '--g' '--b' '--c' '--m' '--y' '--k' ...
                        ':r' ':g' ':b' ':c' ':m' ':y' ':k' ...
                        '-ro' '-go' '-bo' '-co' '-mo' '-yo' '-ko' ...
                        '-.ro' '-.go' '-.bo' '-.co' '-.mo' '-.yo' '-.ko' ...
                        '--ro' '--go' '--bo' '--co' '--mo' '--yo' '--ko' ...
                        ':ro' ':go' ':bo' ':co' ':mo' ':yo' ':ko' };
plotProperty.DatPath = DataPath;
% used to print out dir path correctly for AUT ser# in title
plotProperty.autsernum = strrep(DataPath, '\','\\');
% used to print out underscore correctly for AUT ser# in title
plotProperty.autsernum = strrep(plotProperty.autsernum, '_','\_');

% get the current folder name
C = textscan(DataPath,'%s','Delimiter','\\');    % create a list of folders in the current path
n = size(C{1,1},1);                                 % determine the number of entries in the list
plotProperty.DirName = strrep( char(C{1,1}(n)),'_','\_');           % retrieve the last entry

plotProperty.copol_label = 'E_{\theta} (CoPol) Component';
plotProperty.xpol_label = 'E_{\phi} (XPol) Component';
plotProperty.total_label = 'E_{TOTAL} (Power \Sigma) Component';
