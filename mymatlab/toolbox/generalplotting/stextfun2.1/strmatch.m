function m = strmatch(a,b)
%STRMATCH String matching.
% STRMATCH(A,B) returns 1 if B matches the first length(B) characters
% of A and 0 otherwise.

% Version 1.0, 31 January 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz
% schwarz@kodak.com

na = length(a);
nb = length(b);

if na >= nb
	m = all(a(1:nb) == b);
else
	m = 0;
end
