function hf = maxfigure(varargin);
%updated 3/1/15 MMH
% now maximizes existing current figure
if nargin == 0
% hf = figure();
hf=gcf;
set(hf,'units','normalized','outerposition',[0 0 0.5 1]);
end
end