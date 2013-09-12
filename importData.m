%IMPORTDATA - read CERT data (prepared using convert.R)
%
% function [data meta] = importData(file)
%
% Read the activation of facial action units (AU) as derived
% from the CERT coding software. In those files There
% from Brain Vision Marker File and return it to the caller.
% Needed to provide a mean of epochising continous EEG data.
%
% Input:
%	file = textfile with relevant data 
%
% Output:
%	data = activation of AUs
%	meta = codings of trial/task/etc
%
% requires: 
%
% see also: 
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

function [data meta] =importData(fileName)

flagDebug = false;

if nargin < 1
	fileName = 'data/dat_all_21001.txt';
	fprintf('WARNING: Reading sample data\n');
end


% open file
fid = fopen(fileName);
if fid == -1
	error('FACE:importData','Couldn''t read data file')
end

% try to get the number of lines 
% to preallocate memory
totalLines = getTotalLines(fileName);
if totalLines > 0
	% wc also read the headerline
	% which we have to neglect
	totalLines = totalLines-1;
	data =  zeros(21,totalLines);
	meta.task 	= int32(zeros(1,totalLines));
	meta.trial 	= int32(zeros(1,totalLines));
	meta.emotion = int32(zeros(1,totalLines));
end
% read Header
fprintf('Opening file %s\n',fileName)
hdr = fgetl(fid);

tStart = tic;
fprintf('Reading data ')
% make format string
formatString = prepareFormatString(); 

% and a line counter
iLine = 1;

% loop over data
while 1 

	% read in a line
	line = fgetl(fid);

	% break on empty
	if ~ischar(line)
		break
	end	 

	% scan line
	x = textscan(line,formatString);
	try
		% assign values
		data(:,iLine) 	= cell2mat(x(2:22));
	catch 
		data(:,iLine) 	= NaN;
	end

	% filter out NA in Task/Trial/Emo
	if isempty(cell2mat(x(23)))
		meta.task(iLine) 	= NaN;
		meta.trial(iLine) 	= NaN;
		meta.emotion(iLine) = NaN;		
	else
		meta.task(iLine) 	= cell2mat(x(23));
		meta.trial(iLine) 	= cell2mat(x(24));	
		meta.emotion(iLine) = cell2mat(x(25));
	end
	
	% increment counter
	iLine = iLine + 1;

    % some progress
    if mod(iLine,500) == 0 
    	fprintf('=')
    end
end
fprintf('> Done \n')

fprintf('Read %d lines in %2.1f sec\n', iLine,toc(tStart))
fclose(fid);


if flagDebug 
	subplot(3,1,1);bar(meta.task);title('Task');axis tight
	subplot(3,1,2);bar(meta.trial);title('trial');axis tight
	subplot(3,1,3);bar(meta.emotion);title('Emo');axis tight
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%		HELPER FUNCTIONS			%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function format = prepareFormatString()
%There are 25 cols for sub & AU and then Task Trial  conditionNumeric, conditionChar
% which is : %s 25*%f 3*%d and %s
format = '%s';
for i=1:21 
	format = [format ' %f '];
end
format = [format ' %d %d %d %s'];

function nLines = getTotalLines(fileName)

% count the number of lines in a text file
% using wc. If system is not unix system, 
% return -1 

if ~isunix(); 
	nLines = -1;
else
	[stat result] = unix(sprintf('wc -l %s',fileName));
	nLines = sscanf(result,'%d *%s');
end
