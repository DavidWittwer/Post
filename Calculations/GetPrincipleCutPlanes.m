function [ azCut, elCut ] = GetPrincipleCutPlanes( gain, iThe, iPhi )
%CREATEPLANETFILES3 Summary of this function goes here
%   Detailed explanation goes here


az_data = gain(iThe,1:end-1)';

% Elevation data
% -- grab the first half of the data @ 0 deg
data1 = gain(:,iPhi);

% -- grab the second half of the data @ 180 deg
iiPhi = mod(iPhi+180,361);
data2 = gain(:,iiPhi);

% Concatenate the two parts, omitting the last point of each half.
% Convert to Planet file scaling
el_data = [ data1(1:end-1); flipud(data2(2:end)) ];
    

azCut = az_data;
elCut = el_data;


