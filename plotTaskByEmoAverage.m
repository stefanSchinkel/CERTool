%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%											%%%
%%% 	%analysisAllByTaskAndEmotion()		%%%
%%%											%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% all possible tasks reduced to those
% acutally have some data
tasks= 1:numel(NW);
tasks = tasks(cellfun(@(x) ~isempty(x), NW));

% loop over task and emo and make 
% a nice plot for each task
for iTask = tasks
	
	clf;

	for iEmo = 1:nEmos
		% set subplot
		subplot(2,4,iEmo)

		% slice data and plot
		data = uint8( NW{iTask}{iEmo} );
		if isempty(data)
			X  = zeros(30,30);
			X2 = zeros(30,30);
		else
			X  = uint8( mean(data,3));
			X2 = uint8( mean(NW2{iTask}{iEmo},3));

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
	title(sprintf('Emotion\n phi/<D>/<DC>/<PL>',	'FontWeight','bold')
	ttitle = suptitle(sprintf('TASK %d (Average)',iTask));
	set(ttitle,'FontWeight','bold','FontSize',15);

	fname = sprintf('results/averageTask%d.png',iTask);
	saveas(gcf,fname,'png')
end 
%iTask 