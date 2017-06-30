function [ SavgAUT ] = ComputeAvePowerDensity( freq, Totgain, constants )
%NSICOMPUTEAVEPOWERDENSITY Summary of this function goes here
%   Detailed explanation goes here

% Create local alias for nsi constants
FF_nTH = constants.FF_nTH;
FF_dTH = constants.FF_dTH;
FF_nPHI = constants.FF_nPHI;
FF_dPHI = constants.FF_dPHI;

numbeam1 = length(freq);
sinTHvec = sin( ( 0:FF_dTH:FF_dTH * (FF_nTH-1) ) .* constants.deg2rad ).';
sinTH_ND = repmat( sinTHvec, [1 FF_nPHI numbeam1] );
% Compute the incremental surface patch areas (stearadians) over all
% numbeam1 dimensions (the Sin(theta) variation is included in these
% surface pathces)
delta_SPsr_ND = sinTH_ND .* ( FF_dTH * FF_dPHI * constants.deg2rad * constants.deg2rad );

% Only take 1/2 of the solid angle area associated with the incremental
% surface patches falling on the Phi=0 and Phi=360 degree points.
delta_SPsr_ND(:,1,:)=0.5*delta_SPsr_ND(:,1,:);
delta_SPsr_ND(:,FF_nPHI,:)=0.5*delta_SPsr_ND(:,FF_nPHI,:);
   
% Compute the average power density (W/m^2) by integrating the AUT Poynting
% Vector, S_tot(TH,PHI) over 4 pi stearadians (full sphere).  
% ==> The Totgain values are in dB 
SavgAUT = sum( sum( (10.^(Totgain./10) ) .* delta_SPsr_ND) );
