function fixstext
%FIXSTEXT Reposition styled text objects after axes modification.
% FIXSTEXT repositions all styled text objects in the current figure.
%
% See also STEXT, SXLABEL, SYLABEL, SZLABEL, STITLE, DELSTEXT,
% PRINTSTO, SETSTEXT.

% Requires function MOVE1STO.
% Requires MATLAB Version 4.2 or greater.

% Version 2.1, 8 September 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz
% schwarz@kodak.com

% Determine current figure and axes.
fig = get(0,'CurrentFigure');
ax = get(fig,'CurrentAxes');

% Find all stext objects.
anchors = findobj(fig,'Tag','stext');
n = length(anchors);

% Adjust each stext object.
for i = 1:n
	move1sto(anchors(i))
end

% Adjust title.
stitleH = findobj(fig,'Tag','stext title');
n = length(stitleH);
for i = 1:n
	move1sto(stitleH(i))
end

% Fix all styled text labels by regenerating them.
xlabelH = findobj(fig,'Tag','stext xlabel');
n = length(xlabelH);
for i = 1:n
	axes(get(xlabelH(i),'Parent'))
	str = get(xlabelH(i),'String');
	sxlabel(str)
end

ylabelH = findobj(fig,'Tag','stext ylabel');
n = length(ylabelH);
for i = 1:n
	axes(get(ylabelH(i),'Parent'))
	str = get(ylabelH(i),'String');
	sylabel(str)
end

zlabelH = findobj(fig,'Tag','stext zlabel');
n = length(zlabelH);
for i = 1:n
	axes(get(zlabelH(i),'Parent'))
	str = get(zlabelH(i),'String');
	szlabel(str)
end

% Return to original current axes.
set(fig,'CurrentAxes',ax)
