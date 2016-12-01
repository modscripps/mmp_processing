function openDropPlots(droplist)

% ------------------------------------------------------------ 
%% openDropPlots.m
% this function opens plots that were
% generated when the mmp data was processed.
%
% inputs:
%    droplist		:	list of drops
%
% ------------------------------------------------------------ 

% path 
pathToPlots = '/Users/mmp/Documents/MATLAB/mmp/FLEAT16/figs/pdf/';

% number of drops
ndrops = length(droplist);

% make an open string
openstr = [];
for ii = 1:ndrops
	% open string will work for pdf or png
	openstr = [ openstr pathToPlots num2str(droplist(ii),'%d') '_PL1.* ' ];
end

% open all the plots!
eval(['!open ' openstr])
