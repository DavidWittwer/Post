function [ success ] = HowlandWriteFF( fname, path, freq, gain, Vmag_dB, Vpha_deg, Hmag_dB, Hpha_deg )
%HOWLANDREADS11 Reads Howland S11 text files into and array
%   This function reads Howland text file format into an array, S11data.
%   The array format is Nx3 where N is the number for frequency points.
%   The three columns correspond to Freq_MHz, Mag_dB, Phase_deg
%
%   18 April 2012
%   D. C. Wittwer
%   Galtronics USA


% Determine size of arrays
nTheta = size(Vmag_dB,1);
nPhi   = size(Vmag_dB,2);

% Open the output file for writing text
fid = fopen( [path fname], 'wt');

% Write the file header
fprintf(fid,'\n\nHowland Wireless Test Lab Module Near-2-Far  Ver: V4.0\n');
fprintf(fid,'Date: \n');
fprintf(fid,'Time: \n');
fprintf(fid,'File Name: %s\n', [path fname]);
fprintf(fid,'File Type: Single Frequency\n');

fprintf(fid,'\n');

fprintf(fid,'Calculated Far-Field Pattern\n');
fprintf(fid,'Number of Modes Used in Far-Field calculation: \n');
fprintf(fid,'AUT Minimum Sphere Radius (inch): \n');
fprintf(fid,'Measurement Radius (inch): \n');

fprintf(fid,'\n');

fprintf(fid,'AP Measurement Source File: \n');
fprintf(fid,'Network Analyzer Measurement\n');
fprintf(fid,'Calculation Mode: Calibrated\n');
fprintf(fid,'Calibration Standard Antenna: \n');

fprintf(fid,'__________________\n');

fprintf(fid,'\n');

fprintf(fid,'Device Under Test (DUT): \n');
fprintf(fid,'DUT Test Position: Free Space\n');

fprintf(fid,'\n');

fprintf(fid,'Test Type: Discrete Test\n');
fprintf(fid,'Test Duration: \n');
fprintf(fid,'Test Comments:  \n');

fprintf(fid,'\n');

fprintf(fid,'Axis2 VPOL Antenna: QR1\n');
fprintf(fid,'Axis2 HPOL Antenna: QR1\n');
fprintf(fid,'Axis1 Antenna: Device Under Test\n');

fprintf(fid,'\n');

fprintf(fid,'Axis1 Equipment: \n');
fprintf(fid,'Test Frequency: %7.3f MHz\n', freq/1e6);
fprintf(fid,'Output Level: \n');
fprintf(fid,'Frequency Count: \n');
fprintf(fid,'Start Frequency: %7.3f MHz\n', 0.0);
fprintf(fid,'Stop Frequency: %7.3f MHz\n', 0.0);

fprintf(fid,'\n');

fprintf(fid,'VPOL Equipment: \n');
fprintf(fid,'HPOL Equipment: \n');
fprintf(fid,'Network Analyzer Bandwidth: \n');
fprintf(fid,'Frequency Dwell: \n');

fprintf(fid,'\n');

fprintf(fid,'Axis1 Name: PHI\n');
fprintf(fid,'Axis1 Start Angle: %7.3f Deg\n', 0.0);
fprintf(fid,'Axis1 Stop Angle: %7.3f Deg\n', nPhi-2);
fprintf(fid,'Axis1 Increment: %5.3f Deg\n', 1.0);
fprintf(fid,'Axis1 Speed: %2i Deg/Sec\n', 0);
fprintf(fid,'Axis1 Dwell: %5.3f Sec\n', 0.0);

fprintf(fid,'\n');

fprintf(fid,'Axis2 Name: THETA\n');
fprintf(fid,'Axis2 Start Angle: %7.3f Deg\n', 0.0);
fprintf(fid,'Axis2 Stop Angle: %7.3f Deg\n', nTheta-1);
fprintf(fid,'Axis2 Increment: %5.3f Deg\n', 1.0);
fprintf(fid,'Axis2 Speed: %2i Deg/Sec\n', 0);
fprintf(fid,'Axis2 Dwell: %5.3f Sec\n', 0.0);

fprintf(fid,'\n');

fprintf(fid,'FF Pattern Calculated Directivity: %5.3f dB\n', 0.0);
fprintf(fid,'FF Pattern Calculated Gain: %5.3f dBi\n', gain);

fprintf(fid,'\n');

fprintf(fid,'******* Far-Field Pattern Calculation Results *******\n');
fprintf(fid,'  	  	 H-Pol	 H-Pol	 V-Pol	 V-Pol\n');
fprintf(fid,' THETA	  PHI	  Mag	 Phase	  Mag	 Phase\n');
fprintf(fid,' (deg)	 (deg)	  (dB)	 (deg)	  (dB)	 (deg)\n');
fprintf(fid,'');


for i = 1 : nTheta
    for j = 1 : nPhi-2
        fprintf(fid, ...
            '%7.2f\t%7.2f\t%7.3f\t%7.2f\t%7.3f\t%7.2f\n', ...
            i-1, j-1, ...
            Hmag_dB(i,j), Hpha_deg(i,j), ...
            Vmag_dB(i,j), Vpha_deg(i,j) ...
            );
    end
end
fclose(fid);




