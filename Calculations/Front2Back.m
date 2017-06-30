
function F2B = Front2Back( azPattern, elPattern )
%Front2Back Summary of this function goes here
% Detailed explanation goes here
%   azPattern = azimuth Planet file cut
%   elPattern = elevation Planet file cut

% Process optional passed arguements

BackLobeDefn = 30;          % Back lobe is defined as +/- BackLobeDefn

HorzMask = zeros(1,360);
HorzMask(1,180-BackLobeDefn:180+BackLobeDefn) = 1.0;
HorzF2B = HorzMask .* azPattern(:)';
HorzF2B( HorzF2B==0 ) = 100;
HF2B = min(HorzF2B);

ElevMask = zeros(1,360);
ElevMask(1,180-BackLobeDefn:180+BackLobeDefn) = 1.0;
ElevF2B = ElevMask .* elPattern(:)';
ElevF2B( ElevF2B==0 ) = 100;
EF2B = min(ElevF2B);

F2B = min(HF2B,EF2B);

return;
