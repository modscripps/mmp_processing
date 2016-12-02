function szlabel(str,p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8)
%SZLABEL Z-axis styled text labels for 3-D plots.
% SZLABEL('styled text') adds styled text label near the Z-axis on the
% current axis.
%
% SZLABEL('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
% sets the values of the specified properties of the szlabel.
%
% See also ZLABEL, STEXT, SXLABEL, SYLABEL, STITLE, DELSTEXT,
% PRINTSTO, SETSTEXT, FIXSTEXT.

% Requires functions STEXT and DELSTEXT.
% Requires MATLAB Version 4.2 or greater.

% Version 2.1, 8 September 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz.  All rights reserved.
% schwarz@kodak.com

if ~rem(nargin,2)
	error('Incorrect number of input arguments.')
end

ax = gca;

% Delete any existing zlabel.
zlabel('')
szlab = findobj(ax,'Tag','stext zlabel');
if ~isempty(szlab)
	delstext(szlab)
end

if isempty(str), return, end

% Get zlabel characteristics.
zlab = get(ax,'ZLabel');
set(zlab,'Units','normalized')
pos = get(zlab,'Position');
hor = get(zlab,'HorizontalAlignment');
ver = get(zlab,'VerticalAlignment');
rot = get(zlab,'Rotation');

% Build stext command.
numPairs = (nargin - 1)/2;
command = '';
for i = 1:numPairs
	command = [command,',p',num2str(i),',v',num2str(i)];
end
szlab = eval(['stext(pos(1),pos(2),str,''Units'',''normalized'',',...
		'''HorizontalAlignment'',hor,''VerticalAlignment'',ver,',...
		'''Rotation'',rot',command,')']);

% Set type of styled text object.
userData = get(szlab,'UserData');
userData(1) = 3;
set(szlab,'Tag','stext zlabel','UserData',userData)
