function [data meta] = getTask(data,meta,task)

%  GETTASK - extract data of one task
%
% [data meta] = getTask(data,meta,task)
%
% This function extract a given task from DATA and 
% META supplied, both of which are form importCERT. 
% The TASK should be a integer.
%
% Input:
%	data - AU data
%	meta - meta information
%	task - integer denoting task
%
% Output:
%	data - same as input for selected task
%	meta - same as input for selected task
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

if nargin < 3
	help(mfilename)
end;

% select task 
idTask = find(meta.task == task);

% and reduce data and meta
% we can ignore
data = data(:,idTask);
meta.trial = meta.trial(idTask);
meta.emotion = meta.emotion(idTask);
meta.task = meta.task(idTask);
