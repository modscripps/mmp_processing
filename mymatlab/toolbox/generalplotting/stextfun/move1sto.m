function move1sto(anchor,delta)
%MOVE1STO Move one styled text object.
%	MOVE1STO(H,DXY) moves the styled text object H by DXY(1) and DXY(2)
%	points in the X and Y directions respectively.
%	
%	MOVE1STO(H) moves the styled text object H to its correct location.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

userData = get(anchor,'UserData');
objList = userData(4:length(userData));

% Determine correct location based on location of anchor.
if nargin == 1
	anchorUnits = get(anchor,'Units');
	anchorPos = get(anchor,'Position');
	x0 = userData(2);
	y0 = userData(3);
	
	set(anchor,'Units','points')
	newPos = get(anchor,'Position');
	x1 = newPos(1);
	y1 = newPos(2);
	delta = [x1 - x0,y1 - y0];
	userData(2) = x1;
	userData(3) = y1;
	set(anchor,'Units',anchorUnits,'Position',anchorPos,...
			'UserData',userData,'Visible','off')
end

% Set new positions.
for obj = objList
	set(obj,'Units','points')
	set(obj,'Position', get(obj,'Position') + delta )
end
