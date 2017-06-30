function [ success ] = CreateAtolExcelFile( DataPath, freq, gain, plotSlantPolarization, invThe, SwapVH, Date, prodName, THETA, PHI )
%CREATEGEOPLANFILES3 Summary of this function goes here
%   Detailed explanation goes here
DEBUG = 1;  % { 0 = no | 1 = yes }
success = false;
nsiConstant = nsiConstants();

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
dPhi = nsiConstant.FF_dPHI;
dThe = nsiConstant.FF_dTH;
nPhi = nsiConstant.FF_nPHI;

%% Create a directory to store the GeoPlan files in (if it doesn't already
% exist)
cd(DataPath);

directory = dir('AtolFile*');
if( 0 == size(directory,1) )
    mkdir('AtolFile')
end

cd('AtolFile');


%% Create file header
header{1} = 'Name';
header{2} = 'Gain (dBi)';
header{3} = 'Manufacturer';
header{4} = 'Comments';
header{5} = 'Pattern';
header{6} = 'Pattern Electrical Tilt (°)';
header{7} = 'Beamwidth';
header{8} = 'FMIN';
header{9} = 'FMAX';
header{10} = 'Frequency';
header{11} = 'V_WIDTH';
header{12} = 'FRONT_TO_BACK';
header{13} = 'TILT';
header{14} = 'H_WIDTH';
header{15} = 'DIMENSIONS HxWxD (m)';
header{16} = 'WEIGTH (kg)';

%% Get antenna details from the user with GUI
label = getProductInfo(prodName);
label.Date_Measured = Date;
label.Lower_Freq = freq(1)/1e6;
label.Upper_Freq = freq(numbeam1)/1e6;

data{1} = label.ModelName;
data{3} = label.Manufacturer;
data{6} = 0;
data{8} = label.Lower_Freq;
data{9} = label.Upper_Freq;

%% Create workbook and write header info
% Create file name
%[pathstr, name] = fileparts(DataPath); 
fName = [ label.Manufacturer, '_', label.ModelName, '_MHz.csv'  ];
fName = strrep(fName,' ','_');              % replace spaces with _
fName = strrep(fName,'_MLdata','');         % remove text from name

fid = fopen(name,'wt');
fprintf(fid,sprint('%s\t',header{1}));
fprintf(fid,sprint('%s\t',header{2}));
fprintf(fid,sprint('%s\t',header{3}));
fprintf(fid,sprint('%s\t',header{4}));
fprintf(fid,sprint('%s\t',header{5}));
fprintf(fid,sprint('%s\t',header{6}));
fprintf(fid,sprint('%s\t',header{7}));
fprintf(fid,sprint('%s\t',header{8}));
fprintf(fid,sprint('%s\t',header{9}));
fprintf(fid,sprint('%s\t',header{10}));
fprintf(fid,sprint('%s\t',header{11}));
fprintf(fid,sprint('%s\t',header{12}));
fprintf(fid,sprint('%s\t',header{13}));
fprintf(fid,sprint('%s\t',header{14}));
fprintf(fid,sprint('%s\t',header{15}));
fprintf(fid,sprint('%s\t',header{16}));
fprintf(fid,sprint('\n'));

%% For each frequency, add the data to the file
for i=1:numbeam1

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
    %el_data = circshift(el_data,-thetaOffset);
    
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
    
    % Write the data to the Atol Excel file
    xlsrange = sprintf('A%i:K%i',i+1,i+1);
    data{2} = max( attn(:) );
    data{4} = sprintf('%s %i',label.ModelName,freq(i)/1e6);
    
    angleLabels = linspace(0,359,360);
    %outputData = 10.^(az_data./10)';
    azOutData = [ angleLabels; az_data' ];
    elOutData = [ angleLabels; el_data' ];

    azOutData = reshape(azOutData,1,size(azOutData,1)*size(azOutData,2));
    elOutData = reshape(elOutData,1,size(elOutData,1)*size(elOutData,2));
    
    azOutString = sprintf('%i %3.2f ',azOutData(1,1:end-1));
    elOutString = sprintf('%i %3.2f ',elOutData(1,1:end-1));
    
    %data{5} = [2, 0, 0, 360, stringData 0 ];
    data{5} = sprintf('2 0 0 360 %s 1 0 360 %s 0',azOutString,elOutString);
    data{6} = 0; %90 - iThe;
    data{7} = sprintf('%s %i',label.ModelName,freq(i)/1e6);
    %data{8} = 360 - azHPBW;
    data{11} = 90 - iPhi;

    %disp(sprintf('Now writing Excel range %s\n',xlsrange));
    status = xlswrite(fName,data,1,xlsrange);
    %status = xlswrite(fName,data{1},1,sprintf('A%i',i));
    disp(sprintf('File %s written with the following status = %s',fName,status));
    
end
%% Return to previous directory
cd('..');
success = true;
