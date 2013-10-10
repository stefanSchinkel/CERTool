% CERTool - Tools to work with CERT data
%
%
% CERTtool
% |
% +-- R 				% R functions
% |	|-- batchConvert.R 		% sample wrapper for batch processing 
% |	|-- convert.R			% function for annote CERT output w/ fixed coding
% |
% +-- doc
% |	|-- documentation		% General Documentation
% |	|-- CERTspecs.pdf		% PDF describing the CERT/AFECT System
% |
% +-- functions
% |	|-- constructDummy.m		% dummy head and coordinates for plotting
% |	|-- constructTemplates.		% read theoretical networks from private/templates
% |	|-- duplicateAUs.m 		% clone the AUs recorded once but plotted twice
% |	|-- getTask.m 			% extract one task from data
% |	|-- getEmotion.m		% extract one emotion from data
% |	|-- getAllEmotions.m		% extract ALL emotions from data
% |	|-- importCERT.m		% import annoted CERT data ( output of R/convert.R)
% |	|-- plotOnFace.m		% plot NW on a face
% |
% +--	private
% |	|-- face.mat
% |	|-- face.png 			% image source for dummy head
% |	+-- templates			% templates for emotions in ASCII files
% |		|-- Anger.txt
% |		|-- Distgust.txt
% |		|-- Fear.txt
% |		|-- Happy.txt
% |		|-- Sad.txt
% |		|-- Surprise.txt
% |
% |-- Contents.m 			% General Help file
