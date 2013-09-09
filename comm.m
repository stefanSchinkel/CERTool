clear
close all
% some parameters we already know
emoCodes{1} = 'ANGER';
emoCodes{2} = 'DISGUST';
emoCodes{3} = 'FEAR';
emoCodes{4} = 'HAPPY';
emoCodes{5} = 'NEUTRAL';
emoCodes{6} = 'SAD';
emoCodes{7} = 'SURPRISE';

% load face template dat
template = load('private/face.mat');


%load data
[data meta] = importData('tmp.txt');

% duplicate data channels
data = splitAUs(data);

% extract a task
task = getTask(data,meta,2);

% choose one emotion 
for iEmo = [1:4 6 7];

	% compute correlation for all trials
	for iTrial = 1:size(task{iEmo},3)
		r(:,:,iTrial) = eeg_corrmat(task{iEmo}(:,:,iTrial));
	end
	
	% and comupute average of correlation matrices
	r = mean(r,3);

	% construct a network w/ a given treshold
	thresh = .6;

	% alloc nw
	nw = zeros(30);
	nw(find(abs(r > thresh))) = 1;      


	% get data for plottig
	[gx,gy] = gplot(nw,[template.x,template.y]);

	
	% clear fig
	clf
	
	% render face and overlay
	imshow(template.face);
	hold on;
	hLinks = plot(gx,gy,'-k','LineWidth',.5);
	hNodes = plot(	template.x,template.y,'ok',...
					'MarkerFaceColor','k','MarkerSize',5);

	text(300,125,emoCodes{iEmo},'FontSize',20,'FontWeight','bold')

	saveas(gcf,sprintf('results/emo%02d-%s.png',iEmo,emoCodes{iEmo}),'png');
end

% deletion of dupicataes
% not working yet
%{idx = reshape(repmat(1:7,2,1),1,14)
idx2 = idx+ 1      
delId = [ 	1 2; 2 1;
		  	3 4; 4 3;
		]'	

%}
%% sample NW
%rs = sampleCorrMats(data,meta,3);
%close all
%eps = 	.7;
%
%for iEmo = 1:7
%	nw = zeros(25);
% 	nw(find(abs(rs{iEmo} > eps))) = 1;      
% 	pcolor(nw)
% 	uiwait(gcf)
%end
%
%


