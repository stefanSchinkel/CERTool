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

% Copyright (C) 2013- Stefan Schinkel, HU Berlin
% http://people.physik.hu-berlin.de/~schinkel/
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

idx = [ reshape(repmat(1:7,2,1),1,14) 8:13 14 14 15 16 16 17:21];

data = data(idx,:);

