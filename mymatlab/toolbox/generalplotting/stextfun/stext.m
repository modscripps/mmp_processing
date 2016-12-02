function output = stext(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,...
		a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28)
%STEXT Add Styled Text to the current plot.
%	STEXT(X,Y,'string') adds the styled text in the quotes to location
%	(X,Y) on the current axes in a manner similar to the TEXT function.
%	Most of the same property/value pairs that can be used with TEXT
%	will work with STEXT.  The styling information is embedded in the
%	string in the form of commands which are preceeded by backslashes
%	and terminated by a space, another backslash or a brace.  The
%	commands control font, font size, font angle, font weight, color,
%	superscript and subscript attributes.  A command is normally
%	applied to all subsequent text except that temporary changes can be
%	assigned inside curly braces. Font names and style changing
%	commands can be abbreviated.  Also, many characters from the Symbol
%	font can be produced by using backslash names (mostly the same
%	names used in LaTeX).
%
%	Command Summary
%	\<font size>   \bigger   \larger   \smaller
%	\<font name>
%	\italic   \oblique   \light   \demi   \bold   \normal
%	^{<text>}   _{<text>}
%	\black  \white  \red  \green  \blue  \cyan  \magenta  \yellow  \gray
%	\color{<R>,<G>,<B>}
%	\left{<x>}    \right{<x>}    \up{<x>}    \down{<x>}
%	\rleft{<x>}   \rright{<x>}   \rup{<x>}   \rdown{<x>}
%	\\    \{    \}    \^    \_    \=    \+    \-    \<    \<    \#{}
%
%	Character Summary
%	\<letter>, e.g., \alpha to produce lowercase Greek letters
%	\<Letter>, e.g., \Gamma to produce uppercase Greek letters
%	\forall          \pm        \aleph       \subset     \Leftrightarrow
%	\exists          \geq       \Im          \subseteq   \Leftarrow
%	\cong            \propto    \Re          \in         \Uparrow
%	\perp            \partial   \wp          \notin      \Rightarrow
%	\bot             \bullet    \otimes      \angle      \Downarrow
%	\leq             \div       \oplus       \nabla      \diamond
%	\infty           \neq       \emptyset    \surd       \langle
%	\leftrightarrow  \equiv     \cap         \cdot       \lceil
%	\leftarrow       \approx    \cup         \neg        \lfloor
%	\uparrow         \dots      \supset      \lnot       \rangle
%	\rightarrow      \vert      \supseteq    \land       \rceil
%	\downarrow       \Vert      \notsubset   \lor        \rfloor
%	\degrees                                                           
%
%	\therefore \prime \dprime \slash \mult \horiz
%
%	\grave \acute \ddot \hat \tilde \bar \breve \dot \check
%	\Grave \Acute \Ddot \Hat \Tilde \Bar \Breve \Dot \Check
%
%	\int{<a>}{<b>}    \sum{<a>}{<b>}    \prod{<a>}{<b>}
%	\frac{<x>}{<y>}   \sqrt{<x>}        \root{<n>}{<x>}
%
%	Examples:
%		STEXT(X,Y,'\18\times This text will be 18-point Times.')
%		STEXT(X,Y,'The word {\italic italic} will be in italics.')
%		STEXT(X,Y,'Einstein''s famous equation: E = mc^2')
%		STEXT(X,Y,'\18\times The resistance is 12 k\Omega.')
%
%	STEXT(X,Y,Z,'string') adds text in 3-D coordinates.
%
%	Because of the way styled text objects are created, it is necessary
%	to reposition them using FIXSTEXT when a figure is resized or the
%	axes are changed (including changing the view in 3-D).  Also, they
%	must be printed with PRINTSTO.
%
%	STEXT returns a handle to an STEXT object.  STEXT objects are
%	children of AXES objects.
%
%	The X,Y pair (X,Y,Z triple for 3-D) can be followed by
%	parameter/value pairs to specify additional properties of the text.
%	The X,Y pair (X,Y,Z triple for 3-D) can be omitted entirely, and
%	all properties specified using parameter/value pairs.
%
%	See also SXLABEL, SYLABEL, SZLABEL, STITLE, DELSTEXT, PRINTSTO,
%	SETSTEXT, FIXSTEXT and the accompanying README document.

%	Requires functions CMDMATCH, GETCARGS and MAKESTFM and MAT-file
%	STFM.MAT or the text version STFM.TXT.
%	Requires MATLAB Version 4.2 or greater.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

% Define gFONT_METRICS, gKERNING_DATA, gENCODING, gACCENTS and gENC_SEL
% as global variables (operating as static variables) so we only have
% to load them the first time stext is run.
global gFONT_METRICS gKERNING_DATA gENCODING gACCENTS gENC_SEL
if length(gFONT_METRICS) == 0
	stextfun = which('stext');
	stextfun((length(stextfun) - 6):length(stextfun)) = [];
	% If MAT-file exists then load it, otherwise load data from text file
	% and create MAT-file (which is faster to load) for future use.
	if exist([stextfun,'stfm.mat']) == 2
		load([stextfun,'stfm.mat'])
	else
		[gFONT_METRICS,gKERNING_DATA,gENCODING,gACCENTS,gENC_SEL] = ...
				readstfm;
		
		savedir = stextfun;
		tempfid = fopen([savedir,'stfm.mat'],'w');
		if tempfid == -1
			savedir = [pwd,stextfun(length(stextfun))];
		else
			fclose(tempfid);
			delete([savedir,'stfm.mat'])
		end
		save([savedir,'stfm.mat'],'gFONT_METRICS','gKERNING_DATA',...
				'gENCODING','gACCENTS','gENC_SEL')
		if tempfid == -1
			fprintf('Unable to save font metrics MAT-file\n')
			fprintf('\t%s\n\n',[stextfun,'stfm.mat'])
			fprintf('File saved as\n\t%s\n\n',[savedir,'stfm.mat'])
			fprintf('For faster operation and to avoid seeing this ')
			fprintf('message, have\nyour system administrator move this ')
			fprintf('file to the directory\n\t%s\n',stextfun)
		end
	end
end
% Determine encoding selector, es, depending on platform.
if gENC_SEL == 0
	comp = computer;
	if cmdmatch(comp,'MAC')
		es = 3;
	elseif cmdmatch(comp,'PC')
		es = 4;
	else
		es = 5;
	end
else
	es = gENC_SEL;
end
nacc = length(gACCENTS);
accents = 32*ones(1,nacc);
for i = 1:nacc
	loc = find(gENCODING(:,es) == gACCENTS(i));
	if ~isempty(loc)
		accents(i) = max(loc) - 1;
	end
end

% Figure out what the input arguments are.
if nargin >= 4
	flags = [isstr(a1),isstr(a2),isstr(a3),isstr(a4)];
elseif nargin == 3
	flags = [isstr(a1),isstr(a2),isstr(a3),-1];
elseif nargin == 2
	flags = [isstr(a1),isstr(a2),-1,-1];
elseif nargin == 1
	error('Not enough input arguments.')
else
	flags = [-1,-1,-1,-1];
end

% From flags, determine which argument is the first property name
% and how many property/value pairs are present.
if all(flags == [0 0 0 1])
	firstOpt = 5;
	numOptions = (nargin - 4)/2;
elseif all(flags == [0 0 1 1])
	firstOpt = 4;
	numOptions = (nargin - 3)/2;
elseif all(flags == [0 0 1 -1])
	firstOpt = 4;
	numOptions = 0;
elseif flags(1) == 1
	firstOpt = 1;
	numOptions = nargin/2;
elseif all(flags == -1)
	numOptions = 0;
else
	error('Incorrect property/value pairs.')
end

% Build initial text command.
if nargin == 0
	textCmd = 'text';
else
	textCmd = 'text(';
	if firstOpt == 4
		textCmd = [textCmd,'''Position'',[a1,a2],''String'',a3,'];
	elseif firstOpt == 5
		textCmd = [textCmd,'''Position'',[a1,a2,a3],''String'',a4,'];
	end
	for i = firstOpt:nargin
		textCmd = [textCmd,sprintf('a%d,',i)];
	end
	textCmd(length(textCmd)) = ')';
end
anchor = eval(textCmd);
set(anchor,'Tag','stext')
ver5 = cmdmatch(version,'5');
if ver5, set(anchor,'Interpreter','none'), end

% Get default values.
str           = get(anchor,'String');
anchorPos     = get(anchor,'Position');
horizAlign    = get(anchor,'HorizontalAlignment');
vertAlign     = get(anchor,'VerticalAlignment');
anchorUnits   = get(anchor,'Units');
rotation      = get(anchor,'Rotation');
eraseMode     = get(anchor,'EraseMode');
buttonDownFcn = get(anchor,'ButtonDownFcn');
clipping      = get(anchor,'Clipping');
interruptible = get(anchor,'Interruptible');
fontSize      = get(anchor,'FontSize');
fontName      = lower(get(anchor,'FontName'));
visible       = get(anchor,'Visible');

set(anchor,'Rotation',0,'Visible','off')

% Process property/value pairs.
for i = 1:numOptions
	property = eval(['a',num2str(firstOpt + 2*(i-1))]);
	value = eval(['a',num2str(firstOpt + 2*(i-1) + 1)]);
	
	% Convert property and value (if it's a string) to lower case.
	% This code is significantly simpler and faster than lower.m, but
	% sufficient for our purposes.
	upperCase = property >= 'A' & property <= 'Z';
	property(upperCase) = setstr(property(upperCase) + ('a' - 'A'));
	if isstr(value) & ~cmdmatch('string',property)
		upperCase = value >= 'A' & value <= 'Z';
		value(upperCase) = setstr(value(upperCase) + ('a' - 'A'));
	end
	
	% HorizontalAlignment: [ {left} | center | right ]
	if cmdmatch('horizontalalignment',property)
		horizAlign = value;
		set(anchor,'HorizontalAlignment',value)
	
	% VerticalAlignment: [ top | cap | {middle} | baseline | bottom ]
	elseif cmdmatch('verticalalignment',property)
		vertAlign = value;
		set(anchor,'VerticalAlignment',value)
	
	% Units: [ inches | centimeters | normalized | points | pixels | {data} ]
	elseif cmdmatch('units',property)
		anchorUnits = value;
		set(anchor,'Units',value)
		anchorPos = get(anchor,'Position');
	
	% Position
	elseif cmdmatch('position',property)
		anchorPos = value;
		set(anchor,'Position',value)
		xin = value(1);
		yin = value(2);
	
	% Rotation
	elseif cmdmatch('rotation',property)
		rotation = value;
		rotation = rotation - floor(rotation/360)*360;
	
	% String
	elseif cmdmatch('string',property)
		str = value;
		set(anchor,'String',value)
	
	% EraseMode
	elseif cmdmatch('erasemode',property)
		eraseMode = value;
		set(anchor,'EraseMode',value)
	
	% ButtonDownFcn
	elseif cmdmatch('buttondownfcn',property)
		buttonDownFcn = value;
		set(anchor,'ButtonDownFcn',value)
	
	% Clipping
	elseif cmdmatch('clipping',property)
		clipping = value;
		set(anchor,'Clipping',value)
	
	% Interruptible
	elseif cmdmatch('interruptible',property)
		interruptible = value;
		set(anchor,'Interruptible',value)
	
	% Visible
	elseif cmdmatch('visible',property)
		visible = value;
		set(anchor,'Visible',value)
	
	else
		delete(anchor)
		error('Invalid object property.')
	end
end


% Initialize some data.
set(anchor,'Units','points')
pos = get(anchor,'Position');
set(anchor,'Units',anchorUnits,'Position',anchorPos)
x0 = pos(1);
y0 = pos(2);
objList = [];
heightList = [];
xDistance = [];
first = 1;
termNoDigits = setstr(1:255);
termNoDigits(real('0'):real('9')) = [];
termNoAlpha = setstr(1:255);
termNoAlpha([real('A'):real('Z'),real('a'):real('z')]) = [];
xstack = [];
colLut = [1 1 3 3;2 2 4 4;2 2 4 4];
fm = [1 1 1 1 ; 2 2 2 2 ; 3:6 ; 7:10 ; 11:14 ; 15:18 ; 19:22 ; 23:26 ;...
		27:30 ; 31:34 ; 35 35 35 35];

fontanglelist = str2mat('normal','italic','oblique');
fontnamelist = str2mat('symbol','zapfdingbats','times','helvetica',...
		'palatino','courier','avantgarde','bookman',...
		'newcenturyschlbk','n helvetica narrow','zapfchancery');
fontweightlist = str2mat('light','normal','demi','bold');

% Initialize indexing parameters for "params" array.  fa = font angle,
% fn = font name, fs = font size, fw = font weight, cr,cg,cb = color rgb,
% x = x location, y = y location, mode is used for super- and subscripts,
% nextX = x location of next object.
fa = 1; fn = 2; fs = 3; fw = 4; cr = 5; cg = 6; cb = 7; x = 8; y = 9;
mode = 10; nextX = 11;

% params is a parameter stack.  The contents are indices into string
% matrices for font angle, name and weight and actual values for
% the others.

% Initialize params: font angle = normal, font name = default font,
% font size = default text font size, font weight = normal,
% color = default text color, x = 0, y = 0, mode = 0, nextX = 0.
params = [1;4;fontSize;2;get(0,'DefaultTextColor')';0;0;0;0];
fontIndex = max(find(fontName(1) == fontnamelist(:,1)));
if ~isempty(fontIndex), params(fn) = fontIndex; end

% Parse str looking for commands.
while ~isempty(str)
	if str(1) == '{'
		% Push a copy of the current parameters on the parameter stack.
		params = [params(:,1),params];
		params(mode) = 0;
		str(1) = [];
	elseif str(1) == '}'
		% Pop the parameter stack except for adjustments to the x values.
		if size(params,2) == 1
			delete(objList)
			delete(anchor)
			error('Unmatched braces.')
		end
		str(1) = [];
		params(nextX,2) = max(params(nextX),params(nextX,2));
		if params(mode,2) == 0
			params(x,2) = params(x);
		end
		if isempty(str)
			params(x,2) = params(x);
		else
			if str(1) ~= '^' & str(1) ~= '_'
				params(x,2) = params(x);
				params(mode,2) = 0;
			end
		end
		params(:,1) = [];
	elseif str(1) == '^'
		% Superscript
		params(mode) = params(mode) + 1;
		params = [params(:,1),params];
		params(mode) = 0;
		params(nextX) = params(x);
		params(y) = params(y) + params(fs)/3;
		params(fs) = params(fs)/sqrt(2);
		if str(2) == '{'
			str(1:2) = [];
		else
			str(1:2) = [str(2),'}'];
		end
	elseif str(1) == '_'
		% Subscript
		params(mode) = params(mode) + 2;
		params = [params(:,1),params];
		params(mode) = 0;
		params(nextX) = params(x);
		params(y) = params(y) - params(fs)/4;
		params(fs) = params(fs)/sqrt(2);
		if str(2) == '{'
			str(1:2) = [];
		else
			str(1:2) = [str(2),'}'];
		end
	elseif str(1) == '\'
		% Extract command.
		if all(str(2) ~= termNoAlpha)
			[cmd,str] = strtok(str,termNoAlpha);
			if length(str) > 1
				if str(1) == ' '
					nonSpace = min(find(str ~= ' '));
					if ~isempty(nonSpace)
						if all(str(nonSpace) ~= termNoAlpha)
							str(1) = [];
						end
					end
				end
			end
		elseif all(str(2) ~= termNoDigits)
			[cmd,str] = strtok(str,termNoDigits);
			if length(str) > 1
				if str(1) == ' '
					nonSpace = min(find(str ~= ' '));
					if ~isempty(nonSpace)
						if all(str(nonSpace) ~= termNoDigits)
							str(1) = [];
						end
					end
				end
			end
		else
			cmd = str(2);
			str(1:2) = [];
		end
		
		% Command is a space.
		if strcmp(' ',cmd)
			str = [' ',str];
		
		% Font size specified in points.
		elseif all(cmd >= '0' & cmd <= '9')
			params(fs) = sscanf(cmd,'%d');
				
		% Font angle and weight commands.
		elseif cmdmatch('normal',cmd),  params(fa) = 1; params(fw) = 2;
		elseif cmdmatch('italic',cmd),  params(fa) = 2;
		elseif cmdmatch('oblique',cmd), params(fa) = 3;
		elseif cmdmatch('light',cmd),   params(fw) = 1;
		elseif cmdmatch('demi',cmd),    params(fw) = 3;
		elseif cmdmatch('bold',cmd),    params(fw) = 4;
		
		% Font names.
		elseif cmdmatch('symbol',cmd),           params(fn) = 1;
		elseif cmdmatch('zapfdingbats',cmd),     params(fn) = 2;
		elseif cmdmatch('times',cmd),            params(fn) = 3;
		elseif cmdmatch('helvetica',cmd),        params(fn) = 4;
		elseif cmdmatch('palatino',cmd),         params(fn) = 5;
		elseif cmdmatch('courier',cmd),          params(fn) = 6;
		elseif cmdmatch('avantgarde',cmd),       params(fn) = 7;
		elseif cmdmatch('bookman',cmd),          params(fn) = 8;
		elseif cmdmatch('newcenturyschlbk',cmd), params(fn) = 9;
		elseif cmdmatch('narrow',cmd),           params(fn) = 10;
		elseif cmdmatch('zapfchancery',cmd),     params(fn) = 11;
		
		% Font size in sqrt(2) increments.
		elseif cmdmatch('bigger',cmd),  params(fs) = params(fs)*sqrt(2);
		elseif cmdmatch('larger',cmd),  params(fs) = params(fs)*sqrt(2);
		elseif cmdmatch('smaller',cmd), params(fs) = params(fs)/sqrt(2);
		
		% Colors.
		elseif cmdmatch('black',cmd),   params(cr:cb) = [0;0;0];
		elseif cmdmatch('white',cmd),   params(cr:cb) = [1;1;1];
		elseif cmdmatch('red',cmd),     params(cr:cb) = [1;0;0];
		elseif cmdmatch('green',cmd),   params(cr:cb) = [0;1;0];
		elseif cmdmatch('blue',cmd),    params(cr:cb) = [0;0;1];
		elseif cmdmatch('cyan',cmd),    params(cr:cb) = [0;1;1];
		elseif cmdmatch('magenta',cmd), params(cr:cb) = [1;0;1];
		elseif cmdmatch('yellow',cmd),  params(cr:cb) = [1;1;0];
		elseif cmdmatch('gray',cmd),    params(cr:cb) = [0.5;0.5;0.5];
		elseif cmdmatch('color',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			params(cr:cb) = sscanf(arg,'%f,%f,%f');
		
		% Absolute positioning in points.
		elseif cmdmatch('left',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params([x,nextX]) = params([x,nextX]) - arg;
		elseif cmdmatch('right',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params([x,nextX]) = params([x,nextX]) + arg;
		elseif cmdmatch('up',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params(y) = params(y) + arg;
		elseif cmdmatch('down',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params(y) = params(y) - arg;
		
		% Relative positioning in units of current font size.
		elseif cmdmatch('rleft',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params([x,nextX]) = params([x,nextX]) - arg*round(params(fs));
		elseif cmdmatch('rright',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params([x,nextX]) = params([x,nextX]) + arg*round(params(fs));
		elseif cmdmatch('rup',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params(y) = params(y) + arg*round(params(fs));
		elseif cmdmatch('rdown',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params(y) = params(y) - arg*round(params(fs));
		
		% Integral.
		elseif strcmp('int',cmd)
			[arg1,str] = getcargs(str);
			[arg2,str] = getcargs(str);
			str = ['{\rdown{.25}\larger\sym',242,...
					'}_{\rleft{.1}\rdown{.3}{',arg1,...
					'}}^{\rright{.2}\rup{.6}{',arg2,'}}',str];
		
		% Summation.
		elseif strcmp('sum',cmd)
			[arg1,str] = getcargs(str);
			[arg2,str] = getcargs(str);
			str = ['{\rdown{.2}\larger\sym',229,'}_{\rdown{.1}{',arg1,...
					'}}^{\rup{.2}{',arg2,'}}',str];
		
		% Product.
		elseif strcmp('prod',cmd)
			[arg1,str] = getcargs(str);
			[arg2,str] = getcargs(str);
			str = ['{\rdown{.2}\larger\sym',213,'}_{\rdown{.1}{',arg1,...
					'}}^{\rup{.2}{',arg2,'}}',str];
		
		% Square root.
		elseif strcmp('sqrt',cmd)
			[arg1,str] = getcargs(str);
			pfs = round(params(fs));
			nfs = sprintf('%d',pfs);
			nfn = deblank(fontnamelist(params(fn),:));
			if params(fn) == 11
				nfn = 'n helvetica narrow';
			end
			narg1 = ['\',nfs,'\',nfn,'{}',arg1];
			h1 = eval(['stext(0,0,narg1,''Units'',''points'',',...
					'''vert'',''base'')'],'-1');
			if h1 == -1
				delete(objList)
				delete(anchor)
				error(lasterr)
			end
			e1 = getstext(h1,'Extent');
			delstext(h1)
			rfs = ceil(e1(4)/0.955);
			ofs = 0.038*rfs + e1(2);
			exr = 0.2;
			sqrtwid = e1(3) + 2*exr*pfs;
			numex = sqrtwid/(rfs*0.5);
			numex1 = ceil(numex) - 1;
			jog = 0.5*rfs - (sqrtwid - numex1*0.5*rfs);
			exs = setstr(96*ones(1,numex1));
			x1 = e1(3) + exr*pfs - 0.5*rfs;
			x2 = exr*pfs;
			str = ['{\',num2str(rfs),'\up{',num2str(ofs),...
					'}\nor\sym',214,'\rleft{0.549}',exs,...
					'\left{',num2str(jog),'}',96,...
					'\left{',num2str(x1),'}}{',arg1,...
					'}\right{',num2str(x2),'}',str];
			
		% Root.
		elseif strcmp('root',cmd)
			[arg1,str] = getcargs(str);
			[arg2,str] = getcargs(str);
			pfs = round(params(fs));
			nfs = sprintf('%d',pfs);
			nfn = deblank(fontnamelist(params(fn),:));
			if params(fn) == 11
				nfn = 'n helvetica narrow';
			end
			narg2 = ['\',nfs,'\',nfn,'{}',arg2];
			h1 = eval(['stext(0,0,narg2,''Units'',''points'',',...
					'''vert'',''base'')'],'-1');
			if h1 == -1
				delete(objList)
				delete(anchor)
				error(lasterr)
			end
			e1 = getstext(h1,'Extent');
			delstext(h1)
			rfs = ceil(e1(4)/0.955);
			ofs = 0.038*rfs + e1(2);
			exr = 0.2;
			sqrtwid = e1(3) + 2*exr*pfs;
			numex = sqrtwid/(rfs*0.5);
			numex1 = ceil(numex) - 1;
			jog = 0.5*rfs - (sqrtwid - numex1*0.5*rfs);
			exs = setstr(96*ones(1,numex1));
			x1 = e1(3) + exr*pfs - 0.5*rfs;
			x2 = exr*pfs;
			pfs2 = round(pfs/2);
			str = ['{\',num2str(rfs),'\up{',num2str(ofs),...
					'}{\pushx\rup{0.56}\rright{0.17}\',...
					num2str(pfs2),'{}',arg1,...
					'\popx}\norm\sym',214,'\rleft{0.549}',...
					exs,'\left{',num2str(jog),'}',96,...
					'\left{',num2str(x1),'}}{',arg2,...
					'}\right{',num2str(x2),'}',str];
			
		% Fraction.
		elseif strcmp('frac',cmd)
			[arg1,str] = getcargs(str);
			[arg2,str] = getcargs(str);
			pfs = round(params(fs));
			nfs = sprintf('%d',pfs);
			nfn = deblank(fontnamelist(params(fn),:));
			if params(fn) == 11
				nfn = 'n helvetica narrow';
			end
			narg1 = ['\',nfs,'\',nfn,'{}',arg1];
			narg2 = ['\',nfs,'\',nfn,'{}',arg2];
			h1 = eval(['stext(0,0,narg1,''Units'',''points'',',...
					'''vert'',''base'')'],'-1');
			if h1 == -1
				delete(objList)
				delete(anchor)
				error(lasterr)
			end
			e1 = getstext(h1,'Extent');
			delstext(h1)
			h2 = eval(['stext(0,0,narg2,''Units'',''points'',',...
					'''vert'',''base'')'],'-1');
			if h2 == -1
				delete(objList)
				delete(anchor)
				error(lasterr)
			end
			e2 = getstext(h2,'Extent');
			delstext(h2)
			
			if e2(3) > e1(3)
				x1 = (e2(3) - e1(3))/2;
				x2 = -(x1 + e1(3));
				x3 = 0;
			else
				x1 = 0;
				x2 = -(e1(3) + e2(3))/2;
				x3 = (e1(3) - e2(3))/2;
			end
			y1 = pfs/3 - e1(2);
			y2 = -y1 - (e2(4) + e2(2)) + pfs/6;
			y3 = -(y1 + y2);
			
			exr = 0.1;
			fracwid = max(e1(3),e2(3)) + 2*exr*pfs;
			numu = fracwid/(pfs*0.5);
			numu1 = ceil(numu) - 1;
			jog = 0.5*pfs - (fracwid - numu1*0.5*pfs);
			unds = ('\_')';
			unds = unds(:,ones(numu1,1));
			unds = unds(:)';
			str = ['{\up{',num2str(y1),'}\right{',num2str(x1+exr*pfs),...
					'}{',arg1,'}\up{',num2str(y2),...
					'}\right{',num2str(x2),'}{',arg2,...
					'}\right{',num2str(x3),'}}{\left{',...
					num2str(fracwid-exr*pfs),'}\up{',...
					num2str(pfs*0.4385),'}\sym',unds,...
					'\left{',num2str(jog),'}\_}',str];
		
		% Lowercase Greek letters.
		elseif strcmp('alpha',cmd),      str = ['{\sym a}',str];
		elseif strcmp('beta',cmd),       str = ['{\sym b}',str];
		elseif strcmp('gamma',cmd),      str = ['{\sym g}',str];
		elseif strcmp('delta',cmd),      str = ['{\sym d}',str];
		elseif strcmp('epsilon',cmd),    str = ['{\sym e}',str];
		elseif strcmp('varepsilon',cmd), str = ['{\sym e}',str];
		elseif strcmp('zeta',cmd),       str = ['{\sym z}',str];
		elseif strcmp('eta',cmd),        str = ['{\sym h}',str];
		elseif strcmp('theta',cmd),      str = ['{\sym q}',str];
		elseif strcmp('vartheta',cmd),   str = ['{\sym J}',str];
		elseif strcmp('iota',cmd),       str = ['{\sym i}',str];
		elseif strcmp('kappa',cmd),      str = ['{\sym k}',str];
		elseif strcmp('lambda',cmd),     str = ['{\sym l}',str];
		elseif strcmp('mu',cmd),         str = ['{\sym m}',str];
		elseif strcmp('nu',cmd),         str = ['{\sym n}',str];
		elseif strcmp('xi',cmd),         str = ['{\sym x}',str];
		elseif strcmp('pi',cmd),         str = ['{\sym p}',str];
		elseif strcmp('varpi',cmd),      str = ['{\sym v}',str];
		elseif strcmp('rho',cmd),        str = ['{\sym r}',str];
		elseif strcmp('varrho',cmd),     str = ['{\sym r}',str];
		elseif strcmp('sigma',cmd),      str = ['{\sym s}',str];
		elseif strcmp('varsigma',cmd),   str = ['{\sym V}',str];
		elseif strcmp('tau',cmd),        str = ['{\sym t}',str];
		elseif strcmp('upsilon',cmd),    str = ['{\sym u}',str];
		elseif strcmp('phi',cmd),        str = ['{\sym f}',str];
		elseif strcmp('varphi',cmd),     str = ['{\sym j}',str];
		elseif strcmp('chi',cmd),        str = ['{\sym c}',str];
		elseif strcmp('psi',cmd),        str = ['{\sym y}',str];
		elseif strcmp('omega',cmd),      str = ['{\sym w}',str];
		
		% Uppercase Greek letters.
		elseif strcmp('Gamma',cmd),      str = ['{\sym G}',str];
		elseif strcmp('Delta',cmd),      str = ['{\sym D}',str];
		elseif strcmp('Theta',cmd),      str = ['{\sym Q}',str];
		elseif strcmp('Lambda',cmd),     str = ['{\sym L}',str];
		elseif strcmp('Xi',cmd),         str = ['{\sym X}',str];
		elseif strcmp('Pi',cmd),         str = ['{\sym P}',str];
		elseif strcmp('Sigma',cmd),      str = ['{\sym S}',str];
		elseif strcmp('Upsilon',cmd),    str = ['{\sym',161,'}',str];
		elseif strcmp('varUpsilon',cmd), str = ['{\sym U}',str];
		elseif strcmp('Phi',cmd),        str = ['{\sym F}',str];
		elseif strcmp('Psi',cmd),        str = ['{\sym Y}',str];
		elseif strcmp('Omega',cmd),      str = ['{\sym W}',str];
		
		% Other LaTeX characters.
		elseif strcmp('forall',cmd),         str = ['{\sym',34,'}',str];
		elseif strcmp('exists',cmd),         str = ['{\sym',36,'}',str];
		elseif strcmp('cong',cmd),           str = ['{\sym',64,'}',str];
		elseif strcmp('perp',cmd),           str = ['{\sym\^}',str];
		elseif strcmp('bot',cmd),            str = ['{\sym\^}',str];
		elseif strcmp('leq',cmd),            str = ['{\sym',163,'}',str];
		elseif strcmp('infty',cmd),          str = ['{\sym',165,'}',str];
		elseif strcmp('leftrightarrow',cmd), str = ['{\sym',171,'}',str];
		elseif strcmp('leftarrow',cmd),      str = ['{\sym',172,'}',str];
		elseif strcmp('uparrow',cmd),        str = ['{\sym',173,'}',str];
		elseif strcmp('rightarrow',cmd),     str = ['{\sym',174,'}',str];
		elseif strcmp('downarrow',cmd),      str = ['{\sym',175,'}',str];
		elseif strcmp('degrees',cmd),        str = ['{\sym',176,'}',str];
		elseif strcmp('pm',cmd),             str = ['{\sym',177,'}',str];
		elseif strcmp('geq',cmd),            str = ['{\sym',179,'}',str];
		elseif strcmp('propto',cmd),         str = ['{\sym',181,'}',str];
		elseif strcmp('partial',cmd),        str = ['{\sym',182,'}',str];
		elseif strcmp('bullet',cmd),         str = ['{\sym',183,'}',str];
		elseif strcmp('div',cmd),            str = ['{\sym',184,'}',str];
		elseif strcmp('neq',cmd),            str = ['{\sym',185,'}',str];
		elseif strcmp('equiv',cmd),          str = ['{\sym',186,'}',str];
		elseif strcmp('approx',cmd),         str = ['{\sym',187,'}',str];
		elseif strcmp('dots',cmd),           str = ['{\sym',188,'}',str];
		elseif strcmp('aleph',cmd),          str = ['{\sym',192,'}',str];
		elseif strcmp('Im',cmd),             str = ['{\sym',193,'}',str];
		elseif strcmp('Re',cmd),             str = ['{\sym',194,'}',str];
		elseif strcmp('wp',cmd),             str = ['{\sym',195,'}',str];
		elseif strcmp('otimes',cmd),         str = ['{\sym',196,'}',str];
		elseif strcmp('oplus',cmd),          str = ['{\sym',197,'}',str];
		elseif strcmp('emptyset',cmd),       str = ['{\sym',198,'}',str];
		elseif strcmp('cap',cmd),            str = ['{\sym',199,'}',str];
		elseif strcmp('cup',cmd),            str = ['{\sym',200,'}',str];
		elseif strcmp('supset',cmd),         str = ['{\sym',201,'}',str];
		elseif strcmp('supseteq',cmd),       str = ['{\sym',202,'}',str];
		elseif strcmp('notsubset',cmd),      str = ['{\sym',203,'}',str];
		elseif strcmp('subset',cmd),         str = ['{\sym',204,'}',str];
		elseif strcmp('subseteq',cmd),       str = ['{\sym',205,'}',str];
		elseif strcmp('in',cmd),             str = ['{\sym',206,'}',str];
		elseif strcmp('notin',cmd),          str = ['{\sym',207,'}',str];
		elseif strcmp('angle',cmd),          str = ['{\sym',208,'}',str];
		elseif strcmp('nabla',cmd),          str = ['{\sym',209,'}',str];
		elseif strcmp('surd',cmd),           str = ['{\sym',214,'}',str];
		elseif strcmp('cdot',cmd),           str = ['{\sym',215,'}',str];
		elseif strcmp('neg',cmd),            str = ['{\sym',216,'}',str];
		elseif strcmp('lnot',cmd),           str = ['{\sym',216,'}',str];
		elseif strcmp('land',cmd),           str = ['{\sym',217,'}',str];
		elseif strcmp('lor',cmd),            str = ['{\sym',218,'}',str];
		elseif strcmp('Leftrightarrow',cmd), str = ['{\sym',219,'}',str];
		elseif strcmp('Leftarrow',cmd),      str = ['{\sym',220,'}',str];
		elseif strcmp('Uparrow',cmd),        str = ['{\sym',221,'}',str];
		elseif strcmp('Rightarrow',cmd),     str = ['{\sym',222,'}',str];
		elseif strcmp('Downarrow',cmd),      str = ['{\sym',223,'}',str];
		elseif strcmp('diamond',cmd),        str = ['{\sym',224,'}',str];
		elseif strcmp('langle',cmd),         str = ['{\sym',225,'}',str];
		elseif strcmp('lceil',cmd),          str = ['{\sym',233,'}',str];
		elseif strcmp('lfloor',cmd),         str = ['{\sym',235,'}',str];
		elseif strcmp('vert',cmd),           str = ['{\sym',239,'}',str];
		elseif strcmp('rangle',cmd),         str = ['{\sym',241,'}',str];
		elseif strcmp('rceil',cmd),          str = ['{\sym',249,'}',str];
		elseif strcmp('rfloor',cmd),         str = ['{\sym',251,'}',str];
		elseif strcmp('AA',cmd),             str = [accents(10),str];
		elseif strcmp('ii',cmd),             str = [accents(11),str];
		
		elseif strcmp('Vert',cmd),     str = ['{\sym',[247,231],'}',str];
		
		elseif strcmp('{',cmd),              str = ['{' + 256,str];
		elseif strcmp('}',cmd),              str = ['}' + 256,str];
		elseif strcmp('\',cmd),              str = ['\' + 256,str];
		elseif strcmp('^',cmd),              str = ['^' + 256,str];
		elseif strcmp('_',cmd),              str = ['_' + 256,str];
		
		% Non-LaTeX characters and LaTeX-like constructs that don't work
		% quite like they do in LaTeX.
		elseif strcmp('+',cmd),         str = ['{\sym+}',str];
		elseif strcmp('-',cmd),         str = ['{\sym-}',str];
		elseif strcmp('=',cmd),         str = ['{\sym=}',str];
		elseif strcmp('>',cmd),         str = ['{\sym>}',str];
		elseif strcmp('<',cmd),         str = ['{\sym<}',str];
		elseif strcmp('|',cmd),         str = ['{\sym|}',str];
		elseif strcmp('therefore',cmd), str = ['{\sym\\}',str];
		elseif strcmp('prime',cmd),     str = ['{\sym',162,'}',str];
		elseif strcmp('slash',cmd),     str = ['{\sym',164,'}',str];
		elseif strcmp('dprime',cmd),    str = ['{\sym',178,'}',str];
		elseif strcmp('mult',cmd),      str = ['{\sym',180,'}',str];
		elseif strcmp('horiz',cmd),     str = ['{\sym',190,'}',str];
		
		% Spaces.
		elseif strcmp('/',cmd),         str = ['\rright{0.07}',str];
		elseif strcmp(',',cmd),         str = ['\rright{0.125}',str];
		elseif strcmp(':',cmd),         str = ['\rright{0.1667}',str];
		elseif strcmp(';',cmd),         str = ['\rright{0.2083}',str];
		
		% ASCII code.
		elseif strcmp('#',cmd)
			[arg1,str] = getcargs(str);
			str = [setstr(sscanf(arg1,'%d')),str];
		
		% Diacritics.
		elseif strcmp('grave',cmd)
			accent = accents(1);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('acute',cmd)
			accent = accents(2);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('ddot',cmd)
			accent = accents(3);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('hat',cmd)
			accent = accents(4);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('tilde',cmd)
			accent = accents(5);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('bar',cmd)
			accent = accents(6);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('breve',cmd)
			accent = accents(7);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('dot',cmd)
			accent = accents(8);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('check',cmd)
			accent = accents(9);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('Grave',cmd)
			accent = accents(1);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('Acute',cmd)
			accent = accents(2);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('Ddot',cmd)
			accent = accents(3);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('Hat',cmd)
			accent = accents(4);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('Tilde',cmd)
			accent = accents(5);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('Bar',cmd)
			accent = accents(6);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('Breve',cmd)
			accent = accents(7);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('Dot',cmd)
			accent = accents(8);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('Check',cmd)
			accent = accents(9);
			ww = gFONT_METRICS(gENCODING(accent+1,es),fm(params(fn),...
					colLut(params(fa),params(fw))))*round(params(fs))/1000;
			lr = [lastWidth,ww]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',accent,...
					'\right{',num2str(lr(2)),'}}',str];
		
		elseif strcmp('pushx',cmd)
			xstack = [params([x;nextX]),xstack];
		
		elseif strcmp('popx',cmd)
			if size(xstack,2) < 1
				delete(objList)
				delete(anchor)
				error('Stack empty.')
			end
			params(x) = xstack(1);
			params(nextX) = xstack(2);
			xstack(:,1) = [];
		
		elseif strcmp('swapx',cmd)
			if size(xstack,2) < 2
				delete(objList)
				delete(anchor)
				error('Stack does not contain at least two items.')
			end
			temp = xstack(:,1);
			xstack(:,[1,2]) = xstack(:,[2,1]);
		
		else
			% Command is unknown.
			delete(objList)
			delete(anchor)
			error(['Unrecognized command: ',cmd])
		
		end
	else
		% str(1) is not one of '{}^_\' so it must be the beginning of text.
		params(x) = params(nextX);
		params(mode) = 0;
		[newStr,str] = strtok(str,'\{}^_');
		newStr = setstr(rem(newStr,256));
		newStr1 = newStr + 1;
		
		% Compute character widths.
		strLen = length(newStr);
		fmSel = fm(params(fn),colLut(params(fa),params(fw)));
		if fmSel > 2
			encSel = es;
		else
			encSel = fmSel;
		end
		fontOffset = 1000*(fmSel - 2);
		widths = gFONT_METRICS(gENCODING(newStr1,encSel),fmSel) * ...
				round(params(fs))/1000;
		lastWidth = widths(length(widths));
		
		% Compute kern correction, kc.
		kc = zeros(strLen-1,1);
		if fmSel > 2
			for k = 1:strLen-1
				kc(k) = gKERNING_DATA(fontOffset + gENCODING(newStr1(k),...
						encSel),gENCODING(newStr1(k+1),encSel));
			end
			kc = kc*round(params(fs))/1000;
		end
		
		xx = params(x) + cumsum([0;widths((1:strLen-1)') + kc]);
		yy = params(y(ones(strLen,1)));
		
		% Prepend invisible characters if Symbol italic or oblique.  This
		% can be detected in the PostScript file so that it can be modified
		% to produce slanted Symbol characters.
		if params(fn) == 1 & params(fa) > 1
			xx = [0;0;0;xx];
			yy = [0;0;0;yy];
			newStr = setstr([9,9,9,newStr]);
			strLen = length(newStr);
		end
		
		if strLen == 1
			newObj = text('Position',  [xx,yy],...
					'String',              newStr,...
					'FontAngle',           fontanglelist(params(fa),:),...
					'FontName',            deblank(fontnamelist(params(fn),:)),...
					'FontSize',            round(params(fs)),...
					'FontWeight',          fontweightlist(params(fw),:),...
					'Units',               'points',...
					'Rotation',            0,...
					'HorizontalAlignment', 'left',...
					'VerticalAlignment',   'baseline',...
					'Color',               params(cr:cb),...
					'EraseMode',           eraseMode,...
					'ButtonDownFcn',       buttonDownFcn,...
					'Clipping',            clipping,...
					'Interruptible',       interruptible,...
					'Visible',             visible);
		else
			newObj = text(xx,yy,newStr',...
					'FontAngle',           fontanglelist(params(fa),:),...
					'FontName',            deblank(fontnamelist(params(fn),:)),...
					'FontSize',            round(params(fs)),...
					'FontWeight',          fontweightlist(params(fw),:),...
					'Units',               'points',...
					'Rotation',            0,...
					'HorizontalAlignment', 'left',...
					'VerticalAlignment',   'baseline',...
					'Color',               params(cr:cb),...
					'EraseMode',           eraseMode,...
					'ButtonDownFcn',       buttonDownFcn,...
					'Clipping',            clipping,...
					'Interruptible',       interruptible,...
					'Visible',             visible);
		end
		if ver5, set(newObj,'Interpreter','none'), end
		objList = [objList,newObj'];
		heightList = [heightList,yy'];
		xDistance = [xDistance,xx'];
		params(nextX) = xx(strLen) + lastWidth;
		params(x) = params(nextX);
		
		% The vertical position of the styled text is based on the first
		% character of the text.
		if first
			set(anchor,'FontAngle',fontanglelist(params(fa),:),...
					'FontName',fontnamelist(params(fn),:),...
					'FontSize',round(params(fs)),...
					'FontWeight',fontweightlist(params(fw),:))
			set(anchor,'Units','points')
			ex1 = get(anchor,'Extent');
			set(anchor,'VerticalAlignment','baseline')
			ex2 = get(anchor,'Extent');
			set(anchor,'Units',anchorUnits,'Position',anchorPos,...
					'VerticalAlignment',vertAlign)
			hOffset = ex1(2) - ex2(2);
			first = 0;
		end
	end
end
totalWidth = params(nextX);
numSegments = length(objList);

% Compute new x and y locations for each text object based on
% justification and rotation.
r = rotation*pi/180;
if cmdmatch('left',horizAlign)
	t = 0;
elseif cmdmatch('center',horizAlign)
	t = totalWidth/2;
elseif cmdmatch('right',horizAlign)
	t = totalWidth;
end
xList = x0 + (xDistance - t)*cos(r) - (heightList + hOffset)*sin(r);
yList = y0 + (xDistance - t)*sin(r) + (heightList + hOffset)*cos(r);

for i = 1:numSegments
	set(objList(i),'Position',[xList(i),yList(i)],'Rotation',rotation);
end

% Anchor text object is invisible, but by setting the rotation we can
% use get(stext object handle).  UserData contains a type flag (0 =
% normal, 1 = x-label, 2 = y-label, 3 = z-label, 4 = title), the
% location of the anchor object in points and a list of the handles
% to the text objects that make up the styled text object.

set(anchor,'Rotation',rotation,'UserData',[0,x0,y0,objList])

if nargout == 1
	output = anchor;
end
