function [ CPgainplot XPgainplot Totgainplot ] = scaleForPlotting( CPgain, XPgain, Totgain, plotProperty )
%SCALEFORPLOTTING Summary of this function goes here
%   Detailed explanation goes here

CPgainplot = scaleArrayForPlotting( CPgain, plotProperty );
XPgainplot = scaleArrayForPlotting( XPgain, plotProperty );
Totgainplot = scaleArrayForPlotting( Totgain, plotProperty );

%CPgainplot=CPgain .* (CPgain>plotProperty.rhoplotmin) + plotProperty.rhoplotmin*(CPgain <= plotProperty.rhoplotmin);
%XPgainplot=XPgain .* (XPgain>plotProperty.rhoplotmin) + plotProperty.rhoplotmin*(XPgain <= plotProperty.rhoplotmin);
%Totgainplot=Totgain .* (Totgain>plotProperty.rhoplotmin) + plotProperty.rhoplotmin*(Totgain <= plotProperty.rhoplotmin);
%CPgainplot=round(CPgainplot.*100)./100;
%XPgainplot=round(XPgainplot.*100)./100;
%Totgainplot=round(Totgainplot.*100)./100;

end


function [ A ] = scaleArrayForPlotting( A, plotProperty )

  A = A .* ( A>plotProperty.rhoplotmin ) + plotProperty.rhoplotmin * ( A <= plotProperty.rhoplotmin );
  A = round( A .* 100 ) ./ 100;

end
