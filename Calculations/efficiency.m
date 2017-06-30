function [ e, d ] = efficiency( gain )
%EFFICIENCY Summary of this function goes here
%   Detailed explanation goes here

%- Determine the number of theta, phi values
nTheta = size(gain,1);
nPhi = size(gain,2);

%- Pre compute spherical metrics
dTheta = (pi/180) * (180/nTheta);
dPhi = (pi/180) * (360/nPhi);

sinTh = sin( linspace(0,180,nTheta) .* (pi/180) ) .* dTheta;

%- Integrate the sphere to compute the correction factor, 4*pi
one = ones(nTheta,nPhi);
for i = 1 : nTheta
    one(i,:) = one(i,:) .* sinTh(i);
end
one = one .* dPhi;
cf = sum(sum(one));

%- Convert to linear units from dBi
F = 10.^(gain./10);

%- Compute the function max value
Fmax = max(max(F));

%- Multiply by the spherical metrics (row by row)
for i = 1 : nTheta
    F(i,:) = F(i,:) .* sinTh(i);
end
F = F .* dPhi;

%- Compute the sum and normalize
%e = sum(sum(F)) / (4*pi);
e = sum(sum(F)) / cf;

%- Compute directivity (peak/average)
%d = 4*pi*Fmax / sum(sum(F));
%d = cf*Fmax / sum(sum(F));
%d = 10*log10( 4*pi*Fmax / sum(sum(F)) );
d = 10*log10( cf*Fmax / sum(sum(F)) );
