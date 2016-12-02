function h=mmtile(n)
%MMTILE Tile Figure Windows.
% MMTILE with no arguments, tiles the current figure windows
% and brings them to the foreground.
% Figure size is adjusted so that 4 figure windows fit on the screen.
% Figures are arranged in a clockwise fashion starting in the
% upper left corner of the display.
%
% MMTILE(N) makes tile N the current figure if it exists.
% Otherwise, the next tile is created for subsequent plotting.
%
% Tiled figure windows are titled TILE #1, TILE #2, TILE #3, TILE #4.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 3/23/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

HT=40;	% tile height fudge in pixels
WD=20;	% tile width fudge
% adjust the above as necessary to eliminate tile overlaps
% bigger fudge numbers increase gaps between tiles

Hf=sort(get(0,'Children'));	% get handles of current figures
nHf=length(Hf);
set(0,'Units','Pixels')		% set screen dimensions to pixels
sz=get(0,'Screensize');		% get screen size in pixels
tsz=0.9*sz(3:4);			% default tile area is almost whole monitor
if sz(4)>sz(3),				% if portrait monitor
	tsz(2)=.75*tsz(1);		% take a landscape chunk
end
tsz=min(tsz,[920 690]);		% hold tile area on large screens to 920 by 690
tl(1,1)=sz(3)-tsz(1)+1;		% left side of left tiles
tl(2,1)=tl(1,1)+tsz(1)/2;	% left side of right tiles
tb(1,1)=sz(4)-tsz(2)+1;		% bottom of bottom tiles
tb(2,1)=tb(1,1)+tsz(2)/2;	% bottom of top tiles

tpos=zeros(4);				% matrix holding tile position vectors
tpos(:,1)=tl([1 2 2 1],1);			% left sides
tpos(:,2)=tb([2 2 1 1],1);			% bottoms
tpos(:,3)=(tsz(1)/2-WD)*ones(4,1);	% widths
tpos(:,4)=(tsz(2)/2-HT)*ones(4,1);	% heights
tpos=fix(tpos);						% make sure pixel positions are integers

if nargin==0				% tile figures as needed
	for i=1:min(nHf,4)
		set(Hf(i),'Units','pixels')
		if any(get(Hf(i),'Position')~=tpos(i,:))
			set(Hf(i),	'Position',tpos(i,:),...
						'NumberTitle','off',...
						'Name',['TILE #' int2str(i)])
		end
		figure(Hf(i))
	end
else  						% go to tile N or create it
	n=rem(abs(n)-1,4)+1;	% N must be between 1 and 4
	if n<=nHf				% tile N exists, make it current
		figure(Hf(n))
	else					% tile N does not exist, create next one
		n=nHf+1;
		figure( 'Position',tpos(n,:),...
				'NumberTitle','off',...
				'Name',['TILE #' int2str(n)])
				
	end
end
