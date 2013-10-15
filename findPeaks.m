function [valPeak idPeak] = findPeaks(AU)
% FINDPEAKS - find peak activation
%
% [val id] = findPeaks(AU)
%
% Find the peak activation in an MxN array of a AU
% activations where M is the index of the AU and N
% is sampling time. The values and indices are returned of
% the activations are returned (on per AU).
%
% Input:
%	AU -  AU data (MxN Marix)
%
% Output:
%	val - value of peak 
%	id - index of peak 
%
% See also: CERTool
%


[valPeak idPeak] = max(AU,[],2);