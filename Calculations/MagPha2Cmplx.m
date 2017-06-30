function cmplx = MagPha2Cmplx( mag_dB, pha_deg )

mag_lin = 10.^(mag_dB/10);
pha_rad = pha_deg .* pi/180;

cmplx = mag_lin .* exp( sqrt(-1) .* pha_rad);

return
