%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%											%%%
%%% 	%analysisAllByTaskAndEmotion()		%%%
%%%											%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% all possible tasks reduced to those
% acutally have some data
tasks= 1:numel(NW);
tasks = tasks(cellfun(@(x) ~isempty(x), NW));

% loop over subset of subject (5male/5female)

subs = [1:5 49:53];

% load files names, which hold 
% the subcodings as well

% load from files
m = load('males.mat','dataFiles');
f = load('females.mat','dataFiles');

% join 
subjectCodes = [m.dataFiles f.dataFiles];

% and subset
subjectCodes = subjectCodes(subs);


%loop over subjects

for iSub = 1:numel(subs)

	subjectString = subjectCodes{iSub}(end-8:end-4);

	% loop over task and emo and make 
	% a nice plot for each task
	for iTask = tasks
		clf 

		for iEmo = 1:nEmos
			% set subplot
			subplot(2,4,iEmo)

			% slice data and plot
			data = uint8( NW{iTask}{iEmo} );
			if isempty(data)
				X = zeros(30,30);
				X2 = zeros(30,30);
			else
				X = data(:,:,iSub);
				X2 = uint8( NW2{iTask}{iEmo}(:,:,iSub));
			end % if isempty
			
			% render data on face
			plotOnFace(X,1);

			% get densitiy of other NW2
			phi = sum(X2(:)) / ( size(X2,1) * (size(X2,1)-1) );
			[ni d dc] = nwstats(X2);
			apl = avgpl(X2);

			title(sprintf('%s\n %.3f/%.3f/%.3f/%.3f',emoCodes{iEmo},phi,mean(d),mean(dc),apl),...
			'FontWeight','bold')

		end %iEmo	

		subplot(2,4,8)
		plotOnFace(zeros(30,30),1)
		title(sprintf('Emotion\n phi/<D>/<DC>/<PL>'),'FontWeight','bold')
		ttitle = suptitle(sprintf('TASK %d (%s)',iTask,subjectString));
		set(ttitle,'FontWeight','bold','FontSize',15);


		% save images
		fName = sprintf('results/%s-Task%dEmo%d-%s.png',subjectString,iTask);
		saveas(1,fName,'png')

	end %iTask 

end %iSub