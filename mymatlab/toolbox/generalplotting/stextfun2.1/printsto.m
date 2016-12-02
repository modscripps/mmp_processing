function printsto(arg1,arg2,arg3,arg4,arg5)
%PRINTSTO Print or save graph containing styled text objects.
% PRINTSTO has exactly the same syntax as PRINT.  It is required for
% printing or saving figures which contain styled text objects.
%
% See also PRINT, STEXT, SXLABEL, SYLABEL, SZLABEL, STITLE, DELSTEXT,
% SETSTEXT, FIXSTEXT.

% Requires function MOVE1STO.
% Requires MATLAB Version 4.2 or greater.

% Version 2.1, 8 September 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz.  All rights reserved.
% schwarz@kodak.com

% Check arguments.
if nargin > 5
	error('Too many input arguments.')
end

% Compute magnification in X and Y directions.
% Fudge factors of 1.0025 and 1.004 were determined by trial and error.
thisFig = gcf;
figureUnits = get(thisFig,'Units');
paperUnits = get(thisFig,'PaperUnits');
set(thisFig,'Units',paperUnits)
figurePos = get(thisFig,'Position');
paperPos = get(thisFig,'PaperPosition');
magX = 1.0025*paperPos(3)/figurePos(3);
magY = 1.004*paperPos(4)/figurePos(4);
set(thisFig,'Units',figureUnits)


% Find all plain and title stext objects defined in relative units.
anchors = [findobj(thisFig,'Tag','stext','Units','normalized');...
		findobj(thisFig,'Tag','stext','Units','data');...
		findobj(thisFig,'Tag','stext title','Units','normalized');...
		findobj(thisFig,'Tag','stext title','Units','data')];
n = length(anchors);
delta = zeros(n,2);

% Shift the objects so they will print correctly.
for i = 1:n
	userData = get(anchors(i),'UserData');
	origPos = userData(2:3);
	printPos = origPos.*[magX,magY] + [1 1];
	delta(i,:) = printPos - origPos;
	move1sto(anchors(i),delta(i,:))
end


% Find all label stext objects.
labelAnchors = [findobj(thisFig,'Tag','stext xlabel');...
		findobj(thisFig,'Tag','stext ylabel');...
		findobj(thisFig,'Tag','stext zlabel')];
nl = length(labelAnchors);
labelDelta = zeros(nl,2);

% Shift all label stext objects so they will print correctly.
tickDirFactor = 10*strcmp(get(gca,'TickDir'),'out');
for i = 1:nl
	userData = get(labelAnchors(i),'UserData');
	origPos = userData(2:3);
	printPos = origPos.*[magX,magY] + [1 1];
	
	id = userData(1);
	labH = get(gca,['W'+id,'Label']);
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
			axunits = get(gca,'Units');
			set(gca,'Units','points')
			axpos = get(gca,'Position');
			set(gca,'Units',axunits)
			beyond = labpos(1) - axpos(3) - tickDirFactor;
			printPos(1) = (origPos(1) - beyond)*magX + beyond;
		end
	end

	labelDelta(i,:) = printPos - origPos;
	move1sto(labelAnchors(i),labelDelta(i,:))
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
for i = 1:n
	move1sto(anchors(i),-delta(i,:))
end
for i = 1:nl
	move1sto(labelAnchors(i),-labelDelta(i,:))
end
drawnow discard
