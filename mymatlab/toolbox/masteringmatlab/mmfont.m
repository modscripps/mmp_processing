function mmfont(arg1,arg2,arg3,arg4,arg5,arg6)
%MMFONT Set Font and Text Properties Using Mouse.
% MMFONT waits for a mouse click on a text string then
% applies the desired properties to the selected text.
% Properties are given in pairs, e.g., MMFONT name value ...
% Properties:
% NAME		VALUE		{default}
% color		[y m c r g b w k] or an rgb in quotes: '[r g b]'
% style		[{normal} bold italic] (oblique is italic on some systems)
% size		size in points {12}
% name		any valid font name on your system
% orient	[{0} 90 180 270]
% drag		(n.a.)  as LAST parameter allow user to drag text with mouse
% zap		(n.a.)  delete selected text string
% Examples:
% MMFONT color r size 8   sets color to red and size to 8 points
% MMFONT orient 90 name times   sets orient to 90 and name to times
% MMFONT color '[1 .5 0]'  sets color to orange
% MMFONT size 18 drag   set size to 18 then allows text drag using mouse
%
% Clicking on an object other than a string, or striking
% a key on the keyboard aborts the command.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 6/28/95
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
	Ht=gco;
	if strcmp(get(Ht,'Type'),'text') % text object selected
		for i=1:2:max(nargin-1,1)
			name=eval(sprintf('arg%.0f',i),'[]'); % get name argument
			if strcmp(name,'zap')
				delete(Ht),return
			end
			value=eval(sprintf('arg%.0f',i+1),'[]'); % get value
			end
			if strcmp(name,'color')
				if value(1)=='[',value=eval(value);end
				set(Ht,'Color',value)
			elseif strcmp(name,'style')
				if value(1)=='i'|value(1)=='o'
					set(Ht,'FontAngle',value)
				elseif value(1)=='b'
					set(Ht,'FontWeight',value)
				else
					set(Ht,'FontWeight','normal','FontAngle','normal')
				end
			elseif strcmp(name,'size')
				value=max(6,fix(abs(eval(value,'12'))));
				set(Ht,'FontSize',value)
			elseif strcmp(name,'name')
				set(Ht,'FontName',value)
			elseif strcmp(name,'orient')
				value=abs(eval(value,'0'));
				set(Ht,'Rotation',value)
			else
				disp(['Unknown Property Name: ' name])
			end
		end
		if strcmp(eval(sprintf('arg%.0f',nargin),'[]'),'drag')
			mmtext	% call mmtext to do drag
		end
	end
end
