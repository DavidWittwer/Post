function [Ethe_dB, Ethe_deg, Ephi] = N2F(r, f, Ethe_mag, Ethe_pha, Ephi_mag, Ephi_pha, constants)

j = constant.j;

%rot_angle = 45.0 * nsiConstant.deg2rad; % Rotation angle of new coord sys
Ethe_lin = 10.^(Ethe_mag./20);          % Vertical field (linear)
Ephi_lin = 10.^(Ephi_mag./20);          % Horizontal field (linear)

Ethe_rad = Ethe_pha .* constant.deg2rad;
Ephi_rad = Ephi_pha .* constant.deg2rad;

Ethe = Ethe_lin .* exp(j.*Ethe_rad);
Ephi = Ephi_lin .* exp(j.*Ephi_rad);


dTheta = constants.FF_dTH;
dPhi = constants.FF_dPHI;







