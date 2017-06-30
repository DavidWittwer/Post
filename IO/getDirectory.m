function [ dataPath ] = getDirectory(uiText, dataDir)

% Process optional passed arguements
if( exist('dataDir', 'var') )
    dataPath = dataDir;
end

% Prompt user for data directory
dirStr = uigetdir(pwd,uiText);

% Test for non-empty response
if(~isempty(dirStr)) 
    dataPath = dirStr;
    %cd(dataDir);
else
    dataPath = dataDir; 
end

disp(sprintf('%s set to %s',uiText,dataPath));

return
