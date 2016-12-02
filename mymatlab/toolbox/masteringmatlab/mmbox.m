function p=mmbox(f)
%MMBOX Get Position Vector of a Rubberband Box.
% MMBOX returns a position vector [left bottom width height]
% in axes coordinates of a rubberband box drawn by the user
% with the mouse.
% MMBOX('f') or MMBOX f  returns the position vector in
% figure coordinates.
%
% Striking a key on the keyboard aborts the command.
% MMBOX returns an empty matrix if an error occurs or if aborted.
% MMBOX becomes inactive after position is found or aborted.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 8/20/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

if nargin==0,f='a';end
f=f(1);  % keep only first element
p=[];    % default output
Hf=mmgcf;
if isempty(Hf), return, end  % no figure exists, abort
if (f=='a')&length(findobj(0,'Type','axes'))==0
	return  % no axes to get box from
end
if length(findobj(0,'Type','figure'))==1
	figure(Hf)  % bring only figure forward
end

key=waitforbuttonpress; % user chooses a figure and axes
if key  % key on keyboard pressed
	return  % user-chosen abort
else    % figure selected
	Hf=mmgcf;
	Ha=mmgca;
	if f=='a'
		if isempty(Ha)
			return  % no axes exists
		elseif any(get(Ha,'View')~=[0 90])
			return  % abort since not 2-D
		end
	end
	
	if f=='a',cap=get(Ha,'CurrentPoint');end % get first axes point
	cfp=get(Hf,'CurrentPoint'); 	         % get first figure point

	rbbox([cfp 0 0],cfp)			         % drag rubberband box at cfp

	if f=='a',cap=[cap;get(Ha,'CurrentPoint')];end  % get second axes point
	cfp=[cfp;get(Hf,'CurrentPoint')];               % get second figure point
	
	if f=='f'  % return figure units
		p=[min(cfp) max(cfp)-min(cfp)];
	else       % return axes units
		xlim=get(Ha,'Xlim');
		ylim=get(Ha,'Ylim');
		[min(cap(1,:)); xlim(1)];
		xmin=max([min(cap(:,1)); xlim(1)]);
		xmax=min([max(cap(:,1)); xlim(2)]);	
		ymin=max([min(cap(:,2)); ylim(1)]);
		ymax=min([max(cap(:,2)); ylim(2)]);
		p=[xmin ymin xmax-xmin ymax-ymin];		
	end
end
