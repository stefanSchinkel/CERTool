clear 
close all

%% TODO:
% 
%	CHECK FOR SYMMETRIE
%
%
x = [	165 600 300 450 ,... AU2 & AU1
		350 400 200 550 ,... AU4 & AU5
		240 530 165 585 ,... AU7 & AU6
		320 430 310 440 ,... AU9 & AU10
		275 475 320 430 ,... AU12 & AU14
		230 520 375 375 ,... AU20/AU15/AU17
	];
		
y = [	295 295 250 250 ,... 
		285 285 310 310 ,... 
		325 325 440 440 ,...
		475 475 575 575 ,... 
		630 630 650 650 ,... 
		595 595 685 725 ,... 
	];
		
label = {	'AU2R','AU2L','AU1R','AU1L',....
			'AU4R','AU4L','AU5R','AU5L',...
			'AU7R','AU7L','AU6R','AU6L',...
			'AU9R','AU9L','AU10R','AU10L',...
			'AU12R','AU12L','AU14R','AU14L',...
			'AU20R','AU20L','AU15','AU17',...
			}


face = imread('face.png');
imshow(face);
hold on;

% helper lines
h=line([375 375],[0 1000]);set(h,'Color','k');
h=line([0 750],[500 500]);set(h,'Color','k');
for i=1:numel(x); 
	plot(x,y,'o','MarkerSize',10,...
	'MarkerEdgeColor','k',...
	'MarkerFaceColor','k');
	text(x(i)-10,y(i)-10,label{i});
end

