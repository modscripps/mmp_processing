function delstext(hh)
%DELSTEXT Delete a styled text object.
% DELETE(H) deletes the styled text object with handle H.
%
% See also STEXT, SXLABEL, SYLABEL, SZLABEL, STITLE, PRINTSTO,
% SETSTEXT, FIXSTEXT.

% Requires MATLAB Version 4.2 or greater.

% Version 2.1, 8 September 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz.  All rights reserved.
% schwarz@kodak.com

for h = hh(:)'
	% Check to see if handle is a valid stext object.
	tag = get(h,'Tag');
	if ~strcmp(tag(1:min(length(tag),5)),'stext')
		error('Not an stext object.')
	end
	
	% Get handles to text objects and delete them.
	userData = get(h,'UserData');
	objList = userData(4:length(userData));
	delete(objList)
	delete(h)
end
