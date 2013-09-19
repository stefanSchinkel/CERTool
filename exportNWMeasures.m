%[R NW] = analysisAllByTaskAndEmotion(2);	% for numbers

function exportNWMeasures(NW);

if nargin < 1
	error('ARRGHHH!')
end
% load from files
m = load('males.mat','dataFiles');
f = load('females.mat','dataFiles');

% join 
subjectCodes = [m.dataFiles f.dataFiles];

%  generic parameters
emoCodes{1} = 'ANGER';
emoCodes{2} = 'DISGUST';
emoCodes{3} = 'FEAR';
emoCodes{4} = 'HAPPY';
emoCodes{5} = 'NEUTRAL';
emoCodes{6} = 'SAD';
emoCodes{7} = 'SURPRISE';
nEmos = numel(emoCodes);

% all possible tasks reduced to those
% acutally have some data
tasks= 1:numel(NW);
tasks = tasks(cellfun(@(x) ~isempty(x), NW));

% open file for writing
fid = fopen('results/export.cvs','w');
fprintf(fid,'subject;task;emotion;density;average degree; distance centrality; average path length\n');
% loop over task and emo and make 
% a nice plot for each task

for iSub = 1:numel(subjectCodes)

	% get current subject
	subjectString = subjectCodes{iSub}(end-8:end-4);
	
	for iTask = tasks
		
		for iEmo = 1:nEmos

			% slice data if available, or fill
			% the resultin measures w/ NaNs
			try
				X = uint8( NW{iTask}{iEmo}(:,:,iSub));

				% get density and other NW measures
				phi = sum(X(:)) / ( size(X,1) * (size(X,1)-1) );
				[ni d dc] = nwstats(X);
				apl = avgpl(X);

			catch
				phi = NaN;
				d 	= NaN;
				dc 	= NaN;
				apl = NaN;
			end % try

			% the meta info
			fprintf(fid,'%s;%d;%d;',subjectString,iTask,iEmo);
			% the values
			fprintf(fid,'%0.3f;%0.3f;%.03f;%0.3f\n',phi,mean(d),mean(dc),apl);

		end %iSub

	end %iEmo	

end %iSub

fclose(fid);