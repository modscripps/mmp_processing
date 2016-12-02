function output = stext(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,...
		a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28)
%STEXT Add Styled Text to the current plot.
% STEXT(X,Y,'string') adds the styled text in the quotes to location
% (X,Y) on the current axes in a manner similar to the TEXT function.
% Most of the same property/value pairs that can be used with TEXT will
% work with STEXT.  The styling information is embedded in the string in
% the form of commands which are preceeded by backslashes and terminated
% by a space, another backslash or a brace.  The commands control font,
% font size, font angle, font weight, color, superscript and subscript
% attributes.  A command is normally applied to all subsequent text
% except that temporary changes can be assigned inside curly braces.
% Font names and style changing commands can be abbreviated.  Also, many
% characters from the Symbol font can be produced by using backslash names
% (mostly the same names used in TeX).
%
%  Command Summary
%  \<font size>   \bigger   \larger   \smaller
%  \<font name>
%  \italic   \oblique   \light   \demi   \bold   \normal
%  ^{<text>}   _{<text>}
%  \black  \white  \red  \green  \blue  \cyan  \magenta  \yellow  \gray
%  \color{<R>,<G>,<B>}
%  \left{<x>}    \right{<x>}    \up{<x>}    \down{<x>}
%  \rleft{<x>}   \rright{<x>}   \rup{<x>}   \rdown{<x>}
%  \\    \{    \}    \^    \_
%
%  Character Summary
%  \<letter>, e.g., \alpha to produce lowercase Greek letters
%  \<Letter>, e.g., \Gamma to produce uppercase Greek letters
%  \forall          \pm        \aleph       \subset     \Leftrightarrow
%  \exists          \geq       \Im          \subseteq   \Leftarrow
%  \cong            \propto    \Re          \in         \Uparrow
%  \perp            \partial   \wp          \notin      \Rightarrow
%  \bot             \bullet    \otimes      \angle      \Downarrow
%  \leq             \div       \oplus       \nabla      \diamond
%  \infty           \neq       \emptyset    \surd       \langle
%  \leftrightarrow  \equiv     \cap         \cdot       \lceil
%  \leftarrow       \approx    \cup         \neg        \lfloor
%  \uparrow         \dots      \supset      \lnot       \rangle
%  \rightarrow      \vert      \supseteq    \land       \rceil
%  \downarrow       \Vert      \notsubset   \lor        \rfloor
%  \degrees                                                           
%
%  \therefore \prime \dprime \slash \mult \horiz
%
%  \grave \acute \ddot \hat \tilde \bar \breve \dot \check
%  \Grave \Acute \Ddot \Hat \Tilde \Bar \Breve \Dot \Check
%
%  \int{<a>,<b>}   \sum{<a>,<b>}   \prod{<a>,<b>}
%
% Examples:
%  STEXT(X,Y,'\18\times This text will be 18-point Times.')
%  STEXT(X,Y,'The word {\italic italic} will be in italics.')
%  STEXT(X,Y,'Einstein''s famous equation: E = mc^2')
%  STEXT(X,Y,'\18\times The resistance is 12 k\Omega.')
%
%  STEXT(X,Y,Z,'string') adds text in 3-D coordinates.
%
% Because of the way styled text objects are created, it is necessary to
% reposition them using FIXSTEXT when a figure is resized or the axes
% are changed (including changing the view in 3-D).  Also, they
% must be printed with PRINTSTO.
%
% STEXT returns a handle to an STEXT object.  STEXT objects are
% children of AXES objects.
%
% The X,Y pair (X,Y,Z triple for 3-D) can be followed by 
% parameter/value pairs to specify additional properties of the text.
% The X,Y pair (X,Y,Z triple for 3-D) can be omitted entirely, and
% all properties specified using parameter/value pairs.
%
% See also SXLABEL, SYLABEL, SZLABEL, STITLE, DELSTEXT, PRINTSTO,
% SETSTEXT, FIXSTEXT and the accompanying README document.

% Requires functions CMDMATCH and GETCARGS.
% Requires MATLAB Version 4.2 or greater.

% Version 2.0, 24 July 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz.  All rights reserved.
% schwarz@kodak.com

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
	if isstr(a1)
		for i = 1:nargin
			textCmd = [textCmd,'a',num2str(i),','];
		end
	else
		textCmd = [textCmd,'''Position'',[a1,a2],''String'',a3,'];
		for i = 4:nargin
			textCmd = [textCmd,'a',num2str(i),','];
		end
	end
	textCmd(length(textCmd)) = ')';
end
anchor = eval(textCmd);
set(anchor,'Tag','stext')

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

set(anchor,'Rotation',0,'Visible','off','Color','i')

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
		rotation = 90*round(value/90);
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
set(anchor,'Units',anchorUnits)
x0 = pos(1);
y0 = pos(2);
objList = [];
heightList = [];
xDistance = [];
first = 1;
diaWidth = [1/3,1/3,0.6,1/3,0.5,1/3,1/3,1/3,0,1/3];
terminators = setstr(32:255);
terminators(['0':'9','+-<=>','A':'Z','a':'z'] - 31) = [];

fontanglelist = str2mat('normal','italic','oblique');
fontnamelist = str2mat('times','helvetica','courier','symbol',...
		'avantgarde','bookman','newcenturyschlbk','palatino',...
		'zapfdingbats','zapfchancery');
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

% Initialize params: font angle = normal, font name = Helvetica,
% font size = default text font size, font weight = normal,
% color = default text color, x = 0, y = 0, mode = 0, nextX = 0.
params = [1;2;fontSize;2;get(0,'DefaultTextColor')';0;0;0;0];
fontIndex = max(find(fontName(1) == fontnamelist(:,1)));
if ~isempty(fontIndex), params(fn) = fontIndex; end

% Replace '\{', '\}', '\\', '\^' and '\_' with special codes.
str = strrep(str,'\{','{'+256);
str = strrep(str,'\\','\'+256);
str = strrep(str,'\^','^'+256);
str = strrep(str,'\_','_'+256);
str = strrep(str,'\}','}'+256);

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
		[cmd,str] = strtok(str,terminators);
		sp = '';
		if ~isempty(str), if str(1) == ' ', str(1) = []; sp = ' '; end, end
		
		% Font size specified in points.
		if all(cmd >= '0' & cmd <= '9')
			params(fs) = str2num(cmd);
				
		% Font angle and weight commands.
		elseif cmdmatch('normal',cmd)   params(fa) = 1; params(fw) = 2;
		elseif cmdmatch('italic',cmd),  params(fa) = 2;
		elseif cmdmatch('oblique',cmd), params(fa) = 3;
		elseif cmdmatch('light',cmd),   params(fw) = 1;
		elseif cmdmatch('demi',cmd),    params(fw) = 3;
		elseif cmdmatch('bold',cmd),    params(fw) = 4;
		
		% Font names.
		elseif cmdmatch('times',cmd),            params(fn) = 1;
		elseif cmdmatch('helvetica',cmd),        params(fn) = 2;
		elseif cmdmatch('courier',cmd),          params(fn) = 3;
		elseif cmdmatch('symbol',cmd),           params(fn) = 4;
		elseif cmdmatch('avantgarde',cmd),       params(fn) = 5;
		elseif cmdmatch('bookman',cmd),          params(fn) = 6;
		elseif cmdmatch('newcenturyschlbk',cmd), params(fn) = 7;
		elseif cmdmatch('palatino',cmd),         params(fn) = 8;
		elseif cmdmatch('zapfdingbats',cmd),     params(fn) = 9;
		elseif cmdmatch('zapfchancery',cmd),     params(fn) = 10;
		
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
			params([x,nextX]) = params([x,nextX]) - arg*params(fs);
		elseif cmdmatch('rright',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params([x,nextX]) = params([x,nextX]) + arg*params(fs);
		elseif cmdmatch('rup',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params(y) = params(y) + arg*params(fs);
		elseif cmdmatch('rdown',cmd)
			[arg,str] = strtok(str,'{}');
			str(1) = [];
			arg = sscanf(arg,'%f');
			params(y) = params(y) - arg*params(fs);
		
		% Integral.
		elseif strcmp('int',cmd)
			[arg1,arg2,str] = getcargs(str);
			str = ['{\rdown{.25}\larger\sym ',242,...
					'}_{\rleft{.1}\rdown{.3}{',arg1,...
					'}}^{\rright{.2}\rup{.6}{',arg2,'}}',sp,str];
		
		% Summation.
		elseif strcmp('sum',cmd)
			[arg1,arg2,str] = getcargs(str);
			str = ['{\rdown{.2}\larger\sym ',229,'}_{\rdown{.1}{',arg1,...
					'}}^{\rup{.2}{',arg2,'}}',sp,str];
		
		% Product.
		elseif strcmp('prod',cmd)
			[arg1,arg2,str] = getcargs(str);
			str = ['{\rdown{.2}\larger\sym ',213,'}_{\rdown{.1}{',arg1,...
					'}}^{\rup{.2}{',arg2,'}}',sp,str];
		
		% Lowercase Greek letters.
		elseif strcmp('alpha',cmd),      str = ['{\sym a}',sp,str];
		elseif strcmp('beta',cmd),       str = ['{\sym b}',sp,str];
		elseif strcmp('gamma',cmd),      str = ['{\sym g}',sp,str];
		elseif strcmp('delta',cmd),      str = ['{\sym d}',sp,str];
		elseif strcmp('epsilon',cmd),    str = ['{\sym e}',sp,str];
		elseif strcmp('varepsilon',cmd), str = ['{\sym e}',sp,str];
		elseif strcmp('zeta',cmd),       str = ['{\sym z}',sp,str];
		elseif strcmp('eta',cmd),        str = ['{\sym h}',sp,str];
		elseif strcmp('theta',cmd),      str = ['{\sym q}',sp,str];
		elseif strcmp('vartheta',cmd),   str = ['{\sym J}',sp,str];
		elseif strcmp('iota',cmd),       str = ['{\sym i}',sp,str];
		elseif strcmp('kappa',cmd),      str = ['{\sym k}',sp,str];
		elseif strcmp('lambda',cmd),     str = ['{\sym l}',sp,str];
		elseif strcmp('mu',cmd),         str = ['{\sym m}',sp,str];
		elseif strcmp('nu',cmd),         str = ['{\sym n}',sp,str];
		elseif strcmp('xi',cmd),         str = ['{\sym x}',sp,str];
		elseif strcmp('pi',cmd),         str = ['{\sym p}',sp,str];
		elseif strcmp('varpi',cmd),      str = ['{\sym v}',sp,str];
		elseif strcmp('rho',cmd),        str = ['{\sym r}',sp,str];
		elseif strcmp('varrho',cmd),     str = ['{\sym r}',sp,str];
		elseif strcmp('sigma',cmd),      str = ['{\sym s}',sp,str];
		elseif strcmp('varsigma',cmd),   str = ['{\sym V}',sp,str];
		elseif strcmp('tau',cmd),        str = ['{\sym t}',sp,str];
		elseif strcmp('upsilon',cmd),    str = ['{\sym u}',sp,str];
		elseif strcmp('phi',cmd),        str = ['{\sym f}',sp,str];
		elseif strcmp('varphi',cmd),     str = ['{\sym j}',sp,str];
		elseif strcmp('chi',cmd),        str = ['{\sym c}',sp,str];
		elseif strcmp('psi',cmd),        str = ['{\sym y}',sp,str];
		elseif strcmp('omega',cmd),      str = ['{\sym w}',sp,str];
		
		% Uppercase Greek letters.
		elseif strcmp('Gamma',cmd),      str = ['{\sym G}',sp,str];
		elseif strcmp('Delta',cmd),      str = ['{\sym D}',sp,str];
		elseif strcmp('Theta',cmd),      str = ['{\sym Q}',sp,str];
		elseif strcmp('Lambda',cmd),     str = ['{\sym L}',sp,str];
		elseif strcmp('Xi',cmd),         str = ['{\sym X}',sp,str];
		elseif strcmp('Pi',cmd),         str = ['{\sym P}',sp,str];
		elseif strcmp('Sigma',cmd),      str = ['{\sym S}',sp,str];
		elseif strcmp('Upsilon',cmd),    str = ['{\sym ',161,'}',sp,str];
		elseif strcmp('varUpsilon',cmd), str = ['{\sym U}',sp,str];
		elseif strcmp('Phi',cmd),        str = ['{\sym F}',sp,str];
		elseif strcmp('Psi',cmd),        str = ['{\sym Y}',sp,str];
		elseif strcmp('Omega',cmd),      str = ['{\sym W}',sp,str];
		
		% Other TeX characters.
		elseif strcmp('forall',cmd),         str = ['{\sym ',34,'}',sp,str];
		elseif strcmp('exists',cmd),         str = ['{\sym ',36,'}',sp,str];
		elseif strcmp('cong',cmd),           str = ['{\sym ',64,'}',sp,str];
		elseif strcmp('perp',cmd),           str = ['{\sym ',350,'}',sp,str];
		elseif strcmp('bot',cmd),            str = ['{\sym ',350,'}',sp,str];
		elseif strcmp('leq',cmd),            str = ['{\sym ',163,'}',sp,str];
		elseif strcmp('infty',cmd),          str = ['{\sym ',165,'}',sp,str];
		elseif strcmp('leftrightarrow',cmd), str = ['{\sym ',171,'}',sp,str];
		elseif strcmp('leftarrow',cmd),      str = ['{\sym ',172,'}',sp,str];
		elseif strcmp('uparrow',cmd),        str = ['{\sym ',173,'}',sp,str];
		elseif strcmp('rightarrow',cmd),     str = ['{\sym ',174,'}',sp,str];
		elseif strcmp('downarrow',cmd),      str = ['{\sym ',175,'}',sp,str];
		elseif strcmp('degrees',cmd),        str = ['{\sym ',176,'}',sp,str];
		elseif strcmp('pm',cmd),             str = ['{\sym ',177,'}',sp,str];
		elseif strcmp('geq',cmd),            str = ['{\sym ',179,'}',sp,str];
		elseif strcmp('propto',cmd),         str = ['{\sym ',181,'}',sp,str];
		elseif strcmp('partial',cmd),        str = ['{\sym ',182,'}',sp,str];
		elseif strcmp('bullet',cmd),         str = ['{\sym ',183,'}',sp,str];
		elseif strcmp('div',cmd),            str = ['{\sym ',184,'}',sp,str];
		elseif strcmp('neq',cmd),            str = ['{\sym ',185,'}',sp,str];
		elseif strcmp('equiv',cmd),          str = ['{\sym ',186,'}',sp,str];
		elseif strcmp('approx',cmd),         str = ['{\sym ',187,'}',sp,str];
		elseif strcmp('dots',cmd),           str = ['{\sym ',188,'}',sp,str];
		elseif strcmp('aleph',cmd),          str = ['{\sym ',192,'}',sp,str];
		elseif strcmp('Im',cmd),             str = ['{\sym ',193,'}',sp,str];
		elseif strcmp('Re',cmd),             str = ['{\sym ',194,'}',sp,str];
		elseif strcmp('wp',cmd),             str = ['{\sym ',195,'}',sp,str];
		elseif strcmp('otimes',cmd),         str = ['{\sym ',196,'}',sp,str];
		elseif strcmp('oplus',cmd),          str = ['{\sym ',197,'}',sp,str];
		elseif strcmp('emptyset',cmd),       str = ['{\sym ',198,'}',sp,str];
		elseif strcmp('cap',cmd),            str = ['{\sym ',199,'}',sp,str];
		elseif strcmp('cup',cmd),            str = ['{\sym ',200,'}',sp,str];
		elseif strcmp('supset',cmd),         str = ['{\sym ',201,'}',sp,str];
		elseif strcmp('supseteq',cmd),       str = ['{\sym ',202,'}',sp,str];
		elseif strcmp('notsubset',cmd),      str = ['{\sym ',203,'}',sp,str];
		elseif strcmp('subset',cmd),         str = ['{\sym ',204,'}',sp,str];
		elseif strcmp('subseteq',cmd),       str = ['{\sym ',205,'}',sp,str];
		elseif strcmp('in',cmd),             str = ['{\sym ',206,'}',sp,str];
		elseif strcmp('notin',cmd),          str = ['{\sym ',207,'}',sp,str];
		elseif strcmp('angle',cmd),          str = ['{\sym ',208,'}',sp,str];
		elseif strcmp('nabla',cmd),          str = ['{\sym ',209,'}',sp,str];
		elseif strcmp('surd',cmd),           str = ['{\sym ',214,'}',sp,str];
		elseif strcmp('cdot',cmd),           str = ['{\sym ',215,'}',sp,str];
		elseif strcmp('neg',cmd),            str = ['{\sym ',216,'}',sp,str];
		elseif strcmp('lnot',cmd),           str = ['{\sym ',216,'}',sp,str];
		elseif strcmp('land',cmd),           str = ['{\sym ',217,'}',sp,str];
		elseif strcmp('lor',cmd),            str = ['{\sym ',218,'}',sp,str];
		elseif strcmp('Leftrightarrow',cmd), str = ['{\sym ',219,'}',sp,str];
		elseif strcmp('Leftarrow',cmd),      str = ['{\sym ',220,'}',sp,str];
		elseif strcmp('Uparrow',cmd),        str = ['{\sym ',221,'}',sp,str];
		elseif strcmp('Rightarrow',cmd),     str = ['{\sym ',222,'}',sp,str];
		elseif strcmp('Downarrow',cmd),      str = ['{\sym ',223,'}',sp,str];
		elseif strcmp('diamond',cmd),        str = ['{\sym ',224,'}',sp,str];
		elseif strcmp('langle',cmd),         str = ['{\sym ',225,'}',sp,str];
		elseif strcmp('lceil',cmd),          str = ['{\sym ',233,'}',sp,str];
		elseif strcmp('lfloor',cmd),         str = ['{\sym ',235,'}',sp,str];
		elseif strcmp('vert',cmd),           str = ['{\sym ',239,'}',sp,str];
		elseif strcmp('rangle',cmd),         str = ['{\sym ',241,'}',sp,str];
		elseif strcmp('rceil',cmd),          str = ['{\sym ',249,'}',sp,str];
		elseif strcmp('rfloor',cmd),         str = ['{\sym ',251,'}',sp,str];

		elseif strcmp('Vert',cmd),     str = ['{\sym ',[247,231],'}',sp,str];
		
		% Non-TeX characters and TeX-like constructs that don't work quite
		% like they do in TeX.
		elseif strcmp('+',cmd),         str = ['{\sym +}',sp,str];
		elseif strcmp('-',cmd),         str = ['{\sym -}',sp,str];
		elseif strcmp('=',cmd),         str = ['{\sym =}',sp,str];
		elseif strcmp('>',cmd),         str = ['{\sym >}',sp,str];
		elseif strcmp('<',cmd),         str = ['{\sym <}',sp,str];
		elseif strcmp('therefore',cmd), str = ['{\sym ',348,'}',sp,str];
		elseif strcmp('prime',cmd),     str = ['{\sym ',162,'}',sp,str];
		elseif strcmp('slash',cmd),     str = ['{\sym ',164,'}',sp,str];
		elseif strcmp('dprime',cmd),    str = ['{\sym ',178,'}',sp,str];
		elseif strcmp('mult',cmd),      str = ['{\sym ',180,'}',sp,str];
		elseif strcmp('horiz',cmd),     str = ['{\sym ',190,'}',sp,str];
		
		% Diacritics.
		elseif strcmp('grave',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',96,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('acute',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',171,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('ddot',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',172,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('hat',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',246,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('tilde',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',247,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('bar',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',248,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('breve',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',249,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('dot',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',250,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('check',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\left{',num2str(lr(1)),'}',255,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('Grave',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',96,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('Acute',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',171,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('Ddot',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',172,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('Hat',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',246,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('Tilde',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',247,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('Bar',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',248,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('Breve',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',249,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('Dot',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',250,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
		elseif strcmp('Check',cmd)
			lr = [width,params(fs)*diaWidth(params(fn))]*[1 1;1 -1]/2;
			str = ['{\rup{.2}\left{',num2str(lr(1)),'}',255,...
					'\right{',num2str(lr(2)),'}}',sp,str];
		
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
		
		% Define a new text object and add it to the list.  Notice that
		% a space is added to the string.  This is removed later and the
		% reason for it is explained below.
		newObj = text('Position',[params(x),params(y)],...
				'String',              [newStr,' '],...
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
		objList = [objList,newObj];
		heightList = [heightList,params(y)];
		xDistance = [xDistance,params(x)];
		
		% The extra space:  It seems that on some platforms there is a lot
		% of space at the end of the last character in a text object.  To
		% compensate, I add a space (chosen arbitrarily) to the end of the
		% desired string, get the width (third element of the extent), set the
		% string to just a space, get the width again, and finally set the
		% string to what it should be.  I then calculate the correct width of
		% the text object as the difference between the two widths.
		exStrSpace = get(newObj,'Extent');
		set(newObj,'String',' ')
		exSpace = get(newObj,'Extent');
		set(newObj,'String',newStr);
		width = exStrSpace(3) - exSpace(3);
		params(nextX) = params(x) + width;
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
			set(anchor,'Units',anchorUnits,'VerticalAlignment',vertAlign)
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
