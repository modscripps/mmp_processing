function sylabel(str,p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8)
%SYLABEL Y-axis styled text labels.
% SYLABEL('styled text') adds styled text label near the Y-axis on the
% current axis.
%
% SYLABEL('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
% sets the values of the specified properties of the sylabel.
%
% See also YLABEL, STEXT, SXLABEL, SZLABEL, STITLE, DELSTEXT,
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

% Delete any existing ylabel.
ylabel('')
sylab = findobj(ax,'Tag','stext ylabel');
if ~isempty(sylab)
	delstext(sylab)
end

if isempty(str), return, end

% Get ylabel characteristics.
ylab = get(ax,'YLabel');
set(ylab,'Units','normalized')
pos = get(ylab,'Position');
hor = get(ylab,'HorizontalAlignment');
ver = get(ylab,'VerticalAlignment');
rot = get(ylab,'Rotation');

% Build stext command.
numPairs = (nargin - 1)/2;
command = '';
for i = 1:numPairs
	command = [command,',p',num2str(i),',v',num2str(i)];
end
sylab = eval(['stext(pos(1),pos(2),str,''Units'',''normalized'',',...
		'''HorizontalAlignment'',hor,''VerticalAlignment'',ver,',...
		'''Rotation'',rot',command,')']);

% Set type of styled text object.
userData = get(sylab,'UserData');
userData(1) = 2;
set(sylab,'Tag','stext ylabel','UserData',userData)
