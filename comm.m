% clear
% close all
% %load data
% [data meta] = importData();

% plot task and make imags
% for iTask = [2 3 6]
% 	close(1)
% 	sampleCorrMats(data,meta,iTask);
% 	saveas(1,sprintf('results/task%d.png',iTask),'png')

% end %iTask	


% sample NW
rs = sampleCorrMats(data,meta,3);
close all
eps = 	.7;

for iEmo = 1:7
	nw = zeros(25);
 	nw(find(abs(rs{iEmo} > eps))) = 1;      
 	pcolor(nw)
 	uiwait(gcf)
end