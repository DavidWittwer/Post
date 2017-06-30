function corr = correlation( g1The, g1Phi, g2The, g2Phi )
%EFFICIENCY Summary of this function goes here
%   Detailed explanation goes here

%- Determine the number of theta, phi values
nTheta = size(g1The,1);
nPhi = size(g1The,2);

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

F11 = abs(g1The.^2 + g1Phi.^2).^2;
F22 = abs(g2The.^2 + g2Phi.^2).^2;
F12 = g1The .* conj(g2The) + g1Phi .* conj(g2Phi);

%- Multiply by the spherical metrics (row by row)
for i = 1 : nTheta
    F11(i,:) = F11(i,:) .* sinTh(i);
    F22(i,:) = F22(i,:) .* sinTh(i);
    F12(i,:) = F12(i,:) .* sinTh(i);
end
F11 = F11 .* dPhi;
F22 = F22 .* dPhi;
F12 = F12 .* dPhi;

%e = sum(sum(F)) / cf;
sF11 = sum(sum(F11));
sF22 = sum(sum(F22));
sF12 = sum(sum(F12));

corr = abs(sF12).^2 / ( sF11 * sF22 );


