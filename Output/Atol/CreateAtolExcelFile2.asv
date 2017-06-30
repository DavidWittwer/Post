function [ success ] = CreateAtolExcelFile2( DataPath, constants, freq, gain, plotSlantPolarization, invThe, SwapVH, Date, prodName, portLabel, THETA, PHI )
%CREATEGEOPLANFILES2 Summary of this function goes here
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

dirName = 'AtolExcel';
directory = dir([dirName '*']);
if( 0 == size(directory,1) )
    mkdir(dirName)
end
cd(dirName);


%% Create file header
header{1} = 'Name';
header{2} = 'Gain (dBi)';
header{3} = 'Manufacturer';
header{4} = 'Comments';
header{5} = 'Pattern';
header{6} = 'Pattern Electrical Tilt (°)';
header{7} = 'Physical Antenna';
header{8} = 'BEAMWIDTH';
header{9} = 'FMIN';
header{10} = 'FMAX';
header{11} = 'FREQUENCY';
header{12} = 'V_WIDTH';
header{13} = 'FRONT_TO_BACK';
header{14} = 'TILT';
header{15} = 'H_WIDTH';
header{16} = 'FAMILY';


%% Get antenna details from the user with GUI
label = getProductInfo(prodName);
label.Date_Measured = Date;
label.Lower_Freq = freq(1)/1e6;
label.Upper_Freq = freq(numbeam1)/1e6;

data{1} = label.ModelName;
data{3} = label.Manufacturer;
data{9} = label.Lower_Freq;
data{10} = label.Upper_Freq;
%data{8} = 'pattern electrical azimuth (deg)';



%% For each frequency, add the data to the file
for i=1:numbeam1

    % Create workbook and write header info
    % Create file name
    %[pathstr, name] = fileparts(DataPath); 
    freq_MHz = freq(i)/1e6;
    fName = [ label.Manufacturer, '_', label.ModelName, '_', sprintf('%6.1fMHz',freq_MHz) , '_', portLabel, '.xlsx' ];
    %fName = [ label.Manufacturer, '_', label.ModelName, '_MHz.csv'  ];
    fName = strrep(fName,' ','_');              % replace spaces with _
    fName = strrep(fName,'_MLdata','');         % remove text from name
    
    % Create pattern label
    name = [ label.ModelName, '_', sprintf('%6.1fMHz',freq_MHz), '_', portLabel, '_00dg' ];
    

    status = xlswrite(fName,header,1,'A1:P1');

    % Extract the pattern to work on
    tmp_gain = gain(:,:,i);
    %size(tmp_gain)

    %  Perform data rotations first!!
    if( invertThe )
        tmp_gain = flipud(tmp_gain);
    end
        
    % Find the location of the peak gain
    if( useThetaPhi )
        iThe = theta_/dThe + 1;
        iPhi = phi_/dPhi + 1;
    else
        [maxGainVal idx] = max( tmp_gain(:) );
        [iThe iPhi] = ind2sub(size(tmp_gain),idx);
    end

    % Convert to Atol file scaling (attn)
    attn = abs( tmp_gain - maxGainVal );
    
    az_data = attn(iThe,1:end-1)';
    iPhiDeg = (iPhi-1) * dPhi;
    
    [minVal azOffset] = min( az_data ); 
    az_data = flipud( circshift(az_data,[-azOffset 0]) );
    
    % Elevation data
    % -- grab the first half of the data @ 0 deg
    data1 = attn(:,iPhi);
    
    % -- grab the second half of the data @ 180 deg
    iiPhi = mod(iPhi+180,361);
    data2 = attn(:,iiPhi);
    
    % Concatenate the two parts, omitting the last point of each half.
    % Convert to GeoPlan file scaling (dBd)
    el_data = [ data1(1:end-1); flipud(data2(2:end)) ];
    %el_data = circshift(el_data,-thetaOffset);
    
    % Swap Vertical and Horizontal cuts if requested by the user
    if(swapVH)
        tmp = az_data;
        az_data = el_data;
        el_data = tmp;
    end

    %=====================================================================
    % compute the half power beam widths (HPBW)
    %---------------------------------------------------------------------
    azHPBW = ComputeAzimuthHPBWfrom2Ddata(az_data,dPhi);
    elHPBW = ComputeElevationHPBWfrom2Ddata(el_data,dThe);
    
    % Write the data to the Atol Excel file
    %xlsrange = sprintf('A%i:P%i',i+1,i+1);
    xlsrange = sprintf('A%i:P%i',2,2);
    data{2} = maxGainVal;  % Gain
    data{4} = sprintf('%s',label.Part_Number);  % Comment
    
    angleLabels = linspace(0,359,360);
    %outputData = 10.^(az_data./10)';
    
    % Reverse az string to comply with ATOL azimuth angle definition
    %az_data = circshift(az_data,89);
    %az_data = fliplr(az_data);

    el_data = circshift(el_data,-90);

    azOutData = [ angleLabels; az_data' ];
    elOutData = [ angleLabels; el_data' ];

    azOutData = reshape(azOutData,1,size(azOutData,1)*size(azOutData,2));
    elOutData = reshape(elOutData,1,size(elOutData,1)*size(elOutData,2));
    
    azOutString = sprintf('%i %3.2f ',azOutData(1,1:end));
    elOutString = sprintf('%i %3.2f ',elOutData(1,1:end));
    
    data{5} = sprintf('2 0 0 360 %s 1 0 360 %s 0',azOutString,elOutString);  % Pattern
    data{6} = 0;  % PatternElectrical Titl ()
    data{7} = '';  % Physical Antenna
    data{8} = azHPBW;
    data{11} =  freq_MHz;
    data{12} = elHPBW;
    data{13} = '';  % Front to Back
    data{14} = '0';  % Tilt
    data{15} = azHPBW;  % H_WIDTH
    data{16} = sprintf('%s',name); % Family
    
    %disp(sprintf('Now writing Excel range %s\n',xlsrange));
    status = xlswrite(fName,data,1,xlsrange);
    %status = xlswrite(fName,data{1},1,sprintf('A%i',i));
    %disp(sprintf('File %s written with the following status = %s',fName,status));
    
end
%% Return to previous directory
cd('..');
success = true;
