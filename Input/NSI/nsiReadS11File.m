function [ S11dBmag, path ] = nsiReadS11File(nsiDataPath )
%UNTITLED1 Summary of this function goes here
%   Detailed explanation goes here

%% Process optional passed arguements
path = '';
if( exist('nsiDataPath', 'var') )
    path = nsiDataPath;
    cd(path);
end

%%  If path is not passed, query it from the user
if( isempty(path) )
    % Prompt the user for the name of the NSI S11 txt file directory
    uiText = 'Select NSI data directory';
    path = uigetdir(pwd,uiText);
    cd(path);
end


%% Assign filenames
fname_S11dB = 'AUT_S11_MagdB.out';
fname_S11dB_Xact = dir(fname_S11dB);
[ fids1, message ] = fopen( fname_S11dB_Xact.name, 'r', 'ieee-le' );

% TODO:  Add error checking on file open operation

% Read the frequency list and return loss files
S11dBmag = fread(fids1,'float');
