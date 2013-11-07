function data = CERTReader(fileName,AUs)
% CERTREADER - read CERT export files
%
% function data = CERTReader(file[,AUs])
%
% CERTReader reads the activation of FACS relevant facial action units (AU) 
% encoded and exported using the CERT software package. 
%
% DATA = CERTREADER(FILE) reads the default AUs used by FACS from the
% data file FILE into an 21xN matrix DATA that holds the activation values 
% of each AU. The number of AUs is defined by the FACS system. N is the
% number of samples/video frames in the exported CERT file.
%
% DATA = CERTREADER(FILE,AUS) reads the  AUs specified in the cell arry
% AUS. 
%
% On UNIX-like platforms the memory is pre-allocated which
% helps to speed up reading of long files.
%
% Input:
%	file -  CERT export file 
%	AU -  AUs of interest (cell array of strings)
%
% Output:
%	data - activation of AUs
%
% requires: 
%	-- 
%
% see also: CERTool
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

% debug settings
flagDebug = false;

% I/O check
error(nargchk(1, 2, nargin));

if nargin < 2
	AUs = defaultAUs();
end

% open file for read access, the file handle 
% will be passed to subfunctions
fid = fopen(fileName);
if -1 == fid
	error('CERTool:CERTReader:fileNotFound','Couldn''t open CERT export file');
end

% extract the field  names form the file
fieldNames = getFieldNames(fid);

% find location of FACS relevant AUs
idx = matchFields(AUs,fieldNames);

if flagDebug
	% for debugging, print a summary
	fprintf('ID\tstring \t index\n')
	for iAU = 1:numel(AUs)
		fprintf('%d\t%s\t\t%s\n',idx(iAU),AUs{iAU},fieldNames{idx(iAU)});
	end
end


% try to determine the no of lines in the file
totalLines = getTotalLines(fileName);

% make format string 
formatString = prepareFormatString(numel(fieldNames));

% finally read the data
data = readCert(fid,totalLines,formatString,idx);

% close file
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%		HELPER FUNCTIONS			%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = defaultAUs()

	% default FACS AUs

	% these are the 21 AUs considered in FACS
	% and the strings we look for (already ordered
	% as needed later on)
	x =	{	
		'(AU 1)', '(AU 2)', '(AU 4)', '(AU 5)', '(AU 6)','(AU 7)', '(AU 9)', ...
		'AU 10 R', 'AU 10 L', 'AU 12 R', 'AU 12 L','AU 14 R', 'AU 14 L',...
		'(AU 15)', '(AU 17)', '(AU 20)','(AU 23)', '(AU 24)',  '(AU 25)',  '(AU 26)',  '(AU 28)',... 
		};

function fieldNames = getFieldNames(fid)

	% return the fields CERT

	% rewind file just to be sure
 	fseek(fid,0,-1);

 	%fast forward to actual headers
	fgetl(fid); %empty line
	fgetl(fid); %Directory: /Users/pinkpant/Documents

	% the line containing the the actual field names
	str = fgetl(fid); 

	% fields are tab delimited and the number varies
	% \t is 9 in ASCII
	nTabs = numel( find( double(str) == 9) );

	% scan into fieldnames into cell array
	out = textscan(str,'%s',nTabs+1,'Delimiter','\t');
	fieldNames = out{1};

function idx = matchFields(AUs,fieldNames)

	% find and return the index of AUs of interest 
	% to their actual location in a given CERTfile

	% match the AUs to the fields found in the CERT-File 
	for iAu = 1:numel(AUs)
		idx(iAu) =  strmatch(AUs{iAu},fieldNames);
	end

function format = prepareFormatString(nFields)
	
	% one %s field and nFields-1 %f fields
	format = ['%s',repmat(' %f',1,nFields-1)];

function nLines = getTotalLines(fileName)

	% count the number of lines in a text file
	% using wc. If system is not unix system, 
	% return -1 

	if ~isunix(); 
		nLines = -1;
	else
		[stat result] = unix(sprintf('wc -l %s',fileName));
		nLines = sscanf(result,'%d *%s');
		% decrement by header (3 lines)
		nLines = nLines-3;
	end

function data = readCert(fid,totalLines,formatString,idx)

	if totalLines > 0
		%fprintf('Pre-allocating memory\n');
		data =  zeros(21,totalLines);
	end

	% rewind the file and skip the
	% header data (3 lines)
	fseek(fid,0,-1);
	for i=1:3
		fgetl(fid); 
	end

	fprintf('Reading data ')
	
	% and a line counter
	iLine = 0;
	
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

		% increment counter
		iLine = iLine + 1;

		try
			% assign values
			data(:,iLine) 	= cell2mat(x(idx));
		catch 
			data(:,iLine) 	= NaN;
		end

	    % some progress
	    if mod(iLine,500) == 0,fprintf('=');end

	end

	% close and summary
	fprintf('> Done \n')


	
