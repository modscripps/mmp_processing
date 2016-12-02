function printsto(arg1,arg2,arg3,arg4,arg5)
%PRINTSTO Print or save graph containing styled text objects.
%	PRINTSTO has exactly the same syntax as PRINT.  It is required for
%	printing or saving figures which contain styled text objects.
%
%	See also PRINT, STEXT, SXLABEL, SYLABEL, SZLABEL, STITLE, SLEGEND,
%	STEXTBOX, DELSTEXT, SETSTEXT, FIXSTEXT.

%	Requires function MOVE1STO.
%	Requires MATLAB Version 4.2 or greater.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

% Check arguments.
if nargin > 5
	error('Too many input arguments.')
end

% Compute magnification in X and Y directions for each axes.
% Fudge factors of 1.00225 and 1.00325 were determined by trial and error.
thisFig = gcf;
curAxes = gca;
axesList = findobj(thisFig,'Type','axes');
allAnchors = [];
allDeltas = [];
allLabelAnchors = [];
allLabelDeltas = [];

paperUnits = get(thisFig,'PaperUnits');
paperPosOrig = get(thisFig,'PaperPosition');
set(thisFig,'PaperUnits','points')
paperPos = get(thisFig,'PaperPosition');
set(thisFig,'PaperUnits',paperUnits,'PaperPosition',paperPosOrig)
ver5 = cmdmatch(version,'5');

for thisAxes = axesList'
	if ver5
		if strcmp(get(thisAxes,'Stretch'),'on')
			aspect = nan;
		else
			aspect = get(thisAxes,'PlotBoxAspectRatio');
			aspect = aspect(1)/aspect(2);
		end
	else
		aspect = get(thisAxes,'AspectRatio');
		aspect = aspect(1);
	end

	% Compute magnification factors.
	axUnits = get(thisAxes,'Units');
	axPosOrig = get(thisAxes,'Position');
	set(thisAxes,'Units','points');
	axPos = get(thisAxes,'Position');
	set(thisAxes,'Units',axUnits,'Position',axPosOrig)
	ws = axPos(3);
	hs = axPos(4);
	if strcmp(axUnits,'normalized')
		axPosNorm = get(thisAxes,'Position');
		wp = paperPos(3)*axPosNorm(3);
		hp = paperPos(4)*axPosNorm(4);
		if ~isnan(aspect)
			if aspect > ws/hs
				hs = ws/aspect;
			else
				ws = hs*aspect;
			end
			if aspect > wp/hp
				hp = wp/aspect;
			else
				wp = hp*aspect;
			end
		end
		magX = 1.00225*wp/ws;
		magY = 1.00325*hp/hs;
	else
		magX = 1;
		magY = 1;
	end

	% Find all plain and title stext objects defined in relative units.
	anchors = [findobj(thisAxes,'Tag','stext','Units','normalized');...
			findobj(thisAxes,'Tag','stext','Units','data');...
			findobj(thisAxes,'Tag','stext title','Units','normalized');...
			findobj(thisAxes,'Tag','stext title','Units','data')];
	n = length(anchors);
	delta = zeros(n,2);
	
	% Shift the objects so they will print correctly.
	for i = 1:n
		userData = get(anchors(i),'UserData');
		origPos = userData(2:3);
		if strcmp(get(anchors(i),'Units'),'data')
			printPos = origPos.*[magX,magY] + [1.2 1.2];
		else
			printPos = origPos.*[magX,magY];
		end
		delta(i,:) = printPos - origPos;
		move1sto(anchors(i),delta(i,:))
	end
	allAnchors = [allAnchors;anchors];
	allDeltas = [allDeltas;delta];

	% Find all label stext objects.
	labelAnchors = [findobj(thisAxes,'Tag','stext xlabel');...
			findobj(thisAxes,'Tag','stext ylabel');...
			findobj(thisAxes,'Tag','stext zlabel')];
	nl = length(labelAnchors);
	labelDelta = zeros(nl,2);
	
	% Shift all label stext objects so they will print correctly.
	tickDirFactor = 10*strcmp(get(thisAxes,'TickDir'),'out');
	for i = 1:nl
		userData = get(labelAnchors(i),'UserData');
		origPos = userData(2:3);
		printPos = origPos.*[magX,magY] + [1.2 1.2];
		
		id = userData(1);
		labH = get(thisAxes,['W'+id,'Label']);
		hor = get(labH,'HorizontalAlignment');
		if strcmp(hor,'center')
			rot = get(labH,'Rotation');
			set(labH,'units','points')
			labpos = get(labH,'Position');
			if rot == 0
				beyond = labpos(2) + tickDirFactor;
				printPos(2) = (origPos(2) - beyond)*magY + beyond;
			elseif rot == 90
				beyond = labpos(1) + tickDirFactor;
				printPos(1) = (origPos(1) - beyond)*magX + beyond;
			elseif rot == -90
				beyond = labpos(1) - axPos(3) - tickDirFactor;
				printPos(1) = (origPos(1) - beyond)*magX + beyond;
			end
		end
	
		labelDelta(i,:) = printPos - origPos;
		move1sto(labelAnchors(i),labelDelta(i,:))
	end
	allLabelAnchors = [allLabelAnchors;labelAnchors];
	allLabelDeltas = [allLabelDeltas;labelDelta];

end


% Find all slegend objects.
legends = [findobj(thisFig,'Tag','slegend');...
		findobj(thisFig,'Tag','slegend movable')];
nleg = length(legends);
origLegPos = zeros(nleg,4);


% Shift the legends so they will print correctly.
for i = 1:nleg
	newPos = get(legends(i),'Position');
	origLegPos(i,:) = newPos;
	userData = get(legends(i),'UserData');
	xy = userData(1:2);
	ref = userData(3:4);
	newPos(1:2) = paperPos(3:4).*xy - ref.*origLegPos(i,3:4);
	set(legends(i),'Position',newPos)
	set(thisFig,'CurrentAxes',legends(i))
end

drawnow discard


% Execute print command.
if nargin == 0
	print
elseif nargin == 1
	print(arg1)
elseif nargin == 2
	print(arg1,arg2)
elseif nargin == 3
	print(arg1,arg2,arg3)
elseif nargin == 4
	print(arg1,arg2,arg3,arg4)
elseif nargin == 5
	print(arg1,arg2,arg3,arg4,arg5)
end


% Shift all stext objects back to where they were.
for i = 1:length(allAnchors)
	move1sto(allAnchors(i),-allDeltas(i,:))
end
for i = 1:length(allLabelAnchors)
	move1sto(allLabelAnchors(i),-allLabelDeltas(i,:))
end
for i = 1:nleg
	set(legends(i),'Position',origLegPos(i,:))
end
drawnow discard

set(thisFig,'CurrentAxes',curAxes)
