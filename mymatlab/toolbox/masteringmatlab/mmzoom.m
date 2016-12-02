function mmzoom(arg)
%MMZOOM Simple 2-D Zoom-In Function Using RBBOX.
% MMZOOM zooms in on a plot based on the size of a
% rubberband box drawn by the user with the mouse.
% MMZOOM x     zooms the x-axis only.
% MMZOOM y     zooms the y-axis only.
% MMZOOM reset or
% MMZOOM out   restores original axis limits.
%
% Striking a key on the keyboard aborts the command.
% MMZOOM becomes inactive after zoom is complete or aborted.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/29/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

global MMZOOM_DEFAXISLIMS
global MMZOOM_AXES

Hf=mmgcf;
if isempty(Hf), error('No Figure Available.'), end
if nargin==0,arg=' ';end
arg=arg(1);

if (arg=='r'|arg=='o') &~isempty(MMZOOM_DEFAXISLIMS)  % reset request
	set(MMZOOM_AXES,'Xlim',MMZOOM_DEFAXISLIMS(1:2),...
					'Ylim',MMZOOM_DEFAXISLIMS(3:4))
	MMZOOM_DEFAXISLIMS=[];MMZOOM_AXES=[];
	return
elseif (arg=='r'|arg=='o') % already reset
	return
end
if length(findobj(0,'Type','figure'))==1
	figure(Hf) % bring only figure forward
end

key=waitforbuttonpress; % user chooses a figure and axes to zoom
if key  % key on keyboard pressed
	mmzoom('reset')  % clean stuff up with a recursive call
else    % figure selected
	if any(get(gca,'View')~=[0 90]),error('Plot must be 2-D.'),end
	if isempty(MMZOOM_DEFAXISLIMS)  % store limits for future reset
		MMZOOM_DEFAXISLIMS=axis;
		MMZOOM_AXES=gca;
	end
	
	cp=get(gca,'CurrentPoint');  	% get first point
	cfp=get(gcf,'CurrentPoint'); 	% get pointer w.r.t. figure
	rbbox([cfp 0 0],cfp)			% drag rubberband box at cfp
	cp=[cp;get(gca,'CurrentPoint')];% add second point
	
	% convert points to useful axis limits
	lims=[min(cp(:,1)) max(cp(:,1)) min(cp(:,2)) max(cp(:,2))];
	alims=axis;

	dlims=max(diff(alims)/20,diff(lims)); % max zoom is 20X
	lims=[lims(1) lims(1)+dlims(1) lims(3) lims(3)+dlims(3)];
	
	lims=[	max(lims(1),alims(1)) min(lims(2),alims(2)) ...
			max(lims(3),alims(3)) min(lims(4),alims(4))]; % no zoom out
			
	if arg=='x',		set(gca,'Xlim',lims(1:2))
	elseif arg=='y',	set(gca,'Ylim',lims(3:4))
	else				set(gca,'Xlim',lims(1:2),'Ylim',lims(3:4))
	end
end
