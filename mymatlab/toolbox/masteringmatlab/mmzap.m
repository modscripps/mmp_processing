function mmzap(arg)
%MMZAP Delete Graphics Object Using Mouse.
% MMZAP waits for a mouse click on an object in
% a figure window and deletes the object.
% MMZAP or MMZAP text erases text objects.
% MMZAP axes  erases axes objects.
% MMZAP line  erases line objects.
% MMZAP surf  erases surface objects.
% MMZAP patch  erases patch objects.
%
% Clicking on an object other than the selected type, or striking
% a key on the keyboard aborts the command.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/29/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

if nargin<1, arg='text'; end

Hf=mmgcf;
if isempty(Hf), error('No Figure Available.'), end
if length(findobj(0,'Type','figure'))==1
	figure(Hf) % bring only figure forward
end
key=waitforbuttonpress;
if key  % key on keyboard pressed
	return
else    % object selected
	object=gco;
	type=get(object,'Type');
	if all(type(1:4)==arg(1:4))
		delete(object)
	end
end
