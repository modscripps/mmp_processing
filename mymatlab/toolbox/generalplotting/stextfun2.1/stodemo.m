function stodemo
%STODEMO Demonstrates some of the capabilities of STEXT.
% STODEMO will run the demo.
%
% See also STEXT, SXLABEL, SYLABEL, SZLABEL, STITLE, DELSTEXT, PRINTSTO,
% SETSTEXT, FIXSTEXT.

% Requires functions STEXT, SXLABEL, SYLABEL, STITLE, DELSTEXT.
% Requires MATLAB Version 4.2 or greater.

% Version 2.1, 8 September 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz.  All rights reserved.
% schwarz@kodak.com

%begin demo data
%\14\times Subscripts and superscripts: \Omega_1, s^2.
%\14\times The font size can be changed: \20 M\17 ATLAB
%\14\times Words can be emphasized with {\bold bold} and {\italic italics}.
%\14 Colors! {\red RED} {\green GREEN} {\blue BLUE} {\cyan CYAN} {\magenta MAGENTA} {\yellow YELLOW}
%\14 Backslash:\courier  A = B\\C;
%\14\times Braces: \{\}
%\14 Here is the Greek alphabet: {\symbol abgdezhqiklmnxoprstufcyw}
%\14\times{\italic E} \= {\italic mc}^2
%\18 A more complicated example:  \times {\i y} \= {\i e}^{\-{\i t}_{max}^2}
%\36\times {\i y} \= \sum{{\i i} \= 1,{\i N}}{\i x_i}
%\36\times {\i y} \= \sum{\rdown{.9}\rleft{1.5}{\i i} \= 1,\rleft{.85}\rup{.7}{\i N}}{\i x_i}
%end demo data

% Note: The last example above may require some tweaking of the shift
%       parameters to make it look right on your system.

% Open this file.
fid = fopen('stodemo.m');
if fid == -1
	error('This M-file must be named ''stodemo.m''')
end

% Clear the current figure and define the axes.
clf reset
axis([0 1 0 1])
set(gca,'Box','on')

% Skip lines until we find the beginning of the demo data.
while ~strcmp(fgetl(fid),'%begin demo data'), end

% Read demo data one line at a time, display the raw data and use it
% in stext.  Do this until the end of the data is read.
while 1
	str = fgetl(fid);
	if strcmp(str,'%end demo data'), break, end
	str(1) = '';
	t = text(0.02,0.7,str,'FontName','courier','FontSize',10);
	h = stext(0.02,0.5,str);
	pause
	delstext(h)
	delete(t)
end

% Close this file.
fclose(fid);

% Some more examples of stext.
stext(0.5,0.95,'\16\times {\ital Left} justified','Horiz','left')
stext(0.5,0.85,'\16\times {\ital Center} justified','Horiz','center')
stext(0.5,0.75,'\16\times {\ital Right} justified','Horiz','right')
line([0.5 0.5],[0 1])
drawnow

stext(0.1,0.6,'\16\times bottom','Vert','bottom','Horiz','center')
stext(0.3,0.6,'\16\times baseline','Vert','baseline','Horiz','center')
stext(0.5,0.6,'\16\times middle','Vert','middle','Horiz','center')
stext(0.7,0.6,'\16\times cap','Vert','cap','Horiz','center')
stext(0.9,0.6,'\16\times top','Vert','top','Horiz','center')
line([0 1],[0.6 0.6])
drawnow

stext(0.7,0.3,'\12\helv {\bold Left} justified','Horiz','left','Rot',90)
stext(0.75,0.3,'\12\helv {\bold Center} justified','Horiz','center','Rot',90)
stext(0.8,0.3,'\12\helv {\bold Right} justified','Horiz','right','Rot',90)
line([0.5 1],[0.3 0.3])
drawnow

stext(0.25,0.3,'\14\times   0 {\ital degrees}','Rot',0)
stext(0.25,0.3,'\14\times   90 {\ital degrees}','Rot',90)
stext(0.25,0.3,'\14\times   180 {\ital degrees}','Rot',180)
stext(0.25,0.3,'\14\times   270 {\ital degrees}','Rot',270)
line(0.25,0.3,'LineStyle','.','MarkerSize',24)
drawnow

sxlabel('\14\times Axis {\ital\red labels} can be styled, too!')
sylabel('\12\helvetica This label was created with {\courier\blue sylabel}.')
stitle('\16\helv {\red S}{\green T}{\blue E}{\mag X}{\cyan T} Demo')
