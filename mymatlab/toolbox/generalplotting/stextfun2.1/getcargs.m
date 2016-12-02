function [a,b,str] = getcargs(str)
%GETCARGS Get arguments for stext commands.
% [A,STROUT] = GETCARGS(STR) parses STR to extract a part enclosed in
% curly braces and the remainder of the string.
%    Example:
%        >>STR = '{hello}there'
%        >>[A,STROUT] = GETCARGS(STR)
%        A =
%        hello
%        STROUT =
%        there
%
% [A,B,STR] = GETCARGS(STR) does the same thing for two arguments inside
% the brackets separated by a comma.

% Version 2.1, 8 September 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz.  All rights reserved.
% schwarz@kodak.com

i = cumsum( (str == '{') - (str == '}') );
firstZero = find(i == 0); firstZero = firstZero(1);
bothArgs = str(2:(firstZero - 1));
str(1:firstZero) = [];

if nargout == 2
	a = bothArgs;
	b = str;
else
	j = i(2:(firstZero - 1));
	c = find(bothArgs == ',' & j == 1);
	a = bothArgs(1:(c-1));
	b = bothArgs((c+1):length(bothArgs));
end
