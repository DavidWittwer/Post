function [ CPgain, XPgain ] = nsiReadData( nsiDataPath, freq )
%NSIREADDATA Reads NSI data dump files generated with MLDump.macro9
%   Load S11 Data (dB magnitudes and Frequencies)

% Retrieve nsi constant definitions
nsiConstant = nsiConstants();

% total # of beams (frequencies)
numbeam1 = length(freq);

% Create local alias for nsi constants
FF_nTH = nsiConstant.FF_nTH;
FF_dTH = nsiConstant.FF_dTH;
FF_nPHI = nsiConstant.FF_nPHI;
FF_dPHI = nsiConstant.FF_dPHI;

% Load each beam (frequency) into the return arrays
%   f(m,n,f)
%     ^ ^ ^
%     | | |
%     | | -- frequency (beam) index
%     | ---- phi index
%     ------ theta index
%copol_cut1 = zeros( FF_nTH, FF_nPHI, numbeam1 );
%xpol_cut1 =  zeros( FF_nTH, FF_nPHI, numbeam1 );
for k = 1 : numbeam1;
    fname_ph = ['AUT_UncorrFF_dBGain_CoPol' num2str(k) '.out'];
    fname_phx = strrep(fname_ph, 'CoPol','XPol');

    fname_act = dir(fname_ph);
    fnamex_act = dir(fname_phx);
    
    disp(sprintf('%s',fname_act.name));
    
    [ fidc1, message ] = fopen(fname_act.name, 'r','ieee-le');
    [ fidx1, message ] = fopen(fnamex_act.name,'r','ieee-le');
    
    % TODO:  Add error checking on file open operation

    [copol_cut1(:,:,k)] = fread(fidc1, [FF_nTH+1, inf], 'float');
    [ xpol_cut1(:,:,k)] = fread(fidx1, [FF_nTH+1, inf], 'float');
end

% Extract the copol (CP) and cross pol (XP) gain arrays
CPgain = copol_cut1(1:FF_nTH, 1:FF_nPHI, :);
XPgain =  xpol_cut1(1:FF_nTH, 1:FF_nPHI, :);



