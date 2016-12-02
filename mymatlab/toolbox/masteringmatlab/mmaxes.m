function mmaxes(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)
%MMAXES Set Axes Properties Using Mouse.
% MMAXES waits for a mouse click on an axes then
% applies the desired properties to the selected axes.
% Properties are given in pairs, e.g. MMAXES name value ...
% Properties:
% NAME		VALUE		{default}
% box		[{on} off]	 for axes bounding box
% color  	[y m c r g b {w} k] or an rgb in quotes: '[r g b]'
% width 	[points]	 for axes linewidth {0.5}
% tdir		[{in} out]	 for tick direction
% xtick 	[off {on}]	 to hide X-axis labels, nonreversible
% xdir		[{norm} rev] for X-axis direction (norm)
% xgrid		[on {off}]	 for X-axis grid
% xscale	[{lin} log]  for X-axis scaling
% zap   	(n.a.)	     to delete axes and plot contents
%
% xtick, xdir, xgrid, xscale have y and z axis counterparts:
% ytick, ydir, ygrid, yscale
% ztick, zdir, zgrid, zscale
% Examples:
% MMAXES box off ygrid on     turns box off and y-axis grid on
% MMAXES tdir out zscale log  sets tick direction out and z-axis to log
% MMAXES color '[1 .5 0]'     sets color to orange
%
% Clicking on an object other than an axes, or striking
% a key on the keyboard aborts the command.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 4/27/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

Hf=mmgcf;
if isempty(Hf), error('No Figure Available.'), end
if length(get(0,'Children'))==1
	figure(Hf) % bring only figure forward
end
key=waitforbuttonpress;
if key  % key on keyboard pressed
	return
else    % object selected
	Ha=gco;
	if strcmp(get(Ha,'Type'),'axes') % axes object selected
		for i=1:2:max(nargin-1,1)
			name=eval(sprintf('arg%.0f',i),[]); % get name argument
			if strcmp(name,'zap')
				delete(Ha),return
			end
			value=eval(sprintf('arg%.0f',i+1),[]); % get value argument
			if strcmp(name,'box')
				set(Ha,'Box',value)
			elseif strcmp(name,'color')
				if value(1)=='[',value=eval(value);end
				set(Ha,'XColor',value,'Ycolor',value,'ZColor',value)
			elseif strcmp(name,'width')
				set(Ha,'Linewidth',abs(eval(value)))
			elseif strcmp(name,'tdir')
				set(Ha,'TickDir',value)
			elseif strcmp(name,'xtick')&strcmp(value,'off')
				set(Ha,'Xtick',[])
			elseif strcmp(name,'xdir')
				set(Ha,'XDir',value)
			elseif strcmp(name,'xgrid')
				set(Ha,'XGrid',value)
			elseif strcmp(name,'xscale')
				set(Ha,'XScale',value)
			elseif strcmp(name,'ytick')&strcmp(value,'off')
				set(Ha,'Ytick',[])
			elseif strcmp(name,'ydir')
				set(Ha,'YDir',value)
			elseif strcmp(name,'ygrid')
				set(Ha,'YGrid',value)
			elseif strcmp(name,'yscale')
				set(Ha,'YScale',value)
			elseif strcmp(name,'zdir')
				set(Ha,'ZDir',value)
			elseif strcmp(name,'zgrid')
				set(Ha,'ZGrid',value)
			elseif strcmp(name,'zscale')
				set(Ha,'ZScale',value)
			elseif strcmp(name,'ztick')&strcmp(value,'off')
				set(Ha,'Ztick',[])
			else
				disp(['Unknown Property Name: ' name])
			end
		end
	end
end
