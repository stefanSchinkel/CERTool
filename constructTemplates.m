function templates = constructEmoTemplates() 

%  CONSTRUCTEMOTEMPLATES - theoretical emotion networks
%
% templates = constructEmoTemplates() 
%
% This function computes a struct templates that holds
% the theoretical networks of jointly activated AUs in the 6
% basic emotions. The templates are provided as .csv files
% in private/templates.
%
% Input:
%	-- 
% Output:
%	templates - a struct with one field for each emotions
%
% See also: plotOnFace
%
% >> In case sth. is messed up run:
% >> cd CERTool
% >> template = constructTemplates;
% >> anger = template.anger
% >> disgust     = template.disgust;
% >> fear       = template. fear;
% >> happy      = template.happy;
% >> neutral 	= zeros(30,30);
% >> sad         = template.sad;
% >> surprise    = template.surprise;
% >> save private/templates.mat anger disgust fear happy neutral sad surprise


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

% ID of those AUs we need to double
idx = [ reshape(repmat(1:7,2,1),1,14) 8:13 14 14 15 16 16 17:21];

p = mfilename('fullpath');% get the current path for searching
tbPath = fileparts(p);
files = findFiles(fullfile(tbPath,'private/templates/'),'*.txt');

for iFile = 1:numel(files)	
	x = importdata(files{iFile});
	x.data(isnan(x.data)) = 0;
	nw =  x.data-eye(size(x.data));

	% just to be save we copy the 1s to the
	% formerly NaN part (now Zeros)
	for i=1:size(nw,1)
		for j = i:size(nw,1)
			if(nw(j,i) == 1)
				nw(i,j) = 1;
			end
		end
	end

	nw = nw(idx,idx);
	
	% extract name of emotions
	[a b c] = fileparts(files{iFile});

	% set field name
	fieldName = lower(b);
	templates.(fieldName) = nw;
	
	if nargout < 1
		plotOnFace(nw,1);
	
		% set as title
		title(sprintf('Theoretical NW for %s',upper(fieldName)));
		% and wait for closing
		fprintf('Close figure to continue ...\n')
		uiwait(gcf)
	
	end
	
end % iFile


