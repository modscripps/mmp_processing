function value = getstext(anchor,property)
%GETSTEXT Get property values for styled text objects.
% GETSTEXT(H,PROPERTY) returns the value of the named property for the
% styled text object with handle H.
%
% GETSTEXT(H) displays all property names and values for the styled text
% object with handle H.
%
% See also STEXT, GET.

% Version 2.1, 8 September 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz.  All rights reserved.
% schwarz@kodak.com

if ~cmdmatch(get(anchor,'Tag'),'stext')
	error('Not a styled text object.')
end

if nargin == 2
	property = lower(property);
	
	if cmdmatch('color',property)
		error('Invalid object property.')
	
	elseif cmdmatch('fontangle',property)
		error('Invalid object property.')
	
	elseif cmdmatch('fontname',property)
		error('Invalid object property.')
	
	elseif cmdmatch('fontsize',property)
		error('Invalid object property.')
	
	elseif cmdmatch('fontweight',property)
		error('Invalid object property.')
	
	elseif cmdmatch('visible',property)
		objList = get(anchor,'UserData');
		value = get(objList(4),'Visible');
	
	elseif cmdmatch('extent',property)
		objList = get(anchor,'UserData');
		objList(1:3) = [];
		numObjects = length(objList);
		extents = zeros(numObjects,4);
		anchorUnits = get(anchor,'Units');
		for i = 1:numObjects
			objUnits = get(objList(i),'Units');
			set(objList(i),'Units',anchorUnits)
			extents(i,:) = get(objList(i),'Extent');
			set(objList(i),'Units',objUnits)
		end
		lbrt = [extents(:,1:2),extents(:,1:2) + extents(:,3:4)];
		lbrtAll = [min(lbrt(:,1)),min(lbrt(:,2)),max(lbrt(:,3)),max(lbrt(:,4))];
		value = [lbrtAll(1:2),lbrtAll(3:4) - lbrtAll(1:2)];
	
	else
		value = get(anchor,property);
	end
else
	fprintf(1,'\tEraseMode = %s\n',get(anchor,'EraseMode'))
	fprintf(1,'\tExtent = [%g %g %g %g]\n',getstext(anchor,'Extent'))
	fprintf(1,'\tHorizontalAlignment = %s\n',get(anchor,'HorizontalAlignment'))
	fprintf(1,'\tPosition = [%g %g %g]\n',get(anchor,'Position'))
	fprintf(1,'\tRotation = [%g]\n',get(anchor,'Rotation'))
	fprintf(1,'\tString = %s\n',get(anchor,'String'))
	fprintf(1,'\tUnits = %s\n',get(anchor,'Units'))
	fprintf(1,'\tVerticalAlignment = %s\n',get(anchor,'VerticalAlignment'))
	fprintf(1,'\n')
	fprintf(1,'\tButtonDownFcn = %s\n',get(anchor,'ButtonDownFcn'))
	fprintf(1,'\tChildren = []\n')
	fprintf(1,'\tClipping = %s\n',get(anchor,'Clipping'))
	fprintf(1,'\tInterruptible = %s\n',get(anchor,'Interruptible'))
	fprintf(1,'\tParent = [%g]\n',get(anchor,'Parent'))
	objList = get(anchor,'UserData');
	fprintf(1,'\tVisible = %s\n',get(objList(4),'Visible'))
end
