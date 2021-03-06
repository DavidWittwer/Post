function [ handle ] = Plot3D_with_PlanetFileCuts( gain, az_data, el_data, maxGainVal, iThe, iPhi, dThe, dPhi)
%PLOT3D_WITH_PLANETFILECUTS Summary of this function goes here
%   Detailed explanation goes here

    thetaOffset = 90;

    %=====================================================================
    % Create figure
    %---------------------------------------------------------------------
    handle = figure;

    % Create axes
    axes1 = axes('Parent',handle);
    xlim([0 180]);
    ylim([0 360]);
    zlim([-20 15]);
    view([-54 34]);
    hold('all');

    %=====================================================================
    % Create surface
    %---------------------------------------------------------------------
    the = (0:1:180);
    phi = (0:1:360);
    mesh(the, phi, gain(:,:)', 'Parent', axes1);

    %=====================================================================
    % Plot the max gain value at its location
    %---------------------------------------------------------------------
    % -- Find the peak gain and its location
    %[maxGainVal idx] = max( tmp_gain(:) );
    %[iThe iPhi] = ind2sub(size(tmp_gain),idx);
    the = (iThe-1)*dThe;
    phi = (iPhi-1)*dPhi;
    plot3(the,phi,1.05*maxGainVal,'ok');

    %=====================================================================
    % Plot the azimuth (horizontal) data
    %---------------------------------------------------------------------
    the = (iThe-1)*ones(1,360);
    phi = (0:1:359);
    iPhiDeg = (iPhi-1) * dPhi;
    g = 1.05*maxGainVal - circshift(az_data,iPhiDeg);
    plot3(the, phi, g', '-k', 'LineWidth', 1.4);

    %=====================================================================
    % Plot the first part of the elevation (vertical) data
    %---------------------------------------------------------------------
    the = (0:1:180);
    phi = (iPhi-1)*ones(1,181);
    data = circshift(el_data,thetaOffset);
    g = 1.05*maxGainVal - data(1:181);
    plot3(the, phi, g', '-r', 'LineWidth', 1.4);

    %=====================================================================
    % Plot the second part of the elevation (vertical) data
    %---------------------------------------------------------------------
    the = (1:1:180);
    iiPhi = mod(iPhi+180,361);
    phi = (iiPhi-1)*ones(1,180);
    g = 1.05*maxGainVal - flipud(data(end-179:end));
    plot3(the, phi, g', '-r', 'LineWidth', 1.4);

    %=====================================================================
    % Create xlabel
    %---------------------------------------------------------------------
    xlabel('Theta (deg)');

    %=====================================================================
    % Create ylabel
    %---------------------------------------------------------------------
    ylabel('Phi (deg)');

