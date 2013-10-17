function readRawCERT(filename)

filename = 'doc/sampleCert.txt';

fid = fopen(filename);

%fast forward to actual headers
fgetl(fid); %empty line
fgetl(fid); %Directory: /Users/pinkpant/Documents

str = fgetl(fid); % the acual names

% close file
fclose(fid);

% the number of tabs
% \t is 9 in ASCII
nTabs = numel( find( double(str) == 9) );

% scan into cell array
out = textscan(str,'%s',nTabs+1,'Delimiter','\t');

auStrings = '';
for iAu = 1:numel(out{1})
 	auStrings = [auStrings sprintf('%s|',out{1}{iAu})];
end

%remove trailing |
auStrings = auStrings(1:end-1);
	
% auStrings = [ 'File|',...
% 		'Mouth Imp X|Mouth Imp Y|Left Eye Imp X| Left Eye Imp Y|',...
% 		'Right Eye Imp X|Right Eye Imp Y|Mouth Left Corner Imp X|',...
% 		'Mouth Left Corner Imp Y|Right Eye Nasal Imp X|Right Eye Nasal Imp Y|',...
% 		'Mouth Right Corner Imp X|Mouth Right Corner Imp Y|'...
% 		'Right Eye Temporal Imp X|Right Eye Temporal Imp Y|'...
% 		'Left Eye Temporal Imp X|Left Eye Temporal Imp Y|,'...
% 		'Left Eye Nasal Imp X|Left Eye Nasal Imp Y|',...
% 		'Nose Imp X|Nose Imp Y|Mouth Left Corner X|Mouth Left Corner Y|',...
% 		'Mouth Right Corner X|Mouth Right Corner Y|(AU 1) Inner Brow Raise|,...
%		'(AU 2) Outer Brow Raise|(AU 4) Brow Lower|(AU 5) Eye Widen|(AU 9) Nose Wrinkle|(AU 10) Lip Raise|(AU 12) Lip Corner Pull|(AU 14) Dimpler|(AU 15) Lip Corner Depressor|(AU 17) Chin Raise|(AU 20) Lip stretch|(AU 6) Cheek Raise|(AU 7) Lids Tight|(AU 18) Lip Pucker|(AU 23) Lip Tightener|(AU 24) Lip Presser|(AU 25) Lips Part|(AU 26) Jaw Drop|(AU 28) Lips Suck|(AU 45) Blink/Eye Closure|Fear Brow (1+2+4)|Distress Brow (1, 1+4)|AU 10 Left|AU 12 Left|AU 14 Left|AU 10 Right|AU 12 Right|AU 14 Right|Gender|Glasses|Yaw|Pitch|Roll|Smile Detector|Anger (v3)|Contempt (v3)|Disgust (v3)|Fear (v3)|Joy (v3)|Sad (v3)|Surprise (v3)|Neutral (v3)'];
screenSize = get(0,'Screensize');

figHandle = figure('Name','CERT READER',... 
		'Position',[50,screenSize(4)-650,350,400],... 
		'Color',[.801 .75 .688],... 
		'NumberTitle','off',...
		'Tag','mainFigure',... 
		'WindowStyle','modal',...
		'Visible','on',...
		'Menubar','none');

uicontrol('Style', 'listbox',...
	'Parent',figHandle,...
	'String', auStrings,...
	'Position', [20 20 300 350],...
	'min',1,'max',numel(auStrings),...
	'Callback', @setindices); 

%callbacks
function val = setindices(hObj,event) %
    % Called when user activates popup menu 
    val = get(hObj,'Value')


