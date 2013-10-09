function x = getEmotion(data,meta,emotion,framesPerTrial)

%  GETEMOTION - extract data of one emotion
%
% [data meta] = getEmotion(data,meta,emotion,[framesPerTrial])
%
% This function extracts the AU activation for given emotion (INT) an returns  
% an NxMxP matrix where N is the number of AUs M is the number for frames 
% per trial and P is the number of trials found. The DATA and META inputs
% are taken from importCERT and the numeric codes for emotions are:
%
%	1 =  'ANGER';
%	2 =  'DISGUST';
%	3 =  'FEAR';
%	4 =  'HAPPY';
%	5 =  'NEUTRAL';
%	6 =  'SAD';
%	7 =  'SURPRISE';
%
% Input:
%	data - from importCERT
%	meta - from importCERT
%	emotion - numeric code for the emotions
%	framesPerTrial - no of frames in one trial (def: 125)
%
% Output:
%	x - one emotion in all trials (AU x Frame x trial)
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

flagDebug = true;

if nargin < 3 
	help(mfilename)
end
if nargin < 4
	framesPerTrial = 125;
	fprintf('Assuming default frames rate (%d per Trial) \n',framesPerTrial)
end

% find proper emotions
idEmo = find(meta.emotion == emotion);

% the number of trial in % each emotion
nTrials = numel(idEmo) / framesPerTrial

% alloc output
x = [];

% if no trials, we continue
if nTrials == 0
	fprintf('No trials found!\n');
	return
end


	% slice out data
	t =  data(:,idEmo);

	% first trial
	x = t(:,1:framesPerTrial);
	
	if nTrials > 1
		for iTrial = 2:nTrials
			trialStart = (iTrial-1)*framesPerTrial+1;
			trialEnd = iTrial*framesPerTrial;
			x = cat(3,x,t(:,trialStart:trialEnd));
		end
	end


% out = {};
% for iEmo = 1:nEmos
	
% 	%fprintf('Emotion %d (%s) has %d trails\n', iEmo,iEmo},nTrials(iEmo));

% 	% if no trials, we continue
% 	if nTrials(iEmo) == 0
% 		continue
% 	end


% 	% slice out data
% 	t =  data(:,idEmo{iEmo});

% 	% first trial
% 	x = t(:,1:framesPerTrail);
	
% 	if nTrials(iEmo) > 1
% 		for iTrial = 2:nTrials(iEmo)
% 			trialStart = (iTrial-1)*framesPerTrail+1;
% 			trialEnd = iTrial*framesPerTrail;
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
%	title(sprintf('Task %d: %s avg. of %d trials',task,iEmo},nTrials(iEmo)))
%	caxis([-1 1])
%	colorbar
%
%	subplotCount = subplotCount+1;
%
