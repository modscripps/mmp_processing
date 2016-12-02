function fixstext
%FIXSTEXT Reposition styled text objects after axes modification.
%	FIXSTEXT repositions all styled text objects in the current figure.
%	
%	See also STEXT, SXLABEL, SYLABEL, SZLABEL, STITLE, DELSTEXT,
%	PRINTSTO, SETSTEXT.

%	Requires function MOVE1STO.
%	Requires MATLAB Version 4.2 or greater.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz
%	schwarz@kodak.com

% Determine current figure and axes.
fig = get(0,'CurrentFigure');
figUnits = get(fig,'Units');
set(fig,'Units','points')
figPosPts = get(fig,'Position');
set(fig,'Units',figUnits)
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
	set(fig,'CurrentAxes',get(xlabelH(i),'Parent'))
	str = get(xlabelH(i),'String');
	sxlabel(str)
end

ylabelH = findobj(fig,'Tag','stext ylabel');
n = length(ylabelH);
for i = 1:n
	set(fig,'CurrentAxes',get(ylabelH(i),'Parent'))
	str = get(ylabelH(i),'String');
	sylabel(str)
end

zlabelH = findobj(fig,'Tag','stext zlabel');
n = length(zlabelH);
for i = 1:n
	set(fig,'CurrentAxes',get(zlabelH(i),'Parent'))
	str = get(zlabelH(i),'String');
	szlabel(str)
end


% Find all slegend and stextbox objects.
legends = [findobj(fig,'Tag','slegend');...
		findobj(fig,'Tag','slegend movable')];
nleg = length(legends);

% Shift the legends so they will print correctly.
for i = 1:nleg
	newPos = get(legends(i),'Position');
	origLegPos = newPos;
	userData = get(legends(i),'UserData');
	xy = userData(1:2);
	ref = userData(3:4);
	newPos(1:2) = figPosPts(3:4).*xy - ref.*origLegPos(3:4);
	set(legends(i),'Position',newPos)
end


% Return to original current axes.
set(fig,'CurrentAxes',ax)
