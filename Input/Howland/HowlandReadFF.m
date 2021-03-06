function [ Freq, Vmag_dB, Vpha_deg, Hmag_dB, Hpha_deg, constants, Date ] = HowlandReadFF( PATH, FNAME  )
%HOWLANDREADS11 Reads Howland S11 text files into and array
%   This function reads Howland text file format into an array, S11data.
%   The array format is Nx3 where N is the number for frequency points.
%   The three columns correspond to Freq_MHz, Mag_dB, Phase_deg
%
%   18 April 2012
%   D. C. Wittwer
%   Galtronics USA

% Aug 10, 2012 : Added option 'path' and 'filename' input arguments

%% Process optional passed arguements
path = '';
if( exist('PATH', 'var') )
    path = PATH;
end

fname = '';
if( exist('FNAME', 'var') )
    fname = FNAME;
end

if( isempty(path) || isempty(fname) )
    % Prompt the user for the name of the Howland S11 txt file
    uiText = 'Select Howland FF data file ';
    [fname, path] = uigetfile('*FF*.txt', uiText);
end

% Perform error checking on the filename
if( isequal(fname,0) || isequal(path,0) )
    disp('File not found');
else
    disp(['Loading file ', path, '\', fname, ' ...']);
end

%% Open the file
fHandle = dir([path, '\', fname]);
Date = fHandle.date;

fid = fopen( [path, '\', fname], 'r');
txtline = fgets(fid);

%% Parse file header
teststr = 'Test Frequency';
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end
[predicate, remainder] = strtok(txtline,':');
value = strtok(remainder,' :');
Freq = str2double(value);

teststr = 'Axis1 Start Angle';
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end
[predicate, remainder] = strtok(txtline,':');
value = strtok(remainder,' :');
phi_start = str2double(value);

teststr = 'Axis1 Stop Angle';
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end
[predicate, remainder] = strtok(txtline,':');
value = strtok(remainder,' :');
phi_stop = str2double(value);

teststr = 'Axis1 Increment';
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end
[predicate, remainder] = strtok(txtline,':');
value = strtok(remainder,' :');
phi_incr = str2double(value);


teststr = 'Axis2 Start Angle';
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end
[predicate, remainder] = strtok(txtline,':');
value = strtok(remainder,' :');
theta_start = str2double(value);

teststr = 'Axis2 Stop Angle';
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end
[predicate, remainder] = strtok(txtline,':');
value = strtok(remainder,' :');
theta_stop = str2double(value);

teststr = 'Axis2 Increment';
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end
[predicate, remainder] = strtok(txtline,':');
value = strtok(remainder,' :');
theta_incr = str2double(value);

teststr = 'FF Pattern Calculated Gain';
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end
[predicate, remainder] = strtok(txtline,':');
value = strtok(remainder,' :');
maxGain = str2double(value);


% Find the start of the data
teststr = '(deg)'; 
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end

%% Parse file data
% Read the data (theta, phi, Hmag_dB, Hpha_deg, Vmag_dB, Vpha_deg)
k = 0;
nTheta = 1 + ( theta_stop - theta_start ) / theta_incr;
nPhi = 1 + ( phi_stop - phi_start ) / phi_incr;

% Define constants
constants = Constants();
constants.FF_nTH = nTheta;
constants.FF_cTH = ceil( constants.FF_nTH / 2 );
constants.FF_dTH = theta_incr; %spatial FF sampling interval in Theta (in degrees)
constants.FF_nPHI = nPhi;
constants.FF_cPHI = ceil( constants.FF_nPHI / 2 );
constants.FF_dPHI = phi_incr;  %spatial FF sampling interval in Phi (in degrees)

Vmag_dB = zeros(nTheta,nPhi+1);
Vpha_deg = zeros(nTheta,nPhi+1);
Hmag_dB = zeros(nTheta,nPhi+1);
Hpha_deg = zeros(nTheta,nPhi+1);
while ~feof(fid) 
    line = fscanf(fid, '%f %f %f %f %f %f',6);
    if isempty(line)
        break;
    end
    k = k + 1;
    theta = 1 + ( line(1) - theta_start ) / theta_incr;
    phi = 1 + ( line(2) - phi_start ) / phi_incr;
    Vmag_dB(theta,phi) = line(5);
    Vpha_deg(theta,phi) = line(6);
    Hmag_dB(theta,phi) = line(3);
    Hpha_deg(theta,phi) = line(4);
end

%% Close file
fclose(fid);

%% Replicate last phi point so data has 361 phi points
% -- this is done to be compatible with existing plot formats
% -- even though this point is a duplicate
Vmag_dB(:,end) = Vmag_dB(:,1);
Hmag_dB(:,end) = Hmag_dB(:,1);
Vpha_deg(:,end) = Vpha_deg(:,1);
Hpha_deg(:,end) = Hpha_deg(:,1);
