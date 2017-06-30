function [ success ] = Plot2File( h, dataPath, fname )
%PLOT2FILE Summary of this function goes here
%   Detailed explanation goes here

success = false;

startDIR = pwd;

%if isempty(dataPath)
    cd(dataPath);
%end

directory = dir('plot*');
if( 0 == size(directory,1) )
    mkdir('plots')
end

fname = sprintf('./plots/%s',fname);
print(h, '-dpng', '-r300', fname );

%saveas(figCPHndl,'./plots/AZ_copol','png');
%saveas(figXPHndl,'./plots/AZ_xpol','png');

cd(startDIR);

success = true;
