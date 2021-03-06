function [ CPgain, XPgain, CPphase, XPphase, constants ] = nsiReadAmpPhaData( DataPath, freq )
%NSIREADAMPPHADATA Summary of this function goes here
%   Detailed explanation goes here

% Retrieve nsi constant definitions
constants = nsiConstants();

% total # of beams (frequencies)
numbeam1 = length(freq);

% Use the first file to determine the angle spacing
CoPolAmp_files = ls('AUT*CoPol*.out');
XPolAmp_files = ls('AUT*XPol*.out');
CoPolPhase_files = ls('AUT*CoPolPhase*.out');
XPolPhase_files = ls('AUT*XPolPhase*.out');

phaseFilesExist = size(CoPolPhase_files,1);

[ fid, message ] = fopen( CoPolAmp_files(1,:), 'r','ieee-le');
A = fread(fid,'float');
fclose(fid);

switch size(A,1)
    case 65884                  % Angle increment is 1 deg
        constants.FF_nTH = 181;
        constants.FF_dTH = 1;
        constants.FF_nPHI = 361;
        constants.FF_dPHI = 1;
    case 16744                  % Angle increment is 2 deg
        constants.FF_nTH = 91;
        constants.FF_dTH = 2;
        constants.FF_nPHI = 181;
        constants.FF_dPHI = 2;
    case 7564                  % Angle increment is 3 deg
        constants.FF_nTH = 61;
        constants.FF_dTH = 3;
        constants.FF_nPHI = 121;
        constants.FF_dPHI = 3;
    case 4324                  % Angle increment is 4 deg
        constants.FF_nTH = 46;
        constants.FF_dTH = 4;
        constants.FF_nPHI = 91;
        constants.FF_dPHI = 4;
    case 2812                  % Angle increment is 5 deg
        constants.FF_nTH = 37;
        constants.FF_dTH = 5;
        constants.FF_nPHI = 73;
        constants.FF_dPHI = 5;
end


% Create local alias for nsi constants
FF_nTH = constants.FF_nTH;
FF_dTH = constants.FF_dTH;
FF_nPHI = constants.FF_nPHI;
FF_dPHI = constants.FF_dPHI;

% Load each beam (frequency) into the return arrays
%   f(m,n,f)
%     ^ ^ ^
%     | | |
%     | | -- frequency (beam) index
%     | ---- phi index
%     ------ theta index
%copol_cut1 = zeros( FF_nTH, FF_nPHI, numbeam1 );
%xpol_cut1 =  zeros( FF_nTH, FF_nPHI, numbeam1 );

copol_amp = zeros(FF_nTH+1,FF_nPHI+1,numbeam1);
xpol_amp = zeros(FF_nTH+1,FF_nPHI+1,numbeam1);
copol_pha = zeros(FF_nTH+1,FF_nPHI+1,numbeam1);
xpol_pha = zeros(FF_nTH+1,FF_nPHI+1,numbeam1);

for k = 1 : numbeam1;
    %fname_copol_amp = ['AUT_UncorrFF_dBGain_CoPolAmp' num2str(k) '.out'];
    %fname_xpol_amp = strrep(fname_copol_amp, 'CoPol','XPol');
    
    %fname_copol_pha = ['AUT_UncorrFF_dBGain_CoPolPhase' num2str(k) '.out'];
    %fname_xpol_pha = strrep(fname_copol_pha, 'CoPol','XPol');
    
    %fname_copol_amp = dir(fname_copol_amp);
    %fname_xpol_amp  = dir(fname_xpol_amp);
    %fname_copol_pha = dir(fname_copol_pha);
    %fname_xpol_pha  = dir(fname_xpol_pha);
    
    fname_copol_amp = dir( CoPolAmp_files(k,:) );
    fname_xpol_amp  = dir( XPolAmp_files(k,:) );
    [ fidca, message ] = fopen( fname_copol_amp.name, 'r','ieee-le');
    [ fidxa, message ] = fopen( fname_xpol_amp.name, 'r','ieee-le');
    
    data = fread(fidca, 'float');
    data = reshape(data,[FF_nTH+1 FF_nPHI+1]);
    copol_amp(:,:,k) = data;
    
    data = fread(fidxa, 'float');
    data = reshape(data,[FF_nTH+1 FF_nPHI+1]);
    xpol_amp(:,:,k) = data;
   
    if(phaseFilesExist)
        fname_copol_pha = dir( CoPolPhase_files(k,:) );
        fname_xpol_pha  = dir( XPolPhase_files(k,:));
        [ fidcp, message ] = fopen( fname_copol_pha.name, 'r','ieee-le');
        [ fidxp, message ] = fopen( fname_xpol_pha.name, 'r','ieee-le');
        
        data = fread(fidcp, 'float');
        data = reshape(data,[FF_nTH+1 FF_nPHI+1]);
        copol_pha(:,:,k) = data;

        data = fread(fidxp, 'float');
        data = reshape(data,[FF_nTH+1 FF_nPHI+1]);
        xpol_pha(:,:,k) = data;

    end
    
end

% Extract the copol (CP) and cross pol (XP) gain arrays
CPgain = copol_amp(1:FF_nTH, 1:FF_nPHI, :);
XPgain =  xpol_amp(1:FF_nTH, 1:FF_nPHI, :);

minVal = min(min(min(CPgain)));
if minVal > 0                       % Data is in linear units
    CPgain = 10 * log10( CPgain );
    XPgain = 10 * log10( XPgain );
end

CPphase = copol_pha(1:FF_nTH, 1:FF_nPHI, :);
XPphase =  xpol_pha(1:FF_nTH, 1:FF_nPHI, :);




