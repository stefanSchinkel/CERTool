function r = corrmat(AU)

%CORRMAT correlation matrix of AU data
%
% r = corrmat(AU)
%
% Compute the all to all correlation matrix of an  
% MxN array of a AU activations where M is the index 
% of the AU and N is sampling time. 
%
% Input:
%	AU -  AU data (MxN Marix)
%
% Output:
%	r - all to all correlation matrix
%
% See also: CERTool
%
r = corrcoef(AU');


