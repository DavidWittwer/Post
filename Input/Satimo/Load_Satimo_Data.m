function [ freq, EThetaAmp_dB, EPhiAmp_dB, ETheta_Phs_FMT, EPhi_Phs_FMT, Totgain, satDataPath, satConstant, Date ] = Load_Satimo_Data( )
%LOAD_SATIMO_DATA Summary of this function goes here
%   Detailed explanation goes here


% Define constants
satConstant = satQConstants();

%% Load Data files
satDataPath = eval('cd');

% Load TRXV2 file, returns UNFORMATTED (unseparated) matrix plus some
% measurement parameters from the original NF==>FF data exported by Satimo,
% in TRXv2 file format

[freq NumAxis NumLayers phi_parm theta_parm DataUnFMT_FULL filename pathname Date] = satDataRead(satDataPath);
satDataPath = pathname;
%display(sprintf('Satimo Data = %s',Date));

% Returns FORMATED matrices, re-organized into the same orientation as that
% of the NSI/ Howland data files (i.e. matrix ROWS are PHI cuts (Theta held constant) while COLUMNS
% are THETA cuts (phi held constant).  First ROW corresponds to THETA=0, First Column
% to PHI=0.

EPhiReal_UnFMT=[DataUnFMT_FULL(:,1:NumAxis) DataUnFMT_FULL(:,1+NumAxis)];
EPhiImag_UnFMT=[DataUnFMT_FULL(:,1:NumAxis) DataUnFMT_FULL(:,2+NumAxis)];
EThetaReal_UnFMT=[DataUnFMT_FULL(:,1:NumAxis) DataUnFMT_FULL(:,3+NumAxis)];
EThetaImag_UnFMT=[DataUnFMT_FULL(:,1:NumAxis) DataUnFMT_FULL(:,4+NumAxis)];

[EPhiReal_FMT] = satDataFormat(EPhiReal_UnFMT);
[EPhiImag_FMT] = satDataFormat(EPhiImag_UnFMT);
[EThetaReal_FMT] = satDataFormat(EThetaReal_UnFMT);
[EThetaImag_FMT] = satDataFormat(EThetaImag_UnFMT);

[ EPhiAmp_FMT, EPhi_PhsRad_FMT ] = satComputeAmpPhs( EPhiReal_FMT, EPhiImag_FMT );

EPhi_Phs_FMT = EPhi_PhsRad_FMT .* satConstant.rad2deg;

[ EThetaAmp_FMT, ETheta_PhsRad_FMT ] = satComputeAmpPhs( EThetaReal_FMT, EThetaImag_FMT );

ETheta_Phs_FMT = ETheta_PhsRad_FMT .* satConstant.rad2deg;

[ EPhiAmp_dB ] = satComputedB( EPhiAmp_FMT );
[ EThetaAmp_dB ] = satComputedB( EThetaAmp_FMT );


% % Compute the total gain
[ Totgain ] = ComputeTotalGain( EPhiAmp_dB, EThetaAmp_dB );
[ SavgAUT ] = ComputeAvePowerDensity( freq, Totgain, satConstant );

% Create directory to store results
cd(satDataPath);
dirName = strrep(filename,'.trx','');
dirName = strrep(dirName,' ','_');
if( ~exist(dirName, 'dir') ) 
    mkdir(dirName);
end
cd(dirName);
satDataPath = eval('cd');

