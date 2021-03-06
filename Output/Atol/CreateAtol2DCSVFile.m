function [ success ] = CreateAtol2DCSVFile( DataPath, constants, freq, gain, plotSlantPolarization, invThe, SwapVH, Date, prodName, portLabel, THETA, PHI )
%CREATEATOL2DCSVFILE Summary of this function goes here
%   Detailed explanation goes here
DEBUG = 1;  % { 0 = no | 1 = yes }
success = false;

%% Process optional passed arguements
plotSlantPol = 0;
if( exist('plotSlantPolarization', 'var') )
    plotSlantPol = plotSlantPolarization;
end

invertThe = 0;
if( exist('invThe','var') )
    invertThe = invThe;
end

swapVH = 0;
if( exist('SwapVH','var') )
    swapVH = SwapVH;
end

theta_ = 0;
useTheta = false;
if( exist('THETA','var') )
    theta_ = THETA;
    useTheta = true;
end

phi_ = 0;
usePhi = false;
if( exist('PHI','var') )
    phi_ = PHI;
    usePhi = true;
end

useThetaPhi = false;
if( useTheta && usePhi )
    useThetaPhi = true;
end

thetaOffset = 90;

%% Find the maximum gain values for every frequency
numbeam1 = size(freq,1);
dPhi = constants.FF_dPHI;
dThe = constants.FF_dTH;
nPhi = constants.FF_nPHI;

%% Create a directory to store the GeoPlan files in (if it doesn't already
% exist)
cd(DataPath);

dirName = 'Atol2D';
directory = dir([dirName '*']);
if( 0 == size(directory,1) )
    mkdir(dirName)
end
cd(dirName);


%% Get antenna details from the user with GUI
label = getProductInfo(prodName);
label.Date_Measured = Date;
label.Lower_Freq = freq(1)/1e6;
label.Upper_Freq = freq(numbeam1)/1e6;


%% For each frequency, add the data to the file
for i=1:numbeam1

    % Create file name
    %[pathstr, name] = fileparts(DataPath); 
    %fName = [ label.Manufacturer, '_', label.ModelName, '_MHz.csv'  ];
    freq_MHz = freq(i)/1e6;
    fName = [ label.Manufacturer, '_', label.ModelName, '_', sprintf('%6.1fMHz',freq_MHz) , '_', portLabel, '.txt' ];
    fName = strrep(fName,' ','_');              % replace spaces with _
    fName = strrep(fName,'_MLdata','');         % remove text from name


    % Open new text file
    fid = fopen(fName,'wt');

    % Write header informatoin
    %fprintf(fid,'Name\tGain  (dBi)\tManufacturer\tComments\tPattern Electrical Tilt (�)\tPattern\tBEAMWIDTH\tFMIN\tFMAX\tFREQUENCY\tV_WIDTH\tFRONT_TO_BACK\tTILT\tH_WIDTH\tFAMILY\n');
    fprintf(fid,'Name\tGain  (dBi)\tManufacturer\tComments\tPattern Electrical Tilt (�)\tPattern\tBEAMWIDTH\tFMIN\tFMAX\tFREQUENCY\tV_WIDTH\tTILT\tH_WIDTH\tFAMILY\n');

    
    % Create pattern label
    name = [ label.ModelName, '_', sprintf('%6.1fMHz',freq_MHz), '_', portLabel, '_00dg' ];
    
    % Extract the pattern to work on
    tmp_gain = gain(:,:,i);
    maxGain = max( max(tmp_gain(:)) );

    %  Perform data rotations first!!
    if( invertThe )
        tmp_gain = flipud(tmp_gain);
    end

    % Find the location of the peak gain
    [maxGain idx] = max( tmp_gain(:) );
    
    % Find the location of the min attenuation
    if( useThetaPhi )
        iThe = theta_/dThe + 1;
        iPhi = phi_/dPhi + 1;
    else
        [maxGain idx] = max( tmp_gain(:) );
        [iThe iPhi] = ind2sub(size(tmp_gain),idx);
    end

    % Convert to Atol file scaling (attn)
    attn = abs( tmp_gain - maxGain );
    
    az_data = attn(iThe,1:end-1)';
    % Reverse az string to comply with ATOL azimuth angle definition
    az_data = circshift(az_data,-89);
    az_data = fliplr(az_data);

    iPhiDeg = (iPhi-1) * dPhi;
    %az_data = circshift(az_data,-iPhiDeg);
    
    % Elevation data
    % -- grab the first half of the data @ 0 deg
    data1 = attn(:,iPhi);
    
    % -- grab the second half of the data @ 180 deg
    iiPhi = mod(iPhi+180,361);
    data2 = attn(:,iiPhi);
    
    % Concatenate the two parts, omitting the last point of each half.
    % Convert to GeoPlan file scaling (dBd)
    el_data = [ data1(1:end-1); flipud(data2(2:end)) ];
    el_data = circshift(el_data,-90);
    
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
    
    angleLabels = linspace(0,359,360);
    azOutData = [ angleLabels; az_data' ];
    elOutData = [ angleLabels; el_data' ];

    azOutData = reshape(azOutData,1,size(azOutData,1)*size(azOutData,2));
    elOutData = reshape(elOutData,1,size(elOutData,1)*size(elOutData,2));
    
    azOutString = sprintf('%i %3.2f ',azOutData(1,1:end));
    elOutString = sprintf('%i %3.2f ',elOutData(1,1:end));
    
    data{11} = 90 - iPhi;  % computed titl

    fprintf(fid,sprintf('%s\t',name));
    fprintf(fid,sprintf('%5.1f\t',maxGain));
    fprintf(fid,sprintf('%s\t',label.Manufacturer));
    fprintf(fid,sprintf('%s\t',label.Part_Number));
    fprintf(fid,sprintf('0 deg\t'));
    fprintf(fid,sprintf('2 0 0 360 %s 1 0 360 %s 0\t',azOutString,elOutString));
    fprintf(fid,sprintf('%5.2f\t',azHPBW));
    fprintf(fid,sprintf('%6i\t',label.Lower_Freq));
    fprintf(fid,sprintf('%6i\t',label.Upper_Freq));
    fprintf(fid,sprintf('%6i\t',freq_MHz));
    fprintf(fid,sprintf('%5.2f\t',elHPBW));
    %fprintf(fid,sprintf('0\t')); % Front to back ratio
    fprintf(fid,sprintf('0\t')); % tilt
    fprintf(fid,sprintf('%5.2f\t',azHPBW));
    fprintf(fid,sprintf('%s\n',name));
   
    fclose(fid);

end


%% Return to previous directory
cd('..');
success = true;
