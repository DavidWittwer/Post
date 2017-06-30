function [ nsiConstant ] = nsiConstants( )
%NSICONTANTS Summary of this function goes here
%   Detailed explanation goes here

nsiConstant.j = sqrt(-1);

nsiConstant.deg2rad = pi/180;

% Assume 1 degree spacing over theta and phi (i.e. theta runs [0:3:177]
% (60 pts), phi runs [0:3:357] (120 pts) ).

nsiConstant.FF_nTH = 181;
nsiConstant.FF_cTH = ceil( nsiConstant.FF_nTH / 2 );
nsiConstant.FF_dTH = 1;     %spatial FF sampling interval in Theta (in degrees)
nsiConstant.FF_nPHI = 361;
nsiConstant.FF_cPHI = ceil( nsiConstant.FF_nPHI / 2 );
nsiConstant.FF_dPHI = 1;    %spatial FF sampling interval in Phi (in degrees)
%  NOTE:  Different NF spatial sampling will require that these numbers be
%         changed!!!
%

%  Alternate sampling intervals:
%  3 degree spacing
%     theta [0:3:180] ( 61 pts)
%     phi   [0:3:357] (121 pts)
%nsiConstant.FF_nTH = 61;
%nsiConstant.FF_cTH = ceil( nsiConstant.FF_nTH / 2 );
%nsiConstant.FF_dTH = 3;     %spatial FF sampling interval in Theta (in degrees)
%nsiConstant.FF_nPHI = 121;
%nsiConstant.FF_cPHI = ceil( nsiConstant.FF_nPHI / 2 );
%nsiConstant.FF_dPHI = 3;    %spatial FF sampling interval in Phi (in degrees)

%  Alternate sampling intervals:
%  5 degree spacing
%     theta [0:5:180] ( 37 pts)
%     phi   [0:5:360] ( 73 pts)
%nsiConstant.FF_nTH = 37;
%nsiConstant.FF_cTH = ceil( nsiConstant.FF_nTH / 2 );
%nsiConstant.FF_dTH = 5;     %spatial FF sampling interval in Theta (in degrees)
%nsiConstant.FF_nPHI = 73;
%nsiConstant.FF_cPHI = ceil( nsiConstant.FF_nPHI / 2 );
%nsiConstant.FF_dPHI = 5;    %spatial FF sampling interval in Phi (in degrees)
