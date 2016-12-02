function mmshow(map)
%MMSHOW PCOLOR Colormap Display.
% MMSHOW uses pcolor to display the current colormap.
% MMSHOW(MAP) displays the colormap MAP.
% MMSHOW(MAP(N)) displays the colormap MAP having N elements.
%
% Examples: MMSHOW(hot)
%           MMSHOW(pink(30))

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 4/7/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

if nargin<1,
	Hf=mmgcf;
	if isempty(Hf),m=hsv(64);
	else,          m=get(Hf,'colormap');
	end
else
	m=map;
end

h=figure('units','normalized',...
         'position',[.5 .4 .3 .5],...
		 'Resize','off');
n=size(m,1);
pcolor([1:n;1:n]')
colormap(m)
set(gca,'Xtick',[])
ylabel('Colormap ROW Index')
title('Pcolor Display of ColorMap')
set(h,'NextPlot','new')

