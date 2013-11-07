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
% |	|-- sampleCert.txt		% truncated sample CERT output file to check CERTReader
% |
% +--	private
% |	|
% |	|-- layoutAUplot.m 		% layout of the auplotGUI.
% |	|-- face.mat			% templates of coordinates
% |	|-- face.png 			% image source for dummy head
% |	|-- templates.mat		% templates for basic emotions
% |	|
% |	+-- templates			% templates for emotions in ASCII files
% |		|-- Anger.txt
% |		|-- Distgust.txt
% |		|-- Fear.txt
% |		|-- Happy.txt
% |		|-- Sad.txt
% |		|-- Surprise.txt
% |
% | -- Contents.m 			% Contents file
% |
% | -- CERTReader.m 		% Generic importer for CERT data 
% | 
% | -- auplot.m				% scroll plot of AU activations
% | -- constructDummy.m			% dummy head and coordinates for plotting
% | -- constructTemplates.		% read theoretical networks from private/templates
% | -- duplicateAUs.m 			% clone the AUs recorded once but plotted twice
% | -- findPeaks.m			% extract peaks in activation of AUs
% | -- getTask.m 			% extract one task from data
% | -- getEmotion.m			% extract one emotion from data
% | -- getAllEmotions.m			% extract ALL emotions from data
% | -- importCERT.m			% import annoted CERT data ( output of R/convert.R)
% | -- plotOnFace.m			% plot NW on a face
% |
% | ** PROTOTYPE AREA **
% | ** PROTOTYPE AREA **
