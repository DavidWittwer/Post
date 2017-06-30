function [ Totgain ] = ComputeTotalGain( CPgain, XPgain )
%COMPUTETOTALGAIN Summary of this function goes here
%   Detailed explanation goes here

% Combine the two field polarization to compute the total gain
Totgain = 10 * log10( 10.^(CPgain./10) + 10.^(XPgain./10) ) ;