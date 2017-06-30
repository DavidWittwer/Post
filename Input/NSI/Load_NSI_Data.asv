function [ freq, CPgain, XPgain, CPphase, XPphase, Totgain, DataPath, constants, Date ] = Load_NSI_Data( path )
%NSIREADBEAMLIST Summary of this function goes here
%   Detailed explanation goes here

% Process optional passed arguements
if( exist('path', 'var') )
    DataPath = path;
else
    DataPath = uigetdir;
end


% Load Data files
cd(DataPath);

% Load pattern files

[ freq, Date ] = nsiReadBeamList( DataPath );

[ S11dBmag ] = nsiReadS11File( DataPath );

%[ CPgain, XPgain ] = nsiReadData( DataPath, freq );
[ CPgain, XPgain, CPphase, XPphase, constants ] = nsiReadAmpPhaData( DataPath, freq );
   
% Compute the total gain
[ Totgain ] = ComputeTotalGain( CPgain, XPgain );

% Compute average power density
[ SavgAUT ] = ComputeAvePowerDensity( freq, Totgain, constants );

% Load the efficiency file data
[ EffpathP1, EffnameP1, Effdata, Effcheck, errflag1 ] = nsiReadEfficiencyFile( DataPath, freq, SavgAUT );

% Load the frequency list file
[ dBi_meas_f, SGH_NWoffset, errflag2 ] = nsiReadFreqeuncyFile( EffpathP1, EffnameP1, freq );

if (errflag1 || errflag2)
    error('ERROR: frequency points for AUT and the Cal Files do NOT match:  EXITING')
end
   

% Perform error checking between dBiCal file and SGH Cal standard
numbeam1 = size(SavgAUT,3);
maxdBitest = ( max( max(Totgain) ) ) + reshape( SGH_NWoffset, [1,1,numbeam1] );
maxdBitest = reshape( maxdBitest, [numbeam1 1 1] ); % remove ; to see max gain values
%above verifies that the values pulled in from dBiCal files are the
%correct Network Offset adjustment values (in dB, measured from SGH Cal standards) 
%which need to be added to the UNnormalized Gain values (IT WORKS!!!!)
   
%put SGH_NW offset values into an N-D array format for addition to
%(uncorrected) CPgain, Xpgain, and totgain values
NWoffset_ND = repmat( reshape(SGH_NWoffset, [1,1,numbeam1]), [constants.FF_nTH constants.FF_nPHI 1] );
   
%Here's where we apply the NW offset to get the correct Terminal Gain
% corrected into dBi values 
CPgain=CPgain + NWoffset_ND;
XPgain=XPgain + NWoffset_ND;
Totgain=Totgain + NWoffset_ND;

