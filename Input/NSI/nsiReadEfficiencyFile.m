function [ EffpathP1, EffnameP1, Effdata, Effcheck, errflag1 ] = nsiReadEfficiencyFile( nsiDataPath, freq, SavgAUT )
%NSIREADEFFICIENCYFILE Summary of this function goes here
%   Detailed explanation goes here

% Prompt the user for the standard gain horn (SGH) efficiency calibration 
% CSV filename
uiText = 'Pick the SGH Efficiency File for Calibrating AUT data ';
[EffnameP1, EffpathP1] = uigetfile('*EffCal*.csv', uiText);

% Perform error checking on the filename returned from the user interface
if isequal(EffnameP1,0) || isequal(EffpathP1,0)
    disp('File not found')
else
    disp(['File ', EffpathP1,EffnameP1, ' found'])
end

%Read in Calibration Frequency Points & Total Integrated Power and for the SGH (assuming 100% efficient SGH)
fidEff = fopen( [EffpathP1 EffnameP1], 'r');
txtline = fgets(fidEff);
teststr = 'Power, at theta, at phi,'; 
    
while (isempty(findstr(teststr,txtline))) %keeps loading lines until teststr is identified
    txtline=fgets(fidEff);
end
    
Effdata = fscanf( fidEff, '%g %*c %*g %*c %*g %*c %*g %*c %g %*c %*g %*c %*g %*c %*g', [2, inf]); %loads the NF Amplitude & Phase data 
%the %*c conversion characters SKIP over the single-character commas separating the
%numeric values (the files are .csv format)
Effdata = Effdata.';
SGH_TIPwrDensity = Effdata(:,2);
SGH_meas_f = Effdata(:,1);

numbeam1 = size(SavgAUT,3);
Effcheck = ( reshape(SavgAUT,[numbeam1 1 1]) ./ SGH_TIPwrDensity ) * 100
%this computes the terminal efficiencies over all numbeam1 frequencies:
%crosscheck these values with the terminal efficiencies listed in the
%Excel spreadsheet summaries to verify correct import and computation of
%Avg power, etc.

errflag1 = ~(isequal(round(SGH_meas_f/(25*10^6)), round(freq/(25*10^6))));%ensure freqs match to nearest 25 MHz
%errflag1 = 0 % hardwired to assume frequencies match up properly, until the roundoff problem is better understood
