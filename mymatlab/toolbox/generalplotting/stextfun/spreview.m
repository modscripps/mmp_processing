function spreview(sel)
%SPREVIEW GUI application to preview styled text objects.
%	SPREVIEW will create a new figure which contains an edit box in
%	which styled text can be typed and an axes to display the resulting
%	styled text object.  This can be used to construct styled text
%	objects, especially complicated ones.
%
%	SPREVIEW(STYLEDTEXT) uses the styled text in STYLEDTEXT as the
%	initial contents of the edit box.
%
%	See also STEXT.

%	Requires functions STEXT and FIXSTEXT.
%	Requires MATLAB Version 4.2 or greater.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

if nargin == 0
	sel = 0;
	s = '';
elseif nargin == 1
	if isstr(sel)
		s = sel;
		sel = 0;
	end
end

if sel == 0
	fig = figure;
	set(fig,'Units','pixels')
	figpos = get(fig,'Position');
	
	framePos = [16,16,figpos(3)-32,68];
	editPos = [20,20,figpos(3)-40,40];
	textPos = [20,60,figpos(3)-40,20];
	makePos = [figpos(3)-150,62,40,20];
	clearPos = [figpos(3)-106,62,40,20];
	savePos = [figpos(3)-62,62,40,20];
	axPos = [17,92,figpos(3)-32,figpos(4)-98];
	
	hf = uicontrol('Style','frame',...
			'Position',framePos);
	he = uicontrol('Style','edit',...
			'Position',editPos,...
			'String',s,...
			'CallBack','spreview(1)');
	ht = uicontrol('Style','text',...
			'Position',textPos,...
			'String','Type styled text here and press Make or RETURN:',...
			'Horiz','left');
	hm = uicontrol('Style','pushbutton',...
			'Position',makePos,...
			'String','Make',...
			'CallBack','spreview(1)');
	hc = uicontrol('Style','pushbutton',...
			'Position',clearPos,...
			'String','Clear',...
			'CallBack','cla');
	hs = uicontrol('Style','pushbutton',...
			'Position',savePos,...
			'String','Save',...
			'CallBack','get(findobj(gcf,''Style'',''edit''),''String'')');
	ax = axes('Units','pixels',...
			'Position',axPos,...
			'XTick',[],'YTick',[],...
			'Box','on',...
			'XLim',[0 1],'YLim',[0 1]);
	eval('set(fig,''ResizeFcn'',''spreview(2)'')','')
	
% Pressed RETURN or Make, create new styled text.
elseif sel == 1
	fig = gcf;
	cla
	he = findobj(fig,'Type','uicontrol','Style','edit');
	str = get(he,'String');
	stext(.5,.5,str,'hor','cen');

% Resizing the figure.
elseif sel == 2
	fig = gcf;
	figpos = get(fig,'Position');
	
	framePos = [16,16,figpos(3)-32,68];
	editPos = [20,20,figpos(3)-40,40];
	textPos = [20,60,figpos(3)-40,20];
	makePos = [figpos(3)-150,62,40,20];
	clearPos = [figpos(3)-106,62,40,20];
	savePos = [figpos(3)-62,62,40,20];
	axPos = [17,92,figpos(3)-32,figpos(4)-98];
	
	hf = findobj(fig,'Type','uicontrol','Style','frame');
	he = findobj(fig,'Type','uicontrol','Style','edit');
	ht = findobj(fig,'Type','uicontrol','Style','text');
	hm = findobj(fig,'Type','uicontrol','String','Make');
	hc = findobj(fig,'Type','uicontrol','String','Clear');
	hs = findobj(fig,'Type','uicontrol','String','Save');
	
	set(hf,'Position',framePos)
	set(he,'Position',editPos)
	set(ht,'Position',textPos)
	set(hm,'Position',makePos)
	set(hc,'Position',clearPos)
	set(hs,'Position',savePos)
	set(gca,'Position',axPos)
	
	fixstext
end
