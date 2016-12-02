function m = cmdmatch(a,b)
%CMDMATCH String matching.
% CMDMATCH(A,B) returns 1 if B matches the first length(B) characters
% of A and 0 otherwise.

% Version 2.1, 8 September 1995
% Part of the Styled Text Toolbox
% Copyright 1995 by Douglas M. Schwarz.  All rights reserved.
% schwarz@kodak.com

na = length(a);
nb = length(b);

if na >= nb
	m = all(a(1:nb) == b);
else
	m = 0;
end
