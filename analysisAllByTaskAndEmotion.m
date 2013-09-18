function [taskR	taskNW] = analysisAllByTaskAndEmotion(use)


if nargin < 1
	error('ARGHH')
end 

switch use
	case 1
		fprintf('Computing NWs for plotting\n')
		flagPlot = true;
	otherwise
		fprintf('Computing NWs for analysis\n')
		flagPlot = false;
end


framesPerTrial = 125;
tasks = [2,3,5,6];
nTask = numel(tasks);
% 
emoCodes{1} = 'ANGER';
emoCodes{2} = 'DISGUST';
emoCodes{3} = 'FEAR';
emoCodes{4} = 'HAPPY';
emoCodes{5} = 'NEUTRAL';
emoCodes{6} = 'SAD';
emoCodes{7} = 'SURPRISE';
nEmos = numel(emoCodes);

tStart = tic();
 
% load data
m = load('males');
f = load('females');

% concate
data = [m.data ,f.data];
meta = [m.meta ,f.meta];

% extract and store total no of subjects
nSub = numel(data);

% duplicate AUS if needed
if flagPlot
	for iSub = 1:nSub
		data{iSub} = duplicateAUs(data{iSub});
	end %iSub
end % if flagPlot


fprintf('Data preparation took %3.0f secs\n',toc(tStart))

% alloc cell arary so we can concat

tComp = tic();
% now loop over subs,task and emotions and assemble data
for iTask = 1:nTask

	% alloc R per Task
	for i=1:7,R{i} =[];end

	for iSub = 1:nSub 
		
		% select meta info and data for the subs
		d = data{iSub};
		m = meta{iSub};

		%set current task
		theTask = tasks(iTask);

		%slice task 
		[tempData tempMeta] = getTask(d,m,theTask);
		
		% and get the data split by emotions
		emoData = getAllEmotions(tempData,tempMeta,framesPerTrial);
		
		% loop over emos, compute r's and assemble
		for iEmo = 1:7

			% skip neutral 
			if iEmo == 5,continue,end

			if isempty(emoData{iEmo})
				%fprintf('Skipping sub %d in Task %d Emo %d.\n',iSub,theTask,iEmo)
				continue
			end
			% trial-wise correlation
			for iTrial = 1:size(emoData{iEmo},3)
					r(:,:,iTrial) = eeg_corrmat(emoData{iEmo}(:,:,iTrial));
			end %iTrial
		
			% assemble
			R{iEmo} = cat(3,R{iEmo},mean(r,3));

		end % iEmo

		% assing R, which is avg<r> per emotion for all sub
		taskR{theTask} = R;

	end %iTask

	fprintf('.')

end %iSub 




fprintf('Done.\nCorrelation estimation took %3.0f. Total runtime %3.0f secs\n',toc(tComp),toc(tStart))

% estimate threshold
thresh = estTresh(taskR)
% threshold = .5; 
% fprintf('ATT: USING FIXED THRESHOLD %d FOR ALL TASK/EMOS\n',threshold);
% thresh(1:7) = threshold;

tNW = tic();
% run over tasks and compute
for iTask = 1:nTask

	%set current task
	theTask = tasks(iTask);

	% go over all emotions
	for iEmo = 1:nEmos

		% skip in nothing is found
		if isempty(taskR{theTask}{iEmo})
			fprintf('Skipping %s (%d) in task %d\n',emoCodes{iEmo},iEmo,theTask);
			continue
		end
		
		fprintf('Using %f as threshold in task %d  emo %d \n',thresh(theTask,iEmo),theTask,iEmo);
		nw{iEmo} = corr2nw(taskR{theTask}{iEmo},thresh(theTask,iEmo));
	
	end %iEmo	

	taskNW{theTask} = nw;

end % iTask
% toc

fprintf('Done.\nNW estimation took %3.0f. Total runtime %3.0f secs\n',toc(tNW),toc(tStart))


% get the joint histogramms in order to have a benchmark 
% for the NW threshold
function thresh = estTresh(R)

% R is a cell array of cell arrays
% such that R{1}{2} contains the data of
% task 1 emotion 2. The actual data is 
% a set of  NxN correlation matrixes 

iPlot = 1;
% all possible tasks
tasks= 1:numel(R);

%reduced to acutally existing task
tasks = tasks(cellfun(@(x) ~isempty(x), R));

% empty return 
thresh =[];

% estimates threshold and plot
for iTask = tasks
	for iEmo = 1:7

		data = R{iTask}{iEmo}(:);
		thresh(iTask,iEmo) = prctile(abs(data(:)),90);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
	%%%%
	%%%% SPLIT BY EMOTION AS WELL
	%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%		subplot(4,1,iPlot);
%		hist(data(:),100);
%		thresh(iTask) = prctile(abs(data(:)),90);
%		xlim([-1 1])
%		title(sprintf('Estimated threshold is %0.3f',thresh(iTask)))
%		iPlot = iPlot+1;
		
		
	end %iEmo
end %iTask

function nw = corr2nw(r,thresh)

% threshold a correlation matrix 
% to yield a network 
%
% We work on the absolute correlation 
% and in case or multiple realisations/trials
% we return a set of those

% alloc empty output of same size
% w/ minimal memory print
nw = uint8( zeros(size(r)) );

% insteado of looping over trials
% we use logical indexing
idxLink = abs(r) > thresh;

% fill links and return
nw(idxLink) =1;
