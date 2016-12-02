function wygiwys
%WYGIWYS Sets the position of the current figure for printing
%        WYGIWYS() changes the PaperPosition property of the
%        current figure to be the same as the actual dimensions
%        of the figure on the screen. If the figure is then
%        printed, it should appear the same size on the page
%        as on the screen.
%
%        See also WYSIWYG
%
%        [No Guarantees. M. Lubinski & S. Freeman]

%        11/07/94 Created by S. Freeman & M. Lubinski

% Get needed properties
cf=gcf;
fig_u  =get(cf,'Units');
pap_u  =get(cf,'PaperUnits');
pap_sz =get(cf,'PaperSize');

% Set PaperPosition property with correct units
set(cf,'Units',pap_u)
fig_pos=get(cf,'Position');
pap_pos = [(pap_sz(1:2)-fig_pos(3:4))/2 fig_pos(3:4)];
set(cf,'PaperPosition',pap_pos);

% Reset Units
set(cf,'Units',fig_u)
