function xy=mmgetxy(n)
%MMGETXY Graphical Input Using Mouse.
% XY=MMGETXY(N) gets N points from the current axes at
% points selected with a mouse button press.
% XY=[x,y] matrix having 2 columns and N rows.
% Striking ANY key on the keyboard aborts the process.
% XY=MMGETXY gathers any number of points until a
% key on the keyboard is pressed.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/30/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

if nargin==0,n=1000;end % nobody wants more points!

xy=[];
for i=1:n
	tmp=mmcxy;
	if isempty(tmp)
		return
	else
		xy=[xy;tmp];
	end
end
