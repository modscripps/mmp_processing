function [cs,h]=mmcont2(arg1,arg2,arg3,arg4,arg5)
%MMCONT2 2-D Contour Plot Using a Colormap.
% MMCONT2(X,Y,Z,N,C) plots N contours of Z in 2-D using the color
% specified in C. C can be a linestyle and color as used in plot,
% e.g., 'r-', or C can be the string name of a colormap. X and Y
% define the axis limits.
% If not given, default argument values are: N = 10, C = 'hot',
% X and Y = row and column indices of Z. Examples:
% MMCONT2(Z)			10 lines with hot colormap
% MMCONT2(Z,20)			20 lines with hot colormap
% MMCONT2(Z,'copper')	10 lines with copper colormap
% MMCONT2(Z,20,'gray')	20 lines with gray colormap
% MMCONT2(X,Y,Z,'jet')	10 lines with jet colormap
% MMCONT2(Z,'c--')		10 dashed lines in cyan
% MMCONT2(X,Y,Z,25,'pink')	25 lines in pink colormap
% 
% CS=MMCONT2(...) returns the contour matrix CS as described in CONTOURC.
% [CS,H]=MMCONT2(...) returns a column vector H of handles to line objects.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 4/17/95
% Copyright (c) 1996 by Prentice Hall, Inc.

n=10;	c='hot';	% default values
nargs=nargin;	cflag=1;	

if nargin<1,error('Not enough input arguments.'),end

for i=2:nargin	% check input arguments for N and C
	argi=eval(sprintf('arg%.0f',i));
	if ~isstr(argi)&length(argi)==1  % must be N, grab it
		n=argi;
		nargs=i;  % # args to pass to contour2
	elseif isstr(argi)  % must be C
		if exist(argi)==2	% is colormap, so grab it
			c=argi;
			nargs=i-1;
		else				% is single color/linestyle
			cflag=0;
			nargs=i;
		end
	end
end
if cflag  % a colormap has been chosen
	clf			% clear figure
	view(2)		% make it 2-D
	hold on		% hold it
	mapstr=sprintf([c '(%.0f)'],n);
	set(gca,'ColorOrder',eval(mapstr));
end
evalstr='[CS,H]=contour(';
for i=1:nargs
	evalstr=[evalstr sprintf('arg%.0f',i) ','];
end
lstr=length(evalstr);
evalstr(lstr:lstr+1)=');';
eval(evalstr)
hold off
if nargout==1,		cs=CS;
elseif nargout==2,	cs=CS;h=H;
end

		
