function [ eff ] = calcPartialEfficiency( the, phi, gain, theStart, theStop, phiStart, phiStop )
%CALCPARTIALEFFICIENCY Summary of this function goes here
%   Detailed explanation goes here


%- Determine the number of theta, phi values
nTheta = size(gain,1);
nPhi = size(gain,2);

%- Pre compute spherical metrics
dTheta = (pi/180) * (the(end)/nTheta);
dPhi = (pi/180) * (phi(end)/nPhi);
sinTh = sin( linspace(0,the(end),nTheta) .* (pi/180) ) .* dTheta;

%- Extract the current gain matrix
data = gain(:,:);

%- Convert to linear units from dBi
data = 10.^(data./10);

%- Mask un wanted data values
itheStart = find(the==theStart);
itheStop = find(the==theStop);
iphiStart = find(phi==phiStart);
iphiStop = find(phi==phiStop);
mask = zeros(nTheta,nPhi);
mask(itheStart:itheStop,iphiStart:iphiStop) = 1;
data = data .* mask;

%- Multiply by the spherical metrics (row by row)
for i = 1 : nTheta
    data(i,:) = data(i,:) .* sinTh(i);
end
data = data .* dPhi;

%- Compute the sum and normalize
eff = sum( sum(data) ) / (4*pi);



