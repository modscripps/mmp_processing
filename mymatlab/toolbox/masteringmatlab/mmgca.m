function Ha=mmgca
%MMGCA Get Current Axes if it Exists.
% MMGCA returns the handle of the current axes if it exists.
% If no current axes exists, MMGCA returns an empty handle.
%
% Note that the function GCA is different. It creates a figure
% and an axes and returns the axes handle if it does not exist.

% B.R. Littlefield, University of Maine, Orono, ME, 04469
% 4/11/95
% Copyright (c) 1996 by Prentice Hall, Inc.

Ha=findobj(0,'Type','axes');
if isempty(Ha)
	return
else
	Ha = get(get(0,'CurrentFigure'),'CurrentAxes');
end
