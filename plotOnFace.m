function plotOnFace(nw,flagLabel)

% PLOTONFACE - plot network on face 
%
%


if nargin < 2
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
clf
	
% render face and hold for overlaying
imshow(template.face);
hold on;

%plot links and nodes
hLinks = plot(gx,gy,'-k','LineWidth',.5);
hNodes = plot(	template.x,template.y,'ok',...
					'MarkerFaceColor','k','MarkerSize',5);
% add labels if wanted
if flagLabel
	text(template.x,template.y,template.label)
end

%text(300,125,emoCodes{iEmo},'FontSize',20,'FontWeight','bold')

