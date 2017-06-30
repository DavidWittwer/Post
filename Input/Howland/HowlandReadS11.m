function [ S11data, S11path ] = HowlandReadS11(  )
%HOWLANDREADS11 Reads Howland S11 text files into and array
%   This function reads Howland text file format into an array, S11data.
%   The array format is Nx3 where N is the number for frequency points.
%   The three columns correspond to Freq_MHz, Mag_dB, Phase_deg
%
%   18 April 2012
%   D. C. Wittwer
%   Galtronics USA


% Prompt the user for the name of the Howland S11 txt file 
uiText = 'Select Howland S11 data file ';
[fname, path] = uigetfile('*S11.txt', uiText);
S11path = [path,fname];

% Perform error checking on the filename returned from the user interface
if isequal(fname,0) || isequal(path,0)
    disp('File not found');
else
    disp(['Loading file ', path, fname, ' ...']);
end

% Open the file
fid = fopen( [path fname], 'r');
txtline = fgets(fid);

teststr = 'Frequency Count';
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end
[predicate, remainder] = strtok(txtline,':');
value = strtok(remainder,' :');
nFreq = str2num(value);

teststr = 'Return Loss S11 Data Results'; 
% Keep reading lines until teststr is found
while (isempty(findstr(teststr,txtline)))
    txtline=fgets(fid);
end

% Throw away the next line:  " S11 S11 "
txtline = fgets(fid);

% Throw away the next line:  " Freq Mag Phase "
txtline = fgets(fid);

% Throw away the next line:  " (MHz)  (dB)  (deg)" ... or better yet do
% error checking (later)
txtline = fgets(fid);

% Read the data (freq_MHz, amp_dB, phase_deg)
k = 0;
S11data = zeros(nFreq,3);
while ~feof(fid) 
    line = fscanf(fid, '%f %f %f',3);
    if isempty(line)
        break;
    end
    k = k + 1;
    S11data(k,:) = line.';
    %S11data(k,1) = line(1);
    %s11mag = sqrt( line(1)^2 +  line(2)^2 );
    %S11data(k,2) = 20*log10( s11mag );
end




