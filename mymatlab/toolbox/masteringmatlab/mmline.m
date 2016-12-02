function mmline(arg1,arg2,arg3,arg4,arg5,arg6)
%MMLINE Set Line Properties Using Mouse.
% MMLINE waits for a mouse click on a line then
% applies the desired properties to the selected line.
% Properties are given in pairs, e.g., MMLINE name value ...
% Properties:
% NAME		VALUE		{default}
% color		[y m c r g b w k] or an rgb in quotes: '[r g b]'
% style		[-  --  :  -.]
% mark		[o  +  .  *  x)]
% width		points for linewidth {0.5}
% size		points for marker size (6)
% zap		(n.a.)  delete selected line
% Examples:
% MMLINE color r width 2   sets color to red and width to 2 points
% MMLINE mark + size 8     sets marker type to + and size to 8 points
% MMLINE color '[1 .5 0]'  sets color to orange
%
% Clicking on an object other than a line, or striking
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
	Hl=gco;
	if strcmp(get(Hl,'Type'),'line') % line object selected
		for i=1:2:max(nargin-1,1)
			name=eval(sprintf('arg%.0f',i),'[]'); % get name argument
			if strcmp(name,'zap')
				delete(Hl),return
			end
			value=eval(sprintf('arg%.0f',i+1),'[]'); % get value argument
			if strcmp(name,'color')
				if value(1)=='[',value=eval(value);end
				set(Hl,'Color',value)
			elseif strcmp(name,'style')
				set(Hl,'Linestyle',value)
			elseif strcmp(name,'mark')
				set(Hl,'Linestyle',value)
			elseif strcmp(name,'width')
				value=abs(eval(value));
				set(Hl,'LineWidth',value)
			elseif strcmp(name,'size')
				value=abs(eval(value));
				set(Hl,'MarkerSize',value)
			else
				disp(['Unknown Property Name: ' name])
			end
		end
	end
end
