function out = getTask(data,meta,task)

if nargin < 3
	error('Well, EF you!')
end;

% some parameters we already know
emoCodes{1} = 'ANGER';
emoCodes{2} = 'DISGUST';
emoCodes{3} = 'FEAR';
emoCodes{4} = 'HAPPY';
emoCodes{5} = 'NEUTRAL';
emoCodes{6} = 'SAD';
emoCodes{7} = 'SURPRISE';

nEmos = numel(emoCodes);

framesPerTrail = 125;

% select task 
idTask = find(meta.task == task);

% and reduce data and meta
% we can ignore
data = data(:,idTask);
meta.trial = meta.trial(idTask);
meta.emotion = meta.emotion(idTask);

% and split by emotion
for iEmo=1:nEmos
	idEmo{iEmo} = find(meta.emotion == iEmo);
end

% and find the number of trial in 
% each emotion
nTrials = cellfun(@numel,idEmo) / framesPerTrail;

for iEmo = 1:nEmos
	fprintf('Emotion %d (%s) has %d trails\n', iEmo,emoCodes{iEmo},nTrials(iEmo));

	% if no trials, we continue
	if nTrials(iEmo) == 0
		continue
	end


	% slice out data
	t =  data(:,idEmo{iEmo});

	% first trial
	x = t(:,1:framesPerTrail);
	
	if nTrials(iEmo) > 1
		for iTrial = 2:nTrials(iEmo)
			trialStart = (iTrial-1)*framesPerTrail+1;
			trialEnd = iTrial*framesPerTrail;
			x = cat(3,x,t(:,trialStart:trialEnd));
		end
	end
	
	
	out{iEmo} = x;
end

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
