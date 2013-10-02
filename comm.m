clear
close all

% % % generic parameters
emoCodes{1} = 'ANGER';
emoCodes{2} = 'DISGUST';
emoCodes{3} = 'FEAR';
emoCodes{4} = 'HAPPY';
emoCodes{5} = 'NEUTRAL';
emoCodes{6} = 'SAD';
emoCodes{7} = 'SURPRISE';
nEmos = numel(emoCodes);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%	Covert text data from Andrea (O:\\) 	%%%%
%%%%	using R (easier?) 						%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unix('Rscript R/batchConvert.R')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%		Data Importing and Storage as .mat 	%%%%
%%%%		for faster file access				%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic
% dataFiles = findFiles('converted/','male*');
% for iFile = 1:numel(dataFiles)
% 	[data{iFile} meta{iFile}] = importCERT(dataFiles{iFile});
% end
% save males.mat data meta dataFiles
% toc

% tic
% dataFiles = findFiles('converted/','female*');
% for iFile = 1:numel(dataFiles)
% 	[data{iFile} meta{iFile}] = importCERT(dataFiles{iFile});
% end
% save females.mat data meta dataFiles
% toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%		Computation of all correlation  	%%%%
%%%%		matrices and NW w/ auto threhold	%%%%
%%%%											%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[R NW] = analysisAllByTaskAndEmotion(1); 	% for plotting
[R2 NW2] = analysisAllByTaskAndEmotion(2);	% for numbers


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%											%%%%
%%%%		Plot some sample subjects 		  	%%%%
%%%%											%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotTaskByEmoSingle()


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%											%%%%
%%%%		Plot Grand Average		 		  	%%%%
%%%%											%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotTaskByEmoAverage()


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%											%%%%
%%%%		VIDEOS OVER SUBJECTS	 		  	%%%%
%%%%											%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iTask = 2;
	for iEmo = [1 2 3 4 6 7]
		plotVideo(NW,iTask,iEmo);
	end % iEmo
end %iTask

% stores everything to ./results/videos
% has to be converted there (on the MAC!!!!)
% w/ ffmpeg -i $in -sameq $in.mp4
