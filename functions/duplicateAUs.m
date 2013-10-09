function data = splitAUs(data)

% SPLITAUS - clone AUs from CERT
%
% function data = splitAUs(data)
%
% This function duplicates the data for those AUs
% that are present twice, but for which only one 
% values is recorded. The input data is taken from
% importCERT().
%
% Input:
%	data - 21xN array with activations
% Output:
%	data - 30xN array with activations
%
% See also: importCERT.m
%
%

idx = [ reshape(repmat(1:7,2,1),1,14) 8:13 14 14 15 16 16 17:21];

data = data(idx,:);

