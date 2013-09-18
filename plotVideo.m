function plotVideo(NW,task,emo)

if nargin < 3
	error('BAH!')
end

% generic parameters
emoCodes{1} = 'ANGER';
emoCodes{2} = 'DISGUST';
emoCodes{3} = 'FEAR';
emoCodes{4} = 'HAPPY';
emoCodes{5} = 'NEUTRAL';
emoCodes{6} = 'SAD';
emoCodes{7} = 'SURPRISE';

fileName = sprintf('results/video/task%02dEmo%02d-%s.avi',task,emo,emoCodes{emo})
aviobj = avifile(fileName,'fps',5,'quality',100); 
for iSub = 1:98 
	plotOnFace(NW{2}{1}(:,:,iSub),1,0);
	title(sprintf('Task %d %s (sub%d)',task,emoCodes{emo},iSub),...
		'FontWeight','bold','FontSize',15)
	drawnow
	F = getframe(gcf);
	aviobj = addframe(aviobj,F);
end

aviobj = close(aviobj);

