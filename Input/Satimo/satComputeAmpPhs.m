function [ E_AMP_FMT, E_PHS_FMT ] = satComputeAmpPhs( E_Real_FMT, E_Imag_FMT )

%satComputAmpPhs Summary of this function goes here
%   Detailed explanation goes here

% Compute Amplitude (Linear Units) & Phase (Degrees) Info from (Re, Im)


E_AMP_FMT=abs(E_Real_FMT + j*E_Imag_FMT);

E_PHS_FMT=angle(E_Real_FMT + j*E_Imag_FMT);