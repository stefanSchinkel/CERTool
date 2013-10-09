function plotOnFace(nw,flagNodes,flagLabel)

% PLOTONFACE - plot network on face 

% plotOnFace(nw,flagNodes,flagLabel)
%
% This function plots the network NW of activations units on a dummy
% head. The flags for nodes and labels determine if those should
% be added to the plot. 
%
% Input:
%	nw - a network (30x30,unweighted)
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

if nargin < 2
	flagNodes = false;
	flagLabel = false;
elseif nargin < 3
	flagLabel = false;
end


% load template data
template = load('private/face.mat');

% clean redundnat links in NW
nw(1,2) = 0;  nw(2,1) = 0;
nw(3,4) = 0;  nw(4,3) = 0;
nw(5,6) = 0;  nw(6,5) = 0;
nw(7,8) = 0;  nw(8,7) = 0;
nw(9,10) = 0; nw(10,9) = 0;
nw(11,12) = 0; nw(12,11) = 0;
nw(13,14) = 0; nw(14,13) = 0;
nw(21,22) = 0; nw(22,21) = 0;
nw(24,25) = 0; nw(25,24) = 0;

% idx = [1:2:14,2:2:14;2:2:14,1:2:14]';
% for iIdx = 1:size(idx,2)
% 	nw(idx(1,iIdx),idx(2,iIdx)) = 0;
% end

% use gplot to get coordinates
[gx gy] = gplot(nw,[template.x template.y]);
	
% clear fig
cla
	
% render face and hold for overlaying
imshow(template.face);
hold on;

%plot links and nodes
hLinks = plot(gx,gy,'-k','LineWidth',.5);
if flagNodes
	hNodes = plot(	template.x,template.y,'ok',...
					'MarkerFaceColor','k','MarkerSize',3);
end

% add labels if wanted
if flagLabel
	text(template.x,template.y,template.label,'FontSize',6)
end

%text(300,125,emoCodes{iEmo},'FontSize',20,'FontWeight','bold')

