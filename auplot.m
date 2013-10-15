function auplot(varargin)

% AUPLOT - SCROLLPLOT OF ACTION UNITS
%
% auplot - function (AU[,timeScale,labels])
%
% Show a scrollplot of the activation of the facial
% action units analog to an EEG scroll plot.
% The data AU is adjusted to normalized and plotted.
% The maxima are highlighted in the plot. By convention
% time is discreet unless provide in TIMESCALE.ed.
% If the LABELS of the action units are provided,
% those are shown instead of indices.
%
% If the AU data is a set of trials, the figure 
% allows the change from one trial to the next. 
%
%
% Input:
%
%	AU = AU data (continous or trialwise)
%
% Parameters:
%
%	timeScale = timeScale against which to plot 
%	labels = AU labels
%
% requires: 
%
% see also: CERTool

% debug settings

debug = 1;
if debug;warning('on','all');else warning('off','all');end
%% check number of input arguments
error(nargchk(1,4,nargin))
%% check number of out arguments
error(nargoutchk(0,0,nargout))

varargin{4} = [];
if ndims(varargin{1}) > 3; 
	help(mfilename)
	error('CERTool:auplot:dataShapeError','Need AU data in [channel x time( x trial) shape]');
else 
	AU = varargin{1};
end
% time table and lables are discreet by default
if isempty(varargin{2}), timeScale = 1:size(AU,2); else timeScale = varargin{2};end
if isempty(varargin{3}), labels = 1:size(AU,1); else labels = varargin{3};end

% load the layout defined in private/layoutAUplot.m
layoutAUPlot;

%get params & store in userdata
data.au = AU;
data.timeScale = timeScale;
data.labels = labels;
data.currentTrial = 1;	
nChan = size(data.au,1); 	data.nChan = nChan;
nTrial = size(data.au,3);	data.nTrial = nTrial;

%make alternating patches from [-1 1]
upperBound =  repmat(1,1,length(timeScale));
lowerBound =  repmat(-1,1,length(timeScale));

% handles for patches
hPatches = [];
for i=1:2:nChan

	hPatches(end+1) = fill(	[timeScale fliplr(timeScale)],...
 							[( upperBound + i*2 )  ( lowerBound + i*2 )],...
							[.7 .7 .7],...
							'edgecolor','white');  
end			

%fancy up stuff
set(hAxes,'Ylim',[1 2*nChan+1])
set(hAxes,'Ticklength',[0 0])
set(hAxes,'YTick',[2:2: 2*nChan])
set(hAxes,'YTickl',labels)

%store in data in GUI
set(hFig,'UserData',data);

%plot initial trial
plotEpoch(hFig,1);

% associate callbacks
set(buttonNext,'Callback',{@changeTrial,1})
set(buttonPrevious,'Callback',{@changeTrial,-1})
set(buttonShowNW,'Callback',{@openNW});

% and show the figure
set(hFig,'visible','on');
	
end % main function

%%% GUI CALLBACKS
function plotEpoch(hFig,trial)
	%
	%	The part that does the actual plotting
	%	It is called on initial run and when 
	%	switching trials

	%acquire userdata from figure 
	data = get(hFig,'UserData');

	% extract data and meta info
	AU = data.au(:,:,trial);
	timeScale = data.timeScale;
	labels = data.labels;
	nChan = data.nChan;

	% next up, we plot the lines and their maxima (peak activation)
	% for that we normalise the data 
	AU = scaleData(AU);

	% aquire value und index of the peaks
	[valPeak idPeak] = max(AU,[],2);

	% if the field data.handlesAU is exists, there are already
	% some lines and we just update the value of these
	% we can also assume that iff handlesAU exist, handlesPeak exist
	% as well. Or not.

	if isfield(data,'handlesAU')
		for iChan = 1:nChan
			% lines
			set(data.handlesAU(iChan),'YData',AU(iChan,:) + iChan*2);
			% peaks
			set(data.handlesPeak(iChan),'YData',valPeak(iChan) + iChan*2,...
				'XData',timeScale(idPeak(iChan)));
		end
	% on the first run we have to call plot, but the store
	% the line handles in handlesAU
	else		
		for iChan = 1:nChan
			% lines
			data.handlesAU(iChan) = plot(timeScale,AU(iChan,:) + iChan*2,'k');
			%peaks
			data.handlesPeak(iChan) = plot(timeScale(idPeak(iChan)),valPeak(iChan) + iChan*2,...
			'MarkerSize',10,'Marker','*','Color','k');
		end
	end

	% set the string for iTrail of nTrial
	set(findobj(hFig,'Tag','textCurrent'),...
		'String', sprintf('Trial %d of %d',trial,data.nTrial) )

	% ensure that the x-axis is limited to the time scale
	set(gca,'XLim',[data.timeScale(1) data.timeScale(end)] );

	% and store everthing in userdata
	set(gcf,'UserData',data);


end %plotEpoch


function changeTrial(source,eventdata,step)

	hFig = get(source,'Parent');

	data = get(hFig,'Userdata');
	theTrial = data.currentTrial + step;

	if 0 < theTrial & theTrial <= data.nTrial
		plotEpoch(hFig,theTrial);
		data.currentTrial = theTrial;
		set(findobj(hFig,'Tag','textCurrent'),'String',...
			sprintf('Trial %d of %d',theTrial,data.nTrial));
		set(hFig,'UserData',data);
	else
		disp('Already at end/beginning of trials');
		return
	end

end % function changeTrial

function selectEmo(source,eventdata)

	% get the selected emotions 
	emo = get(source,'Value');

	% set up the AUs relevant for e  ach expressino
	idx{1} = []; 			%	 neutral face, none 
	idx{2} = [3 4 6 17]; 		% Anger : AU 4,5, 7 and 23
	idx{3} = [3 7 8 9 14 15]; 	% Disgust: 4,9,10,15,17
	idx{4} = [1 2 3 4 20 16]; 	% Fear: `1,2,4,5,20,26
	idx{5} = [5 10 11 ]; 		% Happiness: 6,12
	idx{6} = [1 3 14];			% Sadness: 1,4,15
	idx{7} = [1 2 4 20];		% Surpriese: 1,2,5,26
	%acquire userdata from figure 
	hFig = get(source,'Parent');
	data = get(hFig,'UserData');
	% if we have something plotted
	if isfield(data,'handlesAU')

		% black lines and marker for all AUs first
		set(data.handlesAU,'Color','k');
		set(data.handlesPeak,'Color','k')

		% then highlight relevant ones
		set(data.handlesAU(idx{emo}),'Color','r');
		set(data.handlesPeak(idx{emo}),'Color','r')

	end %if isfield

end %function selectEmo

function y = scaleData(x,z)
	% scale the date from [-1 1]
	% see ERRP for details
	if nargin < 2, z = .5;end
	y  = (x./( (z) - ( - (z) )) .*  (1 - (-1) ))   + (-1);
	y =  y - repmat(mean(y,2),1,size(y,2)); 

end %function scaleData


function openNW(source,eventdata)

	hFig = get(source,'Parent');
	data = get(hFig,'Userdata');

	r = corrmat(data.au(:,:,data.currentTrial));
	figure;
	plotOnFace(r,1,1);
	

end %opneNW