function mmdraw(arg1,arg2,arg3,arg4,arg5,arg6,arg7)
%MMDRAW Draw a Line and Set Properties Using Mouse.
% MMDRAW draws a line in the current axes using the mouse,
% Click at the starting point and drag to the end point.
% In addition, properties can be given to the line.
% Properties are given in pairs, e.g., MMDRAW name value ...
% Properties:
% NAME		VALUE		{default}
% color		[y m c r g b {w} k] or an rgb in quotes: '[r g b]'
% style		[-  --  {:}  -.]
% mark		[o  +  .  *  x)]
% width		points for linewidth {0.5}
% size		points for marker size {6}
% Examples:
% MMDRAW color r width 2   sets color to red and width to 2 points
% MMDRAW mark + size 8     sets marker type to + and size to 8 points
% MMDRAW color '[1 .5 0]'  sets color to orange
%

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 4/27/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

global MMDRAW_HL MMDRAW_EVAL

if nargin==0
	arg1='color';arg2='w';arg3='style';arg4=':';nargin=4;
end

if isstr(arg1)  % initial call, set things up
	Hf=mmgcf;
	if isempty(Hf), error('No Figure Available.'), end
	Ha=findobj(Hf,'Type','axes');
	if isempty(Ha), error('No Axes in Current Figure.'),end
	set(Hf,	'Pointer','crossh',...  % set up callback for line start
			'BackingStore','off',...
			'WindowButtonDownFcn','mmdraw(1)')
	figure(Hf)
	MMDRAW_EVAL='mmdraw(99';  % set up string to set attributes
	for i=1:nargin
		argi=eval(sprintf('arg%.0f',i));
		MMDRAW_EVAL=[MMDRAW_EVAL ',''' argi ''''];
	end
	MMDRAW_EVAL=[MMDRAW_EVAL ')'];

elseif arg1==1  % callback is line start point
	fp=get(gca,'CurrentPoint');  	% start of line point
	set(gca,'Userdata',fp(1,1:2))	% store in axes userdata
	set(gcf,'WindowButtonMotionFcn','mmdraw(2)',...
			'WindowButtonUpFcn','mmdraw(3)')

elseif arg1==2  % callback is mouse motion
	cp=get(gca,'CurrentPoint');cp=cp(1,1:2);
	fp=get(gca,'Userdata');
	Hl=line('Xdata',[fp(1);cp(1)],'Ydata',[fp(2);cp(2)],...
			'EraseMode','xor',...
			'Color','w','LineStyle',':',...
			'Clipping','off');
	if ~isempty(MMDRAW_HL)  % delete prior line if it exists
		delete(MMDRAW_HL)
	end
	MMDRAW_HL=Hl; % store current line handle

elseif arg1==3  % callback is line end point, finish up
	set(gcf,'Pointer','arrow',...
			'BackingStore','on',...
			'WindowButtonDownFcn','',...
			'WindowButtonMotionFcn','',...
			'WindowButtonUpFcn','')
	set(gca,'Userdata',[])
	set(MMDRAW_HL,'EraseMode','normal') % render line better
	eval(MMDRAW_EVAL)
	MMDRAW_EVAL=[];

elseif arg1==99  % process line properties
	for i=2:2:nargin-1
		name=eval(sprintf('arg%.0f',i),[]); % get name argument
		value=eval(sprintf('arg%.0f',i+1),[]); % get value argument
		if strcmp(name,'color')
			if value(1)=='[', value=eval(value);end
			set(MMDRAW_HL,'Color',value)
		elseif strcmp(name,'style')
			set(MMDRAW_HL,'Linestyle',value)
		elseif strcmp(name,'mark')
			set(MMDRAW_HL,'Linestyle',value)
		elseif strcmp(name,'width')
			value=abs(eval(value));
			set(MMDRAW_HL,'LineWidth',value)
		elseif strcmp(name,'size')
			value=abs(eval(value));
			set(MMDRAW_HL,'MarkerSize',value)
		else
			disp(['Unknown Property Name: ' name])
		end
	end
	MMDRAW_HL=[];
end		
	

