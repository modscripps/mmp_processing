function out=mmcxy(arg)
%MMCXY Show x-y Coordinates Using Mouse.
% MMCXY places the x-y coordinates of the mouse in the
% lower left hand corner of the current 2-D figure window.
% When the mouse is clicked, the coordinates are erased.
% XY=MMCXY returns XY=[x,y] coordinates where mouse was clicked.
% XY=MMCXY returns XY=[] if a key press was used.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/30/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

global MMCXY_OUT
if ~nargin
	Hf=mmgcf;
	if isempty(Hf), error('No Figure Available.'),end
	Ha=findobj(Hf,'Type','axes');
	if isempty(Ha), error('No Axes in Current Figure.'),end
	
	Hu=uicontrol(Hf,'Style','text',...
					'units','pixels',...
					'Position',[1 1 140 15],...
					'HorizontalAlignment','left');
	set(Hf,	'Pointer','crossh',...
			'WindowButtonMotionFcn','mmcxy(''move'')',...
			'WindowButtonDownFcn','mmcxy(''end'')',...
			'Userdata',Hu)
	figure(Hf)  % bring figure forward
	if nargout  % must return x-y data
		key=waitforbuttonpress; % pause until mouse is pressed
		if key,
			out=[];         % return empty if aborted
			mmcxy('end')    % clean things up
		else
			out=MMCXY_OUT;  % now that move is complete return point
		end
		return
	end

elseif strcmp(arg,'move')  % mouse is moving in figure window
	cp=get(gca,'CurrentPoint');  % get current mouse position
	MMCXY_OUT=cp(1,1:2);
	xystr=sprintf('[%.3g, %.3g]',MMCXY_OUT);
	Hu=get(gcf,'Userdata');
	set(Hu,'String',xystr)  % put x-y coordinates in text box

elseif strcmp(arg,'end')  % mouse click occurred, clean things up
	Hu=get(gcf,'Userdata');
	delete(Hu)
	set(gcf,'Pointer','arrow',...
			'WindowButtonMotionFcn','',...
			'WindowButtonDownFcn','',...
			'Userdata',[])
end
