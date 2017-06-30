nsi_post
    Post processing matlab routines for NSI antenna data
	
	History
	   August 4, 2010	Modified for modularity enabling reuse and data encapsulation DCW

The current directory contains matlab routines for post processing NSI antenna data files generated with MLDump.macro9

Required files:
   nsi_post_dcw.m		Main driver routine
   nsiConstants.m		Routine to define commonly used constants and data spacing
   nsiReadData.m		Routine to read RAW files dumped with the NSI software using MLDump.macro9
   nsiReadEfficiencyFile.m	Routine to read the efficiency calibration file
   nsiReadFrequencyFile.m	Routine to read the file containing the measured frequencies
	  
