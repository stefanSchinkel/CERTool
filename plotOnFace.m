function plotOnFace(nw,flagNodes,flagLabel)

% PLOTONFACE - plot network on face 
%
% plotOnFace(nw[,flagNodes,flagLabel])
%
% This function plots the network NW of activations units on a dummy
% head. The flags for nodes and labels determine if those should
% be added to the plot. 
%
% Input:
%
%	nw - a network (30x30,unweighted)
%
% Parameters:
%
%	flagNodes - flag to determine if nodes should be plotted
%	flagLabel - flag to determine if labels should be added to nodes
%
% Output:
%	--
%
% See also: 
%

% Copyright (C) 2013- Stefan Schinkel, HU Berlin
% http://people.physik.hu-berlin.de/~schinkel/
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 			I/O check					%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%number of arguments
error(nargchk(1,3,nargin))

% input and param check
if nargin < 1
	help(mfilename);
	error('CERTool:plotOnFace:noData','No data supplied');
elseif nargin < 2
	flagNodes = false;
	flagLabel = false;
elseif nargin < 3
	flagLabel = false;
end

% disable the resize warning
warning('Off','Images:initSize:adjustingMag');

% load template data
template = load('private/face.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 			LAYOUT						%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% a new figure that receives focus
hFig = gcf();
clf(hFig);

% render face and hold for overlaying
% we store the handle to access its position later
hIm = imshow(template.face);
hold on;

% nodes and labels an be added here already,will not change
if flagNodes
	plot(template.x,template.y,'ok',...
		'MarkerFaceColor','k','MarkerSize',3);
end
if flagLabel
	text(template.x,template.y,template.label,'FontSize',6)
end

% the copyright notice also can be added here
textCopy= uicontrol('Parent',hFig,...
	'Units', 'normalized', ...
	'Position',[.75 .01 .25 .02],...
	'Style','text',... 
	'Tag', 'textCopy ',...
	'BackgroundColor',[0.8 0.8 0.8],...
	'FontSize',9,...
	'String','CERTool (c) 2013',...
	'ToolTip','people.physik.hu-berlin.de/~schinkel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 			INITIAL RUN					%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% iff we DO NOT  have weighted network/correlation matrix, 
% we simply render the NW and that is it 
if ~any(mod(nw,1))

	plotLinks(hFig,data.nw);
	return

else	
	% we are dealing with a weighted network
	% and have to: 
	% 1) Add slider and 
	% 2) Add title with threshold
	% 3) store data in GUI
	% 4) apply initial threshold 
	% 5) plot NW

	% the position of the axes holding the 
	axPos  = get(get(hIm,'Parent') ,'Position');

	% compute slider positions
	sliderPos = [axPos(1) axPos(2)-axPos(2)/2 axPos(3) axPos(2)/2];

	%define the slider, which is as wide as the image
	hSlider = uicontrol('Parent', hFig,...
		'Style','slider',...
	    'Min',0,'Max',1,'Value',.5,...
		'SliderStep',[0.01 0.1],...
        'Units','normalized',...
        'Position', sliderPos,...
        'Tag','slider',...
        'Callback',{@refreshPlot},...
		'Tooltip','Move the slider to change the threshold.'); 	

	hTitle = uicontrol('Parent',hFig,...
		'Units', 'normalized', ...
		'Position',[.1 .93 .8 .05],...
		'BackgroundColor',[0.8 0.8 0.8],...
		'Style','text',... 
		'String',sprintf('Threshold: %02.3f',get(hSlider,'Value')),...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'FontSize',15,...
		'Tag','hTitle',...
		'HorizontalAlignment','center');


	% if the slider is present, people probably want
	% to play withit 
	data.nw = nw;
	data.x = template.x;	% the node coordinates
	data.y = template.y;	%		-""-

	% store struct
	set(hFig,'Userdata',data);

	% and plot the NW for the initial threshold
	X = corr2nw(nw,get(hSlider,'value'));
	plotLinks(hFig,X);

end % ~any(mod(...))


end % main

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 			subroutines					%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotLinks(hFig,X)

	% PLOTLINKS - plot an NW overlaid on the face
	% All relevant data can be accessed from the
	% USERDATA struct of the figure

	% get data 
	data = get(hFig,'Userdata');
	
	% clean redundant links in NW
	% which are the ones we duplicatied
	nw(1,2) = 0;  nw(2,1) = 0;
	nw(3,4) = 0;  nw(4,3) = 0;
	nw(5,6) = 0;  nw(6,5) = 0;
	nw(7,8) = 0;  nw(8,7) = 0;
	nw(9,10) = 0; nw(10,9) = 0;
	nw(11,12) = 0; nw(12,11) = 0;
	nw(13,14) = 0; nw(14,13) = 0;
	nw(21,22) = 0; nw(22,21) = 0;
	nw(24,25) = 0; nw(25,24) = 0;


	% use gplot to get coordinates
	[gx gy] = gplot(X,[data.x data.y]);

	% clear links already present
	if isfield(data,'hLinks')
		delete(data.hLinks);
	end

	%plot links and update in USERDATA
	data.hLinks = plot(gx,gy,'-k','LineWidth',.5);
	
	% and update in USERDATA
	set(hFig,'UserData',data);

	% enforce update
	drawnow;

end % plotLinks

function refreshPlot(source,eventdata,varargin)

	% aquire figure handle
	hFig = get(source,'Parent');
	
	% and UserData
	data = get(hFig,'UserData');

	% get value from slider (threshold)
	thresh = get(source,'Value');

	% threshold the corr matrix
	X = corr2nw(data.nw,thresh);
	
	% update plot
	plotLinks(hFig,X);

	% set title
	hTitle = findobj(hFig,'Tag','hTitle');
	set(hTitle,'String',...
		sprintf('Threshold: %.3f',thresh));

end % refreshLinks

function nw = corr2nw(r,thresh)

	% threshold a correlation matrix 
	% to yield a network 

	% alloc empty output of same size
	% w/ minimal memory print
	nw = uint8( zeros(size(r)) );

	% insteado of looping over trials
	% we use logical indexing
	idxLink = abs(r) > thresh;

	% fill links and return
	nw(idxLink) =1;

end % corr2nw