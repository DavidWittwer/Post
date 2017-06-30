function [ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, constants, Date ] = Load_Howland_Data( dataPath )
%LOAD_HOWLAND_DATA Summary of this function goes here
%   Detailed explanation goes here
%
%   10 August 2012
%   D. C. Wittwer
%   Galtronics USA

% Load Data files
%DataPath = eval('cd');

% Process optional passed arguements
if( exist('dataPath', 'var') )
    DataPath = dataPath;
else
    DataPath = uigetdir(pwd,'Select directory containing Howland data files.');
end
cd(DataPath);

%% Find all Far-Field files in the selected directory
files = dir('*FF*.txt');
nFiles = size(files,1);

% Check to see if any FF files exist
if( 0 ~= nFiles )
    %-- Load all FF data files
    freq = zeros(nFiles,1);
    for i = 1 : nFiles
        [ freq(i), CPgain(:,:,i), CPphase(:,:,i), XPgain(:,:,i), XPphase(:,:,i), constants, Date ] = ...
            HowlandReadFF( DataPath, files(i).name  );
    end

else % No FF files found, check for AP files
    disp(sprintf('... No FF pattern files found... checking for AP files....'));
    
    files = dir('*AP*.txt');
    nFiles = size(files,1);
    
    if(~nFiles)
        disp(sprintf('... No AP pattern files found either... crashing now.... :-('));
    end
    
    %-- Load all AP data files
    freq = zeros(nFiles,1);
    for i = 1 : nFiles
        [ freq(i), CPgain(:,:,i), CPphase(:,:,i), XPgain(:,:,i), XPphase(:,:,i), constants, Date ] = ...
            HowlandReadAP( DataPath, files(i).name  );
    end
    
end

freq = freq * 1.0e6;

%% Compute the total gain
[ Totgain ] = ComputeTotalGain( CPgain, XPgain );
