function [ HPBW ] = ComputeElevationHPBWfrom2Ddata( data, dAngle )

    npts = size(data);
    npts_by_2 = fix(npts/2);
    mask = ones(npts);
    data = circshift(data,npts_by_2);
    
    mask (-data + 3 < 0) = 0;

    HPBW_left  = sum(mask(1:npts_by_2));
    HPBW_right = sum(mask(npts_by_2+1:npts));
    
    HPBW = 0;
    if HPBW_left > HPBW_right
        HPBW = HPBW_left
    else
        HPBW = HPBW_right
    end
    
    if HPBW_left == 0
        HPBW = HPBW_right;
    end
    
    if HPBW_right == 0
        HPBW = HPBW_left;
    end
    
    HPBW = HPBW * dAngle;
    
    % This algorithm has difficulty with elevation cut planes because it
    % adds the HPBW from the +90deg and -90deg theta directions.  To help
    % correct this problem, we try to separate the two peaks
%     if( HPBW < 145 )
%         EPS = 30;   % Cone of search for peak beamwidth
%         HPBW1 = sum( mask(1:EPS) ) + sum( mask(size(data)-EPS:size(data)) );
%         HPBW2 = sum( mask(size(data)/2-EPS:size(data)/2+EPS) );
%         if(HPBW1 > HPBW2)
%             HPBW = HPBW1;
%         else
%             HPBW = HPBW2;
%         end
%     end

return
