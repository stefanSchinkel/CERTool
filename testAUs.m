function testAUs(testCase)
%
%	TESTAUS - show where the AUs will be plotted
%
% function testAUs(case)
%
% Plot the face wih overlaid markers for AUs.
%
% Input:
%	testCase = decide what to plot (def: 0)
% Output:
%	
% If testCase is 0, the face with labeled AUs
% will be plotted. If testCase > 0,  video w/
% an overlaid dummy network  is recorded and
% stored in faceNetwork.avi
%
%
%
if nargin < 1
	testCase = 0;
end

%% TODO:
% 
%	CHECK FOR SYMMETRIE
%
%
x = [	300 450 165 600 ,... AU1 & AU2
		350 400 200 550 ,... AU4 & AU5
		165 585 255 495 ,... AU6 & AU7
		320 430 310 440 ,... AU9 & AU10
		275 475 200 550 ,... AU12 & AU14
		275 475 375 240 510 ,... AU15 AU17 AU20
		330 360 390 375 420	,... AU23:26,28  
		]';
		
y = [	250 250 295 295 ,... AU1 & AU2
		285 285 310 310 ,... AU4 & AU5
		440 440 325 325 ,... AU6 & AU7
		475 475 575 575 ,... AU9 & AU10
		620 620 600 600 ,... AU12 & AU14
		650 650 730 635 635 ,... AU15 & AU20
		625 625	625 670 625	,...AU23:25,28  
		]';
		
label = {	'AU1R','AU1L','AU2R','AU2L',....
			'AU4R','AU4L','AU5R','AU5L',...
			'AU6R','AU6L','AU7R','AU7L',...
			'AU9R','AU9L','AU10R','AU10L',...
			'AU12R','AU12L','AU14R','AU14L',...
			'AU15R','AU15l','AU17','AU20R','AU20L',...,
			'AU23','AU24','AU25','AU26','AU28',...
			}';


face = imread('face.png');
imshow(face);
hold on;


% helper lines
if testCase == 0
	h=line([375 375],[0 1000]);set(h,'Color','k','LineStyle','--');
	h=line([0 750],[500 500]);set(h,'Color','k','LineStyle','--');
end
for i=1:numel(x); 
	plot(x,y,'o','MarkerSize',10,...
	'MarkerEdgeColor','k',...
	'MarkerFaceColor','k');
	if testCase == 0
		text(x(i)-10,y(i)-10,label{i});
	end
end

%%%%%%%%%%
%
% Make a VIDEO if requested

if testCase > 0
	aviobj = avifile('faceNetwork.avi','fps',5,'quality',100); 
	for i=1:25

		% "random" network
		nNodes = numel(x);
		r = uint8( rand(nNodes,nNodes) * .515) ;
		r = r .*  uint8( ones(size(r)) - eye(size(r)) ) ;



		%get links from gplot
		[gx,gy] = gplot(r,[x y]);

		% delete old an plot new links, hold
		hLinks = plot(gx,gy,'-k','LineWidth',1.5);
		drawnow
		F = getframe(gcf);
		aviobj = addframe(aviobj,F);
		delete(hLinks)

		%pause(.5)
	end
	aviobj = close(aviobj);
end
