function [ success ] = CreatePlanetFiles2( DataPath, freq, gain, plotSlantPolarization, plotForIDAS, invThe, SwapVH )
%NSICREATEPLANETFILES Summary of this function goes here
%   Detailed explanation goes here
DEBUG = 1;  % { 0 = no | 1 = yes }
success = false;
nsiConstant = nsiConstants();

%% Process optional passed arguements
plotSlantPol = 0;
if( exist('plotSlantPolarization', 'var') )
    plotSlantPol = plotSlantPolarization;
end

iDAS = 0;
if( exist('plotForIDAS', 'var') )
    iDAS = plotForIDAS;
end

invertThe = 0;
if( exist('invThe','var') )
    invertThe = invThe;
end

swapVH = 0;
if( exist('SwapVH','var') )
    swapVH = SwapVH;
end

%% Find the maximum gain values for every frequency
numbeam1 = size(freq,1);
dPhi = nsiConstant.FF_dPHI;
dThe = nsiConstant.FF_dTH;
nPhi = nsiConstant.FF_nPHI;

%% Create a directory to store the Planet files in (if it doesn't already
% exist)
cd(DataPath);
%if( ~exist('PlanetFiles', 'dir') ) 
%    mkdir('PlanetFiles');
%end
mkdir('PlanetFiles');
cd('PlanetFiles');
%mkdir('PlanetFiles');

%% Write peak gain values to a file
% Create file name
[pathstr, name] = fileparts(DataPath); 
gName = [ name, '_peak_gain.txt'];
gName = strrep(gName,' ','_');              % replace spaces with _
%gName = sprintf('./PlanetFiles/%s',gName);
  
%% For each frequency, create a separate Planet file
for i=1:numbeam1
    % Extract the pattern to work on
    tmp_gain = gain(:,:,i);
    %size(tmp_gain)

    %  Perform data rotations first!!
    if( invertThe )
        tmp_gain = flipud(tmp_gain);
    end
        
    % Find the peak gain and its location
    [maxGainVal idx] = max( tmp_gain(:) );
    [iThe iPhi] = ind2sub(size(tmp_gain),idx);
    
    %tmp_gain = circshift(tmp_gain,[-iThe -iPhi]);
    if(iDAS)
        offset = 0;  % This should work for IDAS
    else
        offset = 90; % This works for ODAS
    end
    tmp_gain = circshift(tmp_gain,[-offset -iPhi]);

    % Compute the angles where the max gain occurs
    gmaxThe = (iThe-1) * nsiConstant.FF_dTH;
    gmaxPhi = (iPhi-1) * nsiConstant.FF_dPHI;

    % Extract vertical and horizontal pattern data
    % Azimuth data
    iiThe = mod(iThe - offset,181);
    if( iiThe == 0 )
        iiThe = 181;
    end
    az_data = abs( tmp_gain(iiThe,1:end-1)' - maxGainVal );
    
    % Elevation data
    % -- grab the first half of the data @ 0 deg
    data1 = tmp_gain(:,1);
    
    % -- grab the second half of the data @ 180 deg
    data2 = tmp_gain(:,181);
    
    % Concatenate the two parts, omitting the last point of each half.
    % Convert to Planet file scaling
    el_data = abs( [ data1(1:end-1); flipud(data2(2:end)) ] - maxGainVal );
    if(iDAS)
        el_data = circshift(el_data,-90);
    end
    
    % Swap Vertical and Horizontal cuts if requested by the user
    if(swapVH)
        tmp = az_data;
        az_data = el_data;
        el_data = tmp;
    end
 
    % compute the half power beam widths (HPBW)
    mask = ones(size(az_data));
    mask (-az_data + 3 < 0) = 0;
    azHPBW = sum(mask);
    azHPBW = azHPBW * dPhi;
    
    mask = ones(size(el_data));
    mask (-el_data + 3 < 0) = 0;
    elHPBW = sum(mask);
    elHPBW = elHPBW * dThe;
    
    %% Create file name
    [pathstr, name] = fileparts(DataPath); 
    fName = [ name, '_', num2str(ceil(freq(i)/1e6)), '.txt'];
    fName = strrep(fName,' ','_');              % replace spaces with _
    fName = strrep(fName,'_MLdata','');         % remove text from name
    %fName = sprintf('./PlanetFiles/%s',fName);
    
    
    % Write peak gain to file
    [fid, MESSAGE] = fopen(gName,'at');
    fprintf(fid, '%4.0f, %6.2f\n', freq(i)/1e6, maxGainVal);
    fclose(fid);
    
    % Open new planet file
    fid = fopen(fName,'wt');

    % Write header to file
    fprintf(fid,'NAME\t%s\n', fName );
    fprintf(fid,'MAKE\t%s\n', 'GALTRONICS' );
    fprintf(fid,'FREQUENCY\t%4.0f\n', freq(i) / 1e6 );
    fprintf(fid,'H_WIDTH\t%i\n', azHPBW );
    fprintf(fid,'V_WIDTH\t%i\n', elHPBW );
    fprintf(fid,'FRONT_TO_BACK\t%i\n', 0 );
    fprintf(fid,'GAIN\t%6.2f dBi\n', maxGainVal );
    fprintf(fid,'TILT\t%s\n', 'fixed' );
    if(plotSlantPol)
        fprintf(fid,'POLARIZATION\t%s\n', 'slant 45' );
    else
        fprintf(fid,'POLARIZATION\t%s\n', 'linear' );
    end
    %fprintf(fid,'COMMENT\t%s\n', 'preliminary' );
    fprintf(fid,'COMMENT\tPeak Gain found at (Theta,Phi) = (%i,%i) deg\n', gmaxThe, gmaxPhi);
    
    if(DEBUG) 
        disp(sprintf('Offsets (theta,phi) = (%5.1f,%5.1f)deg',gmaxThe,gmaxPhi));
    end

    % Write azimuth cut
    fprintf(fid,'HORIZONTAL\t%i\n', size(az_data,1) );
    for j = 1 : size(az_data,1)
        fprintf(fid,'%i\t%5.3f\n', j-1, az_data(j) ); 
    end
    
    % Write elevation cut
    % Elevation cuts are created from two columns of the matrix.  The first
    % column must include the maximum value.  The second column is its
    % compliment.
    fprintf(fid,'VERTICAL\t%i\n', size(el_data,1) );
    % Output the pattern data
    for j = 1 : size(el_data,1)
        fprintf(fid,'%i\t%5.3f\n', j-1, el_data(j) ); 
    end
    
    % Close the current file
    fclose(fid);

    % Debug plot
    if(DEBUG)
        % Create figure
        figure1 = figure;

        % Create axes
        axes1 = axes('Parent',figure1);
        xlim([0 180]);
        ylim([0 360]);
        zlim([-20 15]);
        view([-54 34]);
        hold('all');

        % Create surface
        the = (0:1:180);
        phi = (0:1:360);
        mesh(the, phi, tmp_gain(:,:)', 'Parent', axes1);

        % Plot the max gain value at its location
        % -- Find the peak gain and its location
        [maxGainVal idx] = max( tmp_gain(:) );
        [iThe iPhi] = ind2sub(size(tmp_gain),idx);
        the = (iThe-1)*dThe;
        phi = (iPhi-1)*dPhi;
        plot3(the,phi,1.0*maxGainVal,'ok');
        
        % Plot the azimuth (horizontal) data
        the = (iiThe-1)*ones(1,360);
        phi = (0:1:359);
        g = 1.05*maxGainVal - az_data;
        plot3(the, phi, g', '-k', 'LineWidth', 1.4);
        
        % Plot the first part of the elevation (vertical) data
        the = (0:1:180);
        phi = zeros(1,181);
        g = 1.05*maxGainVal - el_data(1:181);
        plot3(the, phi, g', '-r', 'LineWidth', 1.4);
        
        % Plot the second part of the elevation (vertical) data
        the = (1:1:180);
        phi = 180*ones(1,180);
        g = 1.05*maxGainVal - flipud(el_data(end-179:end));
        plot3(the, phi, g', '-r', 'LineWidth', 1.4);

        % Create xlabel
        xlabel('Theta (deg)');

        % Create ylabel
        ylabel('Phi (deg)');
        
    end
    
end
%% Return to previous directory
cd('..');
success = true;
