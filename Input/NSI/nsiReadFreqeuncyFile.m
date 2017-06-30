function [ dBi_meas_f, SGH_NWoffset, errflag2 ] = nsiReadFreqeuncyFile( EffpathP1, EffnameP1, freq )
%NSIREADFREQEUNCYFILE Summary of this function goes here
%   Detailed explanation goes here

% Read in Calibration Frequency Points & Network Gain Offset for the SGH 
% (assuming 100% efficient, perfectly matched SGH)
dBinameP1 = strrep(EffnameP1, 'EffCal','dBiCal');

fiddBi = fopen( [EffpathP1 dBinameP1], 'r');
txtline  =fgets(fiddBi);
teststr = 'more details.'; 

% Keep loading lines until teststr is identified
while ( isempty( findstr(teststr,txtline) ) )
    txtline = fgets(fiddBi);
end

% Loads teh dBi file frequency points and the SGH NW offset values (dB)
dBi_data = fscanf(fiddBi, '%g  %*c %g', [2, inf]);
dBi_data = dBi_data.';
SGH_NWoffset = dBi_data(:,2);
dBi_meas_f = dBi_data(:,1);

% Ensure frequencies match to nearest 25 MHz
errflag2= ~( isequal( round(dBi_meas_f/(25*10^6)), round(freq/(25*10^6)) ) );

% Hardwired to assume frequencies match up properly, until the roundoff
% problem is better understood
%errflag2 = 0

