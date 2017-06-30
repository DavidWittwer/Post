function WriteMaxMinToFile( fname, freq, maxGain, minGain, label )
%WRITEMAXMINTOFILE Summary of this function goes here
%   Detailed explanation goes here

nFreq = size(freq,1);

% Open the output file
[fid, message] = fopen(fname,'wt');

% Check for erros
if( message ~= '' )
    
    disp( sprintf('Unable to open output file: %s',fname) );
    disp( sprintf('%s',message) );
    
else
    % Print table of max/min values to a file
    fprintf(fid,'%s\n',label);
    fprintf(fid,'Freq (MHz) \tG_{tot,max} \tG_{tot,min}\n');

    for i = 1 : nFreq
        fprintf( fid, '%i\t%g5\t%g5\n', ...
            ceil(freq(i)/(1*10^6)), ...
            maxGain(1,1,i), ...
            minGain(1,1,i) );
    end
    
    fclose(fid);
    
end


