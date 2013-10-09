function [out nTrials] = getAllEmotions(data,meta,framesPerTrial)

%  GETALLEMOTIONS - extract data of ALL emotions
%
% [out nTrials] = getAllEmotions(data,meta,[framesPerTrial])
%
% This function extracts the AU activation data for all 7 emotions form the
% DATA supplied. META holds trial/task/emotion. Both which are supposed to 
% come from importCERT() or getTask().
%
% Input:
%	data - AU activation (see importCERT.m)
%	meta - meta infos (see importCERT.m)
%
% Output:
%	out	- a cell array containing 7 NMP matrices, one for each emotion
%	nTrials  - the number of trials per emotion
%
%
% For the structure of the NMP matrix see getEmotion
%
% See also: importCERT.m, getEmotion.m, getTask.m
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
flagDebug = false;
if nargin < 2
	help(mfilename)
	error('CERT:getAllEmotions','Too few inputs')
end
if nargin < 3
	framesPerTrial = 125;
	fprintf('Assuming default frames rate (%d per Trail)\n',framesPerTrial)
end


% all the emos we know
emoCodes{1} = 'ANGER';
emoCodes{2} = 'DISGUST';
emoCodes{3} = 'FEAR';
emoCodes{4} = 'HAPPY';
emoCodes{5} = 'NEUTRAL';
emoCodes{6} = 'SAD';
emoCodes{7} = 'SURPRISE';

nEmos = numel(emoCodes);

% cell array of indeces split by emotion
for iEmo=1:nEmos
	idEmo{iEmo} = find(meta.emotion == iEmo);
end

% the number of trial in % each emotion
nTrials = cellfun(@numel,idEmo) / framesPerTrial;

% alloc output so that always sth is returned
% even if sth. empty
out = {};
for iEmo = 1:nEmos
	
	if flagDebug
		fprintf('Emotion %d (%s) has %d trials\n', iEmo,emoCodes{iEmo},nTrials(iEmo));
	end
	% if no trials, we continue
	if nTrials(iEmo) == 0
		continue
	end


	% slice out data
	t =  data(:,idEmo{iEmo});

	% first trial
	x = t(:,1:framesPerTrial);
	
	if nTrials(iEmo) > 1
		for iTrial = 2:nTrials(iEmo)
			trialStart = (iTrial-1)*framesPerTrial+1;
			trialEnd = iTrial*framesPerTrial;
			x = cat(3,x,t(:,trialStart:trialEnd));
		end
	end
	
	
	out{iEmo} = x;
end

% out = {};
% for iEmo = 1:nEmos
	
% 	%fprintf('Emotion %d (%s) has %d trails\n', iEmo,emoCodes{iEmo},nTrials(iEmo));

% 	% if no trials, we continue
% 	if nTrials(iEmo) == 0
% 		continue
% 	end


% 	% slice out data
% 	t =  data(:,idEmo{iEmo});

% 	% first trial
% 	x = t(:,1:framesPerTrial);
	
% 	if nTrials(iEmo) > 1
% 		for iTrial = 2:nTrials(iEmo)
% 			trialStart = (iTrial-1)*framesPerTrial+1;
% 			trialEnd = iTrial*framesPerTrial;
% 			x = cat(3,x,t(:,trialStart:trialEnd));
% 		end
% 	end
	
	
% 	out{iEmo} = x;
% end

%	% neutral is not relevant
%	if iEmo == 5
%		continue
%	end
%
%	% if no trials, we continue but increment the counter, 
%	% to all emos are plotted in the  same position
%	if nTrials(iEmo) == 0
%		subplotCount = subplotCount+1;
%		continue
%	end
%

%	figure
%	nSubplots = sum(nTrials > 0);
%	subplotCount = 1;
%	
%	r{iEmo} = eeg_corrmat(x);
%	subplot(3,2,subplotCount);
%	surf(eeg_corrmat(r{iEmo}));
%	view(2);shading flat;
%	xlim([1 25]);ylim([1 25]);
%	title(sprintf('Task %d: %s avg. of %d trials',task,emoCodes{iEmo},nTrials(iEmo)))
%	caxis([-1 1])
%	colorbar
%
%	subplotCount = subplotCount+1;
%
