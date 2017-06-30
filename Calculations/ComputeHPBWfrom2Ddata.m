function [ HPBW ] = ComputeHPBWfrom2Ddata( data, dAngle )

    mask = ones(size(data));
    mask (-data + 3 < 0) = 0;
    HPBW = sum(mask);
    HPBW = HPBW * dAngle;
    
    % This algorithm has difficulty with elevation cut planes because it
    % adds the HPBW from the +90deg and -90deg theta directions.  To help
    % correct this problem, we try to separate the two peaks
    if( HPBW < 145 )
        EPS = 30;   % Cone of search for peak beamwidth
        HPBW1 = sum( mask(1:EPS) ) + sum( mask(size(data)-EPS:size(data)) );
        HPBW2 = sum( mask(size(data)/2-EPS:size(data)/2+EPS) );
        if(HPBW1 > HPBW2)
            HPBW = HPBW1;
        else
            HPBW = HPBW2;
        end
    end

return
