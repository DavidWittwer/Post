function [ success ] = Create3D_CSVFiles( path, freq, Gain, MeasDate, constants, prodName, portLabel )

%Create3DCSVFiles Summary of this function goes here
%   Detailed explanation goes here
DEBUG = 1;  % { 0 = no | 1 = yes }
success = false;
gainRef = -40;

%% Process optional passed arguements


%% Find the maximum gain values for every frequency
numbeam1 = size(freq,1);
dPhi = constants.FF_dPHI;
dThe = constants.FF_dTH;

%% Create a directory to store the NSI Output files in (if it doesn't already
% exist)
cd(path);

dirName = '3D_CSV';
directory = dir(dirName);
if( 0 == size(directory,1) )
    mkdir(dirName)
end

cd(dirName);


%% Augment user supplied antenna details 
label = getProductInfo(prodName);
label.Date_Measured = MeasDate;

%% For each frequency, create a separate GeoPlan file
for i=1:numbeam1
    
    if(DEBUG) 
        display(sprintf('     Writing 3D CSV output: frequency %i of %i.',i,numbeam1));
        %display(sprintf('... index i = %i',i));
        %display(sprintf('... matrix Gain is %i x %i x %i',size(Gain,1), size(Gain,2), size(Gain,3) ));
    end

    freq_MHz = freq(i)/1e6;

    % Extract the pattern to work on
    gain = Gain(:,:,i);

    % Mask the values below gainRef
    gain( gain < gainRef ) = gainRef;
    
    % Find the location of the peak gain
    maxGain = max( max( gain(:) ));

    gain = gain - maxGain;
    attn = abs(gain);
    
    % Create file name
    %[pathstr, name] = fileparts(DataPath); 
    name = [ label.Manufacturer, '_', label.ModelName, '_', sprintf('%6.1fMHz',freq_MHz) ,  '_00DT_', portLabel, '.csv' ];
    name = strrep(name,' ','_');              % replace spaces with _

    
    % Open new GeoPlan file
    fid = fopen(name,'wt');

    fprintf(fid,sprintf('Name,  %s\n',name));
    fprintf(fid,sprintf('Gain,  %4.1f\n',maxGain));

    % Data goes here for co-pol
    nThe = size(gain,1);
    nPhi = size(gain,2);
    for j = 1 : nThe
        for k = 1 : nPhi
            the = (j-1) * dThe;
            phi = (k-1) * dPhi;
            fprintf(fid,'%i, %i, %2.6f\n',the, phi, attn(j,k));
        end
    end
    
    % Close the current file
    fclose(fid);
    
end
%% Return to previous directory
cd('..');
success = true;

return;