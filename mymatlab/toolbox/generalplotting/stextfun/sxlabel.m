function sxlabel(str,p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8)
%SXLABEL X-axis styled text labels.
%	SXLABEL('styled text') adds styled text label near the X-axis on the
%	current axis.
%
%	SXLABEL('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%	sets the values of the specified properties of the sxlabel.
%
%	See also XLABEL, STEXT, SYLABEL, SZLABEL, STITLE, DELSTEXT,
%	PRINTSTO, SETSTEXT, FIXSTEXT.

%	Requires functions STEXT and DELSTEXT.
%	Requires MATLAB Version 4.2 or greater.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

if ~rem(nargin,2)
	error('Incorrect number of input arguments.')
end

ax = gca;

% Delete any existing xlabel.
xlabel('')
sxlab = findobj(ax,'Tag','stext xlabel');
if ~isempty(sxlab)
	delstext(sxlab)
end

if isempty(str), return, end

% Get xlabel characteristics.
xlab = get(ax,'XLabel');
set(xlab,'Units','normalized')
pos = get(xlab,'Position');
hor = get(xlab,'HorizontalAlignment');
ver = get(xlab,'VerticalAlignment');
rot = get(xlab,'Rotation');

% Build stext command.
numPairs = (nargin - 1)/2;
command = '';
for i = 1:numPairs
	command = [command,',p',num2str(i),',v',num2str(i)];
end
sxlab = eval(['stext(pos(1),pos(2),str,''Units'',''normalized'',',...
		'''HorizontalAlignment'',hor,''VerticalAlignment'',ver,',...
		'''Rotation'',rot',command,')']);

% Set type of styled text object.
userData = get(sxlab,'UserData');
userData(1) = 1;
set(sxlab,'Tag','stext xlabel','UserData',userData)
