function [ satQConstant ] = satQConstants( )
%NSICONTANTS Summary of this function goes here
%   Detailed explanation goes here

satQConstant.j = sqrt(-1);

satQConstant.deg2rad = pi/180;
satQConstant.rad2deg = 180/pi;

% Assume 1 degree spacing over theta and phi (i.e. theta runs [0:3:177]
% (60 pts), phi runs [0:3:357] (120 pts) ).

satQConstant.FF_nTH = 181;
satQConstant.FF_cTH = ceil( satQConstant.FF_nTH / 2 );
satQConstant.FF_dTH = 1;     %spatial FF sampling interval in Theta (in degrees)
satQConstant.FF_nPHI = 361;
satQConstant.FF_cPHI = ceil( satQConstant.FF_nPHI / 2 );
satQConstant.FF_dPHI = 1;    %spatial FF sampling interval in Phi (in degrees)
%  NOTE:  Different NF spatial sampling will require that these numbers be
%         changed!!!
%
%  Alternate sampling intervals:
%  3 degree spacing
%     theta [0:3:180] ( 61 pts)
%     phi   [0:3:357] (121 pts)
% nsiConstant.FF_nTH = 61;
% nsiConstant.FF_cTH = ceil( nsiConstant.FF_nTH / 2 );
% nsiConstant.FF_dTH = 3;     %spatial FF sampling interval in Theta (in degrees)
% nsiConstant.FF_nPHI = 121;
% nsiConstant.FF_cPHI = ceil( nsiConstant.FF_nPHI / 2 );
% nsiConstant.FF_dPHI = 3;    %spatial FF sampling interval in Phi (in degrees)
  