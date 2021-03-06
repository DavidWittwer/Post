function [Prx p] = CalcRxPowerUniformPhase( gain, distribution )
%CalcRxPowerUniformPhase Compute Received Power given antenna gain in a
%Rayleigh scattering environment.
%   INPUT:
%       gain = complex antenna gain
%       distribution = 2D Rayleight distribution (constant amplitude,
%       uniformly distributed phase) (optional)
%   OUTPUT:
%       Prx = received power (lin)
%       p= Rayleigh 2D distribution used to compute received power.  Note
%       this distribution is returned so that other antenna gain patterns
%       may be weighted by exactly the same distribution.
%   VERSION:
%       24JUL14:  Initial version (DCW)
%


    % Check for optional passed variables
    if( exist('distribution', 'var') )
        p = distribution;
    else
        % Probability distribution
        phase = 2.*pi.*rand( size(gain) );
        npts = sum(size(gain));
        amp = 1/npts;
        p = amp.* exp( sqrt(-1) .* phase );
    end
    
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
    cf = sum(sum(one)); % Correction Factor (cf) to account for numerical integration of (2*2pi)=4pi

    Pwr = abs( gain .* conj(p) );  % Weight gain by Rayleigh field.

    %- Multiply by the spherical metrics (row by row)
    for i = 1 : nTheta
        Pwr(i,:) = Pwr(i,:) .* sinTh(i);
    end
    Pwr = Pwr .* dPhi;
    Prx = sum(sum(Pwr)) / cf;

return;

