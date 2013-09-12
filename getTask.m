function [data meta] = getTask(data,meta,task)

%  GETTASK - extract data of one task
%
% [data meta] = getTask(data,meta,task)
%
% This function extract a give task from DATA and 
% META supplied, both of which are form IMPORTDATA. 
% The TASK should be a integer.
%
% Input:
%	data - AU data
%	meta - meta information
%
% Output:
%	data - same as input for selected task
%	meta - same as input for selected task
%
% See also: importData.m
%
%

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
