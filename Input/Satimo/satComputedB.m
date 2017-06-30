function [ EfieldAmp_dB ] = satComputedB( EfieldAmp_LIN );

%satComputAmpPhs Summary of this function goes here
%   Detailed explanation goes here

% Compute Amplitude (Linear Units) & Phase (Degrees) Info from (Re, Im)


EfieldAmp_dB=20*log10(EfieldAmp_LIN);
