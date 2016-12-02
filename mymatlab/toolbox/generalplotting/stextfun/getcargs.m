function [arg,str] = getcargs(str)
%GETCARGS Get arguments for stext commands.
%	[ARG,STROUT] = GETCARGS(STR) parses STR to extract a part enclosed
%	in curly braces and the remainder of the string.
%		Example:
%			>>STR = '{hello}there'
%			>>[A,STROUT] = GETCARGS(STR)
%			A =
%			hello
%			STROUT =
%			there
%
%	See also STEXT.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

i = cumsum( (str == '{') - (str == '}') );
if i(1) ~= 1 | ~any(i == 0)
	error('Command argument not found.')
end
firstZero = min(find(i == 0));
arg = str(2:(firstZero - 1));
str(1:firstZero) = [];
