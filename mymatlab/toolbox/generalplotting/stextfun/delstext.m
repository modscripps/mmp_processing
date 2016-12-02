function delstext(hh)
%DELSTEXT Delete styled text objects.
%	DELSTEXT(H) deletes the styled text object with handle H.  Nothing
%	is deleted if H is not a valid handle to a styled text object. H
%	can also be a vector of handles.
%
%	See also STEXT.

%	Requires function CMDMATCH.
%	Requires MATLAB Version 4.2 or greater.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

for h = hh(:)'
	% First, check to see if value is a valid handle.
	if eval('isstr(get(h,''Type''))','0')
		% Check to see if handle is a styled text object.
		if cmdmatch(get(h,'Tag'),'stext')
			% Get handles to text objects and delete them.
			userData = get(h,'UserData');
			objList = userData(4:length(userData));
			delete(objList)
			delete(h)
		end
	end
end
