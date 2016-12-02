function stitle(str,p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8)
%STITLE Styled text plot titles.
%	STITLE('styled text') adds styled text title at top of plot on the
%	current axis.
%	
%	STITLE('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%	sets the values of the specified properties of the stitle.
%	
%	See also TITLE, STEXT, SXLABEL, SYLABEL, SZLABEL, DELSTEXT,
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

% Delete any existing title.
title('')
stitleH = findobj(ax,'Tag','stext title');
if ~isempty(stitleH)
	delstext(stitleH)
end

if isempty(str), return, end

% Get title characteristics.
titleH = get(ax,'Title');
set(titleH,'Units','normalized')
pos = get(titleH,'Position');
hor = get(titleH,'HorizontalAlignment');
ver = get(titleH,'VerticalAlignment');

% Build stext command.
numPairs = (nargin - 1)/2;
command = '';
for i = 1:numPairs
	command = [command,',p',num2str(i),',v',num2str(i)];
end
stitleH = eval(['stext(pos(1),pos(2),str,''Units'',''normalized'',',...
		'''HorizontalAlignment'',hor,''VerticalAlignment'',ver',...
		command,')']);

% Set type of styled text object.
userData = get(stitleH,'UserData');
userData(1) = 4;
set(stitleH,'Tag','stext title','UserData',userData)
