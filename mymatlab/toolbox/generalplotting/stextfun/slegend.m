function [leg,hl,h] = slegend(xy,specs,strs,p1,v1,p2,v2,...
		p3,v3,p4,v4,p5,v5,p6,v6,p7,v7)
%SLEGEND Styled text legend.
%	SLEGEND(XY,SMPLSPEC,LEGENDTEXT) places a legend centered at XY =
%	[X,Y] on the current figure, where X and Y are in normalized figure
%	units.  LEGENDTEXT is a string matrix (see STR2MAT) which specifies
%	the text of the legend.  The legend text is produced with STEXT and
%	so each row of LEGENDTEXT must be valid styled text.  SMPLSPEC can be
%	a string matrix of plot symbols and colors as with PLOT.  An additional
%	plot symbol is '#' which specifies a sample patch.  Valid values for
%	the rows of SMPLSPEC are '-', '--r', 'c+', '#y', etc.  SMPLSPEC can
%	also be a vector of handles to line or patch objects, in which case
%	the characteristics of the line or patch samples are copied from
%	those objects.
%	
%	XY = 'mouse' allows dragging the slegend to the desired location with
%	the mouse.  The slegend can be locked in position by pressing the
%	space bar while holding down the mouse button.  SLEGEND('move') or
%	SLEGEND('mouse') will make all slegends and stextboxes in the current
%	figure movable.
%
%	XY, SMPLSPEC and LEGENDTEXT can be followed by property/value pairs
%	to specify additional properties of the slegend:
%	
%	Property = 'Color', value = [ {none} ] -or- a ColorSpec
%		allows you to specify the background color of the slegend.  If
%		the color is 'none', the box will be transparent.  When printed,
%		slegends are placed on top of other axes and opaque slegends will
%		obscure whatever is behind them.
%	
%	Property = 'HorizontalAlignment', value = [ left | {center} | right ]
%		controls the horizontal alignment of the slegend with respect to XY.
%
%	Property = 'VerticalAlignment', value = [ top | {middle} | bottom ]
%		controls the vertical alignment of the slegend with respect to XY.
%
%	Property = 'Box', value = [ {on} | off ]
%		allows you to control whether the enclosing box is visible.
%	
%	Property = 'BorderFactor', value = [ {0.25} | <any positive number> ]
%		sets the amount of space between the slegend and the enclosing
%		box as a fraction of the height of the tallest line of text.
%	
%	Property = 'SampleWidth', value = [ {30} | <any positive number> ]
%		sets the width in points of the line samples.
%
%	Property = 'Spacing', value = [ tight | {loose} ]
%		controls the line spacing of the text.  Tight spacing moves the
%		lines as close together as possible, loose spacing makes all
%		lines equally spaced and equal to the height of the tallest line.
%	
%	
%	[H,HLINES,HTEXT] = SLEGEND(...) returns a handle to the legend axes
%	object, handles to the line samples and handles to the legend text.
%	Since a legend is an axes object it is possible to make changes to
%	its properties, e.g., changing the 'LineWidth' of the border.
%
%	A figure containing an SLEGEND must be printed with PRINTSTO.
%
%	See also STEXT, STEXTBOX, PRINTSTO, STR2MAT and PLOT.

%	Requires functions STEXT, GETSTEXT and MOVE1STO.
%	Requires MATLAB Version 4.2 or greater.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

if nargin > 1
	% Set defaults.
	mouse = 0;
	legColor = 'none';
	horiz = 0.5;
	vert = 0.5;
	ref = [0.5,0.5];
	box = 'on';
	borderFactor = 0.25;
	sampleWid = 30;
	tightSpacing = 0;
	numOptions = (nargin - 3)/2;
	baseAxes = gca;
	ver5 = cmdmatch(version,'5');
	
	if isstr(xy)
		if strcmp(lower(xy),'mouse')
			mouse = 1;
			xy = [0.5,0.5];
		else
			error('Unknown position option.')
		end
	else
		if length(xy) ~= 2
			error('The position must be a 2-element vector')
		end
	end
	
	for i = 1:numOptions
		property = lower(eval(sprintf('p%d',i)));
		value = lower(eval(sprintf('v%d',i)));
		
		if cmdmatch('color',property)
			legColor = value;
		
		elseif cmdmatch('horizontalalignment',property)
			horiz = value;
		
		elseif cmdmatch('verticalalignment',property)
			vert = value;
		
		elseif cmdmatch('box',property)
			box = value;
		
		elseif cmdmatch('borderfactor',property)
			borderFactor = value;
		
		elseif cmdmatch('samplewidth',property)
			sampleWid = value;
		
		elseif cmdmatch('spacing',property)
			if cmdmatch('tight',value)
				tightSpacing = 1;
			elseif cmdmatch('loose',value)
				tightSpacing = 0;
			else
				error('Invalid data for slegend parameter "Spacing".')
			end
		
		else
			error('Unknown property.')
		end
	end
	
	if isstr(horiz)
		if cmdmatch('left',horiz)
			ref(1) = 0;
		elseif cmdmatch('right',horiz)
			ref(1) = 1;
		elseif cmdmatch('center',horiz)
			ref(1) = 0.5;
		else
			error('Invalid data for slegend parameter "HorizontalAlignment".')
		end
	else
		ref(1) = horiz;
	end
	
	if isstr(vert)
		if cmdmatch('bottom',vert)
			ref(2) = 0;
		elseif cmdmatch('top',vert)
			ref(2) = 1;
		elseif cmdmatch('middle',vert)
			ref(2) = 0.5;
		else
			error('Invalid data for slegend parameter "VerticalAlignment".')
		end
	else
		ref(2) = vert;
	end
	
	% Create the legend axes and contents.
	ax = axes('Units','norm','Position',[xy,0.5,0.5],...
			'XTick',[],'YTick',[],'Box','on','Color',legColor);
	if strcmp(box,'off')
		if strcmp(legColor,'none')
			set(ax,'Visible','off')
		else
			set(ax,'XColor',legColor,'YColor',legColor,'ZColor',legColor)
		end
	end
	
	set(ax,'Units','points')
	xy2 = get(ax,'Position');
	xy2(3:4) = [];
	n = min(size(specs,1),size(strs,1));
	h = zeros(n,1);
	exts = zeros(n,4);
	for i = 1:n
		cmd = ['stext(0,0,deblank(strs(i,:)),''units'',''points'',',...
				'''hor'',''left'',''vert'',''mid'')'];
		h(i) = eval(cmd,'-1');
		if h(i) == -1
			delete(ax)
			error(lasterr)
		end
		exts(i,:) = getstext(h(i),'Extent');
	end
	
	% Compute the size of the axes based on the contents.
	maxht = max(exts(:,4));
	maxdrop = min(exts(:,2));
	border = maxht*borderFactor;
	hgap = 0.25*maxht;
	if tightSpacing
		yvals = flipud([0;cumsum(exts(n:-1:2,4))]) - exts(:,2) + border;
		top = yvals(1) + exts(1,4) + exts(1,2) + border + 1;
	else
		yvals = flipud(maxht*(0:(n-1))') - min(exts(:,2)) + border;
		top = yvals(1) + maxht + maxdrop + border + 1;
	end
	left = sampleWid + 2*border + hgap;
	right = left + max(exts(:,3)) + 2*border;
	
	% Move the contents to their final positions and set the new size
	% for the legend axes.
	for i = 1:n
		delta = yvals(i);
		userData = get(h(i),'UserData');
		userData(3) = userData(3) + delta;
		set(h(i),'Position',[0,delta])
		set(h(i),'UserData',userData)
		move1sto(h(i),[left,delta])
	end
	pos = get(ax,'Position');
	xy3 = xy2 - [right,top].*ref;
	set(ax,'Position',[xy3,right,top],...
			'XLim',[0 right],'YLim',[0 top])
	
	% Plot the line type samples.
	hl = zeros(n,1);
	if isstr(specs)
		for i = 1:n
			lt = deblank(specs(i,:));
			color = get(0,'DefaultTextColor');
			colorSpec = lt == 'r' | lt == 'g' | lt == 'b' | lt == 'c' ...
					| lt == 'm' | lt == 'y' | lt == 'w' | lt == 'k';
			if any(colorSpec), color = lt(colorSpec); end
			lt(colorSpec) = [];
			if strcmp(lt,'-') | strcmp(lt,'--') | strcmp(lt,'-.') ...
					| strcmp(lt,':')
				x = [0,sampleWid] + 2*border;
				y = [1,1]*yvals(i);
				hl(i) = line(x,y,'LineStyle',lt,'Color',color);
			elseif strcmp(lt,'#')
				x = [-1 1 1 -1]*sampleWid/3 + 2*border + sampleWid/2;
				y = [-1 -1 1 1]*maxht/3 + yvals(i);
				hl(i) = patch(x,y,'r','FaceColor',color);
			else
				if ver5
					hl(i) = line(2*border+sampleWid/2,yvals(i),...
							'LineStyle','none','Marker',lt,'Color',color);
				else
					hl(i) = line(2*border+sampleWid/2,yvals(i),...
							'LineStyle',lt,'Color',color);
				end
			end
		end
	else
		for i = 1:n
			objType = get(specs(i),'Type');
			if strcmp(objType,'line')
				lt = get(specs(i),'LineStyle');
				if strcmp(lt,'-') | strcmp(lt,'--') | strcmp(lt,'-.') ...
						| strcmp(lt,':')
					hl(i) = line([0,sampleWid]+2*border,[1 1]*yvals(i),...
							'LineStyle',lt,...
							'LineWidth',get(specs(i),'LineWidth'),...
							'MarkerSize',get(specs(i),'MarkerSize'),...
							'Color',get(specs(i),'Color'));
				else
					if ver5
						hl(i) = line(2*border+sampleWid/2,yvals(i),...
								'LineStyle',lt,...
								'Marker',get(specs(i),'Marker'),...
								'LineWidth',get(specs(i),'LineWidth'),...
								'MarkerSize',get(specs(i),'MarkerSize'),...
								'Color',get(specs(i),'Color'));
					else
						hl(i) = line(2*border+sampleWid/2,yvals(i),...
								'LineStyle',lt,...
								'LineWidth',get(specs(i),'LineWidth'),...
								'MarkerSize',get(specs(i),'MarkerSize'),...
								'Color',get(specs(i),'Color'));
					end
				end
			elseif strcmp(objType,'patch')
				x = [-1 1 1 -1]*sampleWid/3 + 2*border + sampleWid/2;
				y = [-1 -1 1 1]*maxht/3 + yvals(i);
				hl(i) = patch(x,y,'r',...
						'FaceColor',get(specs(i),'FaceColor'),...
						'EdgeColor',get(specs(i),'EdgeColor'),...
						'LineWidth',get(specs(i),'LineWidth'));
			else
				delete(ax)
				error(['Illegal object of type ''',objType,'''.'])
			end
		end
	end
	
	% Save some needed data and enable legend dragging.
	userData = [xy,ref];
	if mouse
		set(ax,'Tag','slegend movable','UserData',userData)
		set(gcf,'WindowButtonDownFcn','slegend(1)')
	else
		set(ax,'Tag','slegend','UserData',userData)
	end
	set(gcf,'CurrentAxes',baseAxes)
	
	if nargout > 0
		leg = ax;
	end
	
elseif isstr(xy)
	xy = lower(xy);
	if strcmp(xy,'move') | strcmp(xy,'mouse')
		fig = get(0,'CurrentFigure');
		fixed = findobj(fig,'Tag','slegend');
		nf = length(fixed);
		nm = length(findobj(fig,'Tag','slegend movable'));
		for i = 1:nf
			set(fixed(i),'Tag','slegend movable')
		end
		if nf + nm > 0
			set(gcf,'WindowButtonDownFcn','slegend(1)')
		end
	else
		error('Unknown command.')
	end

% We have a mouse-down on a legend.
elseif xy == 1
	fig = get(0,'CurrentFigure');
	% Uncomment the following line to require holding down the control key
	% (or option on a Mac) while clicking the mouse to move a legend.
	%if ~strcmp(get(fig,'SelectionType'),'alt'), return, end
	curAx = get(fig,'CurrentAxes');
	
	figUnits = get(fig,'Units');
	figPos = get(fig,'Position');
	set(fig,'Units','points')
	cp = get(fig,'CurrentPoint');
	
	% Find the legend closest to current point.
	movLeg = findobj(fig,'Tag','slegend movable');
	n = length(movLeg);
	if n == 0
		set(fig,'Units',figUnits,'Position',figPos,'WindowButtonDownFcn','')
		return
	end
	d2 = zeros(n,1);
	for i = 1:n
		pos = get(movLeg(i),'Position');
		d = cp - pos(1:2);
		d2(i) = d*d';
	end
	[junk,closest] = min(d2);
	theLeg = movLeg(closest);
	
	userData = get(theLeg,'UserData');
	set(theLeg,'UserData',[userData(1:4),cp,real(figUnits)],...
			'Tag','slegend moving')
	set(fig,'CurrentAxes',theLeg,'CurrentAxes',curAx,...
			'WindowButtonMotionFcn','slegend(2)',...
			'WindowButtonUpFcn','slegend(3)',...
			'KeyPressFcn','slegend(4)',...
			'pointer','fleur')

% Moving a legend.
elseif xy == 2
	fig = get(0,'CurrentFigure');
	theLeg = findobj(fig,'Tag','slegend moving');
	userData = get(theLeg,'UserData');
	cp = userData(5:6);
	newp = get(fig,'CurrentPoint');
	userData(5:6) = newp;
	delta = newp - cp;
	pos = get(theLeg,'Position');
	pos(1:2) = pos(1:2) + delta;
	set(theLeg,'Position',pos,'UserData',userData)

% We have a mouse-up on a legend.
elseif xy == 3
	fig = get(0,'CurrentFigure');
	theLeg = findobj(fig,'Tag','slegend moving');
	userData = get(theLeg,'UserData');
	set(theLeg,'Units','norm')
	pos = get(theLeg,'Position');
	set(theLeg,'Units','points')
	ref = userData(3:4);
	userData(1:2) = pos(1:2) + ref.*pos(3:4);
	set(theLeg,'UserData',userData,'Tag','slegend movable')
	figUnits = setstr(userData(7:length(userData)));
	set(fig,'Units',figUnits,'pointer','arrow',...
			'WindowButtonMotionFcn','','WindowButtonUpFcn','',...
			'KeyPressFcn','')

% We are locking the position of a legend.
elseif xy == 4
	fig = get(0,'CurrentFigure');
	theLeg = findobj(fig,'Tag','slegend moving');
	if get(fig,'CurrentCharacter') == ' '
		if length(findobj(fig,'Tag','slegend movable')) == 0
			set(fig,'WindowButtonDownFcn','')
		end
		userData = get(theLeg,'UserData');
		set(theLeg,'Units','norm')
		pos = get(theLeg,'Position');
		set(theLeg,'Units','points')
		ref = userData(3:4);
		userData(1:2) = pos(1:2) + ref.*pos(3:4);
		set(theLeg,'UserData',userData,'Tag','slegend')
		figUnits = setstr(userData(7:length(userData)));
		set(fig,'Units',figUnits,'pointer','arrow',...
				'WindowButtonMotionFcn','','WindowButtonUpFcn','',...
				'KeyPressFcn','')
	end
end
