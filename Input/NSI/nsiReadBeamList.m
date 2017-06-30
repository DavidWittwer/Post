function [ freq, Date ] = nsiReadBeamList( nsiDataPath )
%NSIREADBEAMLIST Summary of this function goes here
%   Detailed explanation goes here

% Assign filenames
fname_freq = 'AUT_S11_Freqs.out';
%fname_freq = sprintf('%s\\%s',nsiDataPath,fname_freq)
fname_freq_Xact = dir(fname_freq);
[ fidf1, message ] = fopen( fname_freq_Xact.name, 'r', 'ieee-le' );
Date = fname_freq_Xact.date;

% TODO:  Add error checking on file open operation

% Read the frequency list and return loss files
freq = fread(fidf1,'float');
