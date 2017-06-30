function [ success ] = nsiPlot3D( freq, dataPath, Totgain, CPgain, XPgain )
%NSIPLOT3D Summary of this function goes here
%   Detailed explanation goes here

success = false;

numbeam1 = size(freq,1);
for i=1:numbeam1

    freq_MHz = freq(i)./10^6;
   
   
   % plot Power Sum
   title = ['Power Sum 3D Pattern at ' num2str(freq_MHz) ' MHz'];
   [figPowerSum] = plot3D( title, freq(i), Totgain(:,:,i) );
   
    fname = ['3D_PowerSum' num2str(freq_MHz) '_MHz'];
    Plot2File( figPowerSum, dataPath, fname );

   %plot  CoPol
   title = ['CoPol 3D Pattern at ' num2str(freq_MHz) ' MHz'];
   [figCoPol] = plot3D( title, freq(i), CPgain(:,:,i) );
   
    fname = ['3D_CoPol' num2str(freq_MHz) '_MHz'];
    Plot2File( figCoPol, dataPath, fname );
   
   %plot Xpol
   title = ['XPol 3D Pattern at ' num2str(freq_MHz) ' MHz'];
   [figXPol] = plot3D( title, freq(i), XPgain(:,:,i) );
   
    fname = ['3D_XPol' num2str(freq_MHz) '_MHz'];
    Plot2File( figXPol, dataPath, fname );

end

success = true;



    
   
