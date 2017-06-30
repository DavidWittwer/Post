function [ CPgainslant, XPgainslant, CPphaseslant, XPphaseslant ] = ComputeSlantPolarizations( CPgain, XPgain, CPphase, XPphase )
%COMPUTESLANTPOLARIZATIONS Summary of this function goes here
%   Detailed explanation goes here

j = sqrt(-1);
deg2rad = pi/180;

%rot_angle = 45.0 * nsiConstant.deg2rad; % Rotation angle of new coord sys
CPgain_lin = 10.^(CPgain./20);          % Vertical field (linear)
XPgain_lin = 10.^(XPgain./20);          % Horizontal field (linear)

%arg_inc = atan(CPgain_lin./XPgain_lin);  % Angle of total field (relative to
                                        % the original coordinate systems)

%beta = pi/4 - arg_inc;
%mag_tot_field = sqrt( CPgain_lin.^2 + XPgain_lin.^2 );

%CPgainslant = mag_tot_field .* cos( beta );
%XPgainslant = mag_tot_field .* sin( beta );

e_the = CPgain_lin .* exp( j * CPphase * deg2rad );
e_phi = XPgain_lin .* exp( j * XPphase * deg2rad );

e_p45 = ( e_the + e_phi ) / sqrt(2);
e_m45 = ( e_the - e_phi ) / sqrt(2);

CPgainslant = abs(e_p45);
XPgainslant = abs(e_m45);

CPphaseslant = atan( imag(e_p45) ./ real(e_p45) );
XPphaseslant = atan( imag(e_m45) ./ real(e_m45) );

% Convert back to dB
CPgainslant = 20 * log10( CPgainslant );
XPgainslant = 20 * log10( XPgainslant );

CPgainslant = real(CPgainslant);
XPgainslant = real(XPgainslant);

% Convert back to degrees
CPphaseslant = CPphaseslant ./ deg2rad;
XPphaseslant = XPphaseslant ./ deg2rad;



