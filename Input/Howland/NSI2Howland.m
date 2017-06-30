function [ success ] = NSI2Howland()
%NSI2HOWLAND Summary of this function goes here
%   Detailed explanation goes here
success = false;

% Load the NSI Pattern Data
[ freq, gain, CPgain, XPgain, CPphase, XPphase ] = Load_NSI_Patterns( );

% Select Output Directory and base filename
TITLE = 'Select Howland Output Directory and Filename base';
FILTERSPEC = { '*.txt', 'Text Files (*.txt)'; ...
               '*.*',   'All Files (*.*)' ...
               };
[fname, path] = uiputfile( FILTERSPEC, TITLE);

% Create a file for each frequency
for i = 1 : size(freq,1)
    % Create output filename (Howland Compatible)
    fMHz = sprintf('%7.3f', freq(i)/1e6 );
    freq_stub = strrep( fMHz, '.', '_' );
    %disp(sprintf('Frequency file sub-string:  %s, %s\n', fMHz, freq_stub));
    
    fname_stub = strrep(fname,'.txt','');
    ffname = sprintf( '%s FF %sMHz.txt', fname_stub, freq_stub );
    disp(sprintf('Converting file:  %s',ffname));

    % Write a single Howland Pattern File
    HowlandWriteFF( ffname, path, freq(i), gain(i), CPgain(:,:,i), CPphase(:,:,i), XPgain(:,:,i), XPphase(:,:,i) );
end

disp(sprintf('Conversion complete! ( NSI ==> Howland )'));

success = true;
